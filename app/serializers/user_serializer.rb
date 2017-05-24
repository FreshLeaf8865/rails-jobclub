class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :avatar_url

  def avatar_url
    ApplicationController.helpers.model_image(object.avatar, 200, 200, true)
  end
end
