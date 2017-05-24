class StorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :cover_uid, :published_on, :content
  has_one :user
end
