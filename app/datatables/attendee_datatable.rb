class AttendeeDatatable < AjaxDatatablesRails::Base

  # include AjaxDatatablesRails::Extensions::Kaminari

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        email: record.email,
        first_name: record.first_name,
        last_name: record.last_name
      }
    end
  end

  private

  def get_raw_records
    Attendee.all
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
