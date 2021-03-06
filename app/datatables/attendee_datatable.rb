class AttendeeDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :image_tag
  def_delegator :@view, :link_to

  def_delegator :@view, :edit_event_attendee_path
  def_delegator :@view, :ticket_event_attendee_path
  def_delegator :@view, :send_invitation_event_attendee_path
  def_delegator :@view, :check_invitation_status_event_attendee_path
  def_delegator :@view, :logs_event_attendee_path
  def_delegator :@view, :checkin_event_attendee_path

  def actions(record)
    str = ''
    str += link_to edit_event_attendee_path(record.event_id, record), class: 'btn btn-secondary btn-sm' do
      '<i class="fa fa-pencil" aria-hidden="true"></i> Edit'.html_safe
    end
    str += link_to ticket_event_attendee_path(record.event_id, record), class: 'btn btn-secondary btn-sm' do
      '<i class="fa fa-ticket" aria-hidden="true"></i> View ticket'.html_safe
    end
    str += link_to send_invitation_event_attendee_path(record.event_id, record), method: :post, class: 'btn btn-secondary btn-sm' do
      '<i class="fa fa-envelope-o" aria-hidden="true"></i> Send invitation'.html_safe
    end
    str += link_to 'Check invitation status', check_invitation_status_event_attendee_path(record.event_id, record), method: :post, class: 'btn btn-secondary btn-sm'
    str += link_to logs_event_attendee_path(record.event_id, record), class: 'btn btn-sm btn-secondary' do
      '<i class="fa fa-file-text-o" aria-hidden="true"></i> View logs'.html_safe
    end

    unless record.checkin_at
      str += link_to checkin_event_attendee_path(record.event_id, record), class: 'btn btn-sm btn-secondary' do
        '<i class="fa fa-check-circle" aria-hidden="true"></i> Checkin'.html_safe
      end
    end

    str.html_safe
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      status: { source: 'Attendee.id', searchable: false, orderable: false },
      reference: { source: 'Attendee.reference' },
      last_name: { source: 'Attendee.last_name' },
      first_name: { source: 'Attendee.first_name' },
      email: { source: 'Attendee.email' },
      category_name: { source: 'Category.name', searchable: false, orderable: false },
      actions: { source: 'Attendee.category.name', searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        status: image_tag(record.status_icon_name, alt: record.invitation_status, title: record.invitation_status),
        reference: record.reference,
        last_name: record.last_name,
        first_name: record.first_name,
        email: record.email,
        category_name: record.category.name,
        actions: actions(record)
      }
    end
  end

  private

  def get_raw_records
    Event.find(options[:event_id]).attendees.select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)")
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
