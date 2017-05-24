module Admin::RoleAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      
      list do
        field :id
        field :name
        field :slug
        field :users_count
        field :parent
        field :created_at
        field :updated_at
      end
    end
  end
end