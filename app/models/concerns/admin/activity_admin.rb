module Admin::ActivityAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      list do
        scopes [nil, :published, :unpublished, :only_private]
        
        field :id
        field :key
        field :owner
        field :trackable
        field :created_at
      end
    end
  end
end