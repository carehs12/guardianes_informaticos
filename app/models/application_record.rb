# Base model from which all other models will inherit
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.pagination_format(total_records, records)
    {
      total_records: total_records,
      records: records
    }
  end

  def self.paginate_data(data, page, per_page)
    data.limit(per_page).offset((page - 1) * per_page)
  end
end
