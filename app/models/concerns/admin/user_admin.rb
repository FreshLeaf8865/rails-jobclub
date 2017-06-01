module Admin::UserAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      weight -1000

      list do
        scopes [nil, :normal, :admin, :moderators, :reviewers]
        
        field :id
        field :avatar do
          pretty_value do
            src = bindings[:view].model_image(bindings[:object], 200, 200)
            bindings[:view].tag(:img, { :src => src })
          end
        end
        field :email
        field :username
        field :name
        field :last_sign_in_at
        field :created_at
        field :updated_at
      end

      edit do
        group :account do
          field :email
          field :username
          field :name
          field :avatar
          field :password
          field :company
          field :location

          field :is_admin
          field :is_moderator
          field :is_reviewer
        end

        group :profile do
          field :gender
          field :bio
          field :is_available
          field :is_hiring
          field :open_to_remote
          field :open_to_full_time
          field :open_to_part_time
          field :open_to_contract
          field :open_to_internship
          field :open_to_relocation
          field :open_to_new_opportunities
          field :is_us_work_authorized
          field :requires_us_visa_sponsorship
        end

        group :urls do
          field :website_url
          field :linkedin_url
          field :twitter_url
          field :dribbble_url
          field :github_url
          field :medium_url
          field :facebook_url
          field :instagram_url
          field :imdb_url
        end

        group :metadata do
          field :created_at
          field :updated_at
        end
      end
    end
  end
end
