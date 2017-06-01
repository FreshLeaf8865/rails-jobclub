class TitleCountJob < ApplicationJob
  queue_as :default

  def perform(current_user)
      ActionCable.server.broadcast "Title Update:#{current_user.id}", {
        total_count: current_user.total_unread_msg_count
      }
  end
end
