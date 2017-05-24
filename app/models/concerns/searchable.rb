module Searchable
  extend ActiveSupport::Concern

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

    def search_by_name(query)
      where("#{self.table_name}.name ILIKE ?", "%#{query}%")
    end

    def search_by_exact_name(query)
      where("lower(#{self.table_name}.name) = ?", query.downcase)
    end
  end

end