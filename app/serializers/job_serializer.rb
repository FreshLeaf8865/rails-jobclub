class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :link
  has_one :company
  has_one :user
end
