# Base model from which all other models will inherit
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.paginate_records(total_records, records)
    {
      total_records: total_records,
      records: records
    }
  end
end
