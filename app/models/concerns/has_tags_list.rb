module HasTagsList
  extend ActiveSupport::Concern

  module ClassMethods
    
    def has_tags_list(method)
      define_method("#{method}_list=") do |value|
        self.send "#{method}=", value.split(",").map!(&:strip)
      end

      define_method("#{method}_list") do
        self.public_send("#{method}").join(", ")
      end
    end

  end
end
