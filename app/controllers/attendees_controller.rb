class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :destroy]

  def index
	  @event = Event.find params[:event_id]
	  
	  authorize @event

	  @attendees = @event.attendees
    @total = @event.attendees.count
    @sent = @event.attendees.where.not(mailgun_id: nil).count
    @delivered = @event.attendees.joins(:logs).where("cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id)").where("logs.json->>'event' = ?", 'delivered').count
    @failed = @event.attendees.joins(:logs).where("cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id)").where("logs.json->>'event' = ?", 'failed').where("logs.json->>'severity' = ?", 'permanent').count
    @warning = @event.attendees.joins(:logs).where("cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id)").where("logs.json->>'event' = ?", 'failed').where("logs.json->>'severity' = ?", 'temporary').count

    respond_to do |format|
      format.html
      format.json { render json: AttendeeDatatable.new(view_context, {event_id: @event.id }) }
    end

  end

  def new
	  @event = Event.find params[:event_id]
	  authorize @event
	  @attendee = Attendee.new
  end

  def edit
	  @event = Event.find params[:event_id]
	  authorize @event
	  @attendee = Attendee.find params[:id]
  end

  def update

    authorize Attendee

    @event = Event.find params[:event_id]

    @attendee = Attendee.find params[:id]

    if @attendee.update(attendee_params)
      redirect_to event_attendees_path(@event), notice: 'Attendee was successfully updated.'
    else
      render :edit
    end
  end

  def create

    authorize Attendee

    @event = Event.find params[:event_id]

    @attendee = Attendee.new(attendee_params)
    @attendee.event = @event

    if @attendee.save
      SendInvitationJob.perform_later(params[:event_id], @attendee.id) if params[:attendee][:send_invite] == "1"
      redirect_to event_attendees_path(@event), notice: 'Attendee was successfully created.'
    else
      render :new
    end
  end

  def ticket
    @event = Event.find params[:event_id]
    @attendee = Attendee.find params[:id]
    authorize @attendee
    @qrcode = RQRCode::QRCode.new("http://attendize.ambafrance.co/events/#{@event.id}/validate?ref=#{@attendee.reference}")
    respond_to do |format|	  
      format.html do
        render layout: false
      end
      format.pdf do
        render pdf: "ticket", locals: { attendee: @attendee, event: @event, qrcode: @qrcode }
      end
    end
  end

  def send_invitation

    @attendee = Attendee.find params[:id]
    authorize @attendee

    SendInvitationJob.perform_later params[:event_id], params[:id]
    redirect_to event_attendees_path(params[:event_id])

  end

  def check_invitation_status

    event = Event.find params[:event_id]
    attendee = Attendee.find params[:id]

    authorize attendee

    mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
    mg_events = Mailgun::Events.new(mg_client, ENV['MAILGUN_DOMAIN'])

    result = mg_events.get({"message-id" => attendee.mailgun_id})

    loop do

      result.to_h['items'].reverse_each do |item|
        SaveLogJob.perform_later(item)
      end

      result = mg_events.next
      break unless result.to_h['items'].count > 0
    end

    redirect_to event_attendees_path(params[:event_id])
  end

  def logs
    @attendee = Attendee.find params[:id]
    authorize @attendee
  end


  private
  def attendee_params
    params.require(:attendee).permit(:first_name, :last_name, :email, :category_id)
  end
end
