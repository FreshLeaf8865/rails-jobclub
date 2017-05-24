module FeedDisplayable
  extend ActiveSupport::Concern

  def feed_display_class
    self.class.name.downcase
  end
end
