module HasSmartUrl
  extend ActiveSupport::Concern

  module ClassMethods

    def has_smart_url(method)
      define_method("#{method}=") do |value|
        if value.present?
          value = URI.encode(value.strip)
          uri = URI.parse(value)
          uri = URI.parse("http://" + value) if (uri.scheme.blank?)

          if uri.host.present? && value.match(/\.\S+/)
            self.write_attribute(method, uri.to_s)
          end
        else 
          self.write_attribute(method, nil)
        end
      end
    end

  end
end
