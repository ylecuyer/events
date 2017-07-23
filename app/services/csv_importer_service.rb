class CsvImporterService

  def initialize(params)
    @event = Event.find params[:event_id]
    @category = Category.find params[:category_id]
    @send_invites = params[:send_invites]
    @file = params[:file]
  end

  def import
    open_uploaded_file
    import_rows
  end

  private

	def import_rows
		(2..@spreadsheet.last_row).map do |row_number|
			row = get_row(row_number)
			row[:event] = @event
			row[:category] = @category
			attendee = Attendee.create!(row) 
      if @send_invites
        SendInvitationJob.perform_later(@event.id, attendee.id)
      end
		end
    @spreadsheet.last_row - 1
	end

	def open_uploaded_file
		get_spreadsheet
		get_header_from_spreadsheet
    check_file
	end

	def check_file
		check_header @header
		check_rows @spreadsheet
	end

	def check_rows(spreadsheet)
		(2..@spreadsheet.last_row).map do |row_number|
			check_row(row_number, get_row(row_number))
		end
	end

	def get_row(row_number)
		Hash[[@header, @spreadsheet.row(row_number)].transpose]
	end

	def check_row(row_number, row_data)
		if row_data["first_name"].blank?
      raise "first_name can't be empty in row ##{row_number}" 
    end

    if row_data["last_name"].blank?
      raise "last_name can't be empty in row ##{row_number}"
    end

    if row_data["email"].blank?
      raise "email can't be empty in row ##{row_number}"
    end

    unless EmailValidator.valid?(row_data["email"])
      raise "email(#{row_data["email"]}) is malformed in row ##{row_number}"
    end
	end

	def check_header(header)
		required_fields = ["first_name", "last_name", "email"]

		required_fields.each do |field|
			raise "Missing field: #{field}" unless header.include? field 
		end
	end

	def get_spreadsheet
		@spreadsheet = Roo::Spreadsheet.open(@file)
	end

	def get_header_from_spreadsheet
		@header = @spreadsheet.row(1)
	end 

end
