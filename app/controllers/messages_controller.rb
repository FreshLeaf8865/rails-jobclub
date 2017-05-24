class MessagesController < ApplicationController
  before_action :authenticate_user!

  # TODO - No need of create action now because we have moved this to
  #        ActionCable and messages are being created via ConversationsChannel
  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to @message.conversation
    else
      render :new
    end
  end


  private
    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:text, :conversation_id)
    end
end
