class BadgeSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :earned_by
end
