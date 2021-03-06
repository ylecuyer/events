class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:validate]
  skip_after_action :verify_authorized, only: [:validate]

  # GET /events
  # GET /events.json
  def index
    authorize Event
    @events = Event.order(start: :desc).page params[:page]
  end

  # GET /events/1
  # GET /events/1.json
  def show
    authorize @event
  end

  # GET /events/new
  def new
    authorize Event
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    authorize @event
  end

  # POST /events
  # POST /events.json
  def create
    authorize Event
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    authorize @event

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_invitations_status
    event = Event.find params[:id]

    authorize event

    CheckInvitationsStatusJob.perform_later(params[:id])

    redirect_to event_attendees_path(params[:id]), notice: 'Invitations status checking in progress'
  end

  def send_invitations
    event = Event.find params[:id]

    authorize event

    attendees = event.attendees.where(mailgun_id: nil)

    attendees.each do |attendee|
      SendInvitationJob.perform_later(event.id, attendee.id)
    end

    redirect_to event_attendees_path(params[:id]), notice: "#{attendees.count} invitations queued"
  end

  def checkin
    @event = Event.find params[:id]
    authorize @event
  end

  def print_list
    @event = Event.find params[:id]
    authorize @event
    render layout: false
  end

  def do_mailtester
    event = Event.find params[:id]
    authorize event

    attendee = Attendee.dummy
    to = "#{ENV['MAILTESTER_LOGIN']}-Event#{event.id}@mail-tester.com"

    MailGeneratorService.new(event: event, attendee: attendee, to: to).generate_and_send_now

    redirect_to mailtester_event_path(params[:id]), notice: 'Mail sent to mailtester for testing'
  end

  def send_test_mail
    event = Event.find params[:id]
    authorize event
    email = params[:email]

    attendee = Attendee.dummy

    MailGeneratorService.new(event: event, attendee: attendee, to: email).generate_and_send_now

    redirect_to event, notice: "Test mail sent to #{email}"
  end

  def import_csv
    @event = Event.find params[:id]
    authorize @event
  end

  def export_csv
    @event = Event.find params[:id]
    authorize @event

    columns = [:first_name, :last_name, :email, :reference, :category, :checkin_at]

    @csv = CSV.generate do |csv|
      csv << columns
      @event.attendees.each do |attendee|
        csv << [attendee.first_name, attendee.last_name, attendee.reference, attendee.email, attendee.category.name, attendee.checkin_at]
      end
    end

    send_data @csv, filename: 'export.csv'
  end

  def export_failed
    @event = Event.find params[:id]
    authorize @event

    @failed = @event.attendees.select("attendees.first_name, attendees.last_name, attendees.email, attendees.category_id, logs.json->'delivery-status'->>'message' as message, logs.json->'delivery-status'->>'description' as description").joins(:logs).where("cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id)").where("logs.json->>'event' = ?", 'failed').where("logs.json->>'severity' = ?", 'permanent')

    columns = [:first_name, :last_name, :email, :category, :message, :description]

    @csv = CSV.generate do |csv|
      csv << columns
      @failed.each do |attendee|
        csv << [attendee.first_name, attendee.last_name, attendee.email, attendee.category.name, attendee.message, attendee.description]
      end
    end

    send_data @csv, filename: 'export_failed.csv'
  end

  def do_import_csv
    @event = Event.find params[:id]
    authorize @event

    @category = Category.find params[:category_id]
    @send_invites = params[:send_invites] == '1'

    csv_importer = CsvImporterService.new(file: params[:file], event_id: params[:id], category_id: params[:category_id], send_invites: params[:send_invites] == '1')

    begin
      count = csv_importer.import
      redirect_to event_attendees_path(params[:id]), notice: "#{count} attendees added"
    rescue Exception => e
      flash[:error] = "#{e.class} - #{e.message}"
      render :import_csv
    end
  end

  def mailtester
    @event = Event.find params[:id]
    authorize @event

    @result = MailtesterService.new(event: @event).result
  end

  def validate
    @event = Event.find params[:id]
    @attendee = @event.attendees.where(reference: params[:ref]).first

    ticket_validator = TicketValidatorService.new(event: @event, attendee: @attendee)
    ticket_validator.validate

    @is_valid = ticket_validator.is_valid?
    @message = ticket_validator.message

    render layout: false
  end

  def ticket
    authorize Event
    code = params[:code]

    @attendee = Attendee.dummy

    @qrcode = RQRCode::QRCode.new("http://attendize.ambafrance.co/example_validate?ref=#{code}")
    render 'attendees/ticket', layout: false, locals: { attendee: @attendee, event: @attendee.event, qrcode: @qrcode }
  end

  def live
    @event = Event.find params[:id]
    authorize @event

    @checkedin = @event.attendees.where.not(checkin_at: nil).count
    @total = @event.attendees.count
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :subject, :model, :start, :end, :venue, :image)
  end
end
