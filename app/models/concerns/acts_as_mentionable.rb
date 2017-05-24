module ActsAsMentionable
  extend ActiveSupport::Concern

  included do
    has_many :mentions, class_name: "Mention", as: :mentionable, dependent: :destroy
  end

  def mentionable?
    true
  end
  
  def mentions_text(input)
    @mentions_text ||= begin
      regex = /@([\w\.\-]+)/
      input.scan(regex).flatten
    end
  end
  
end
