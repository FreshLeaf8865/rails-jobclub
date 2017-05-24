class Skill < ApplicationRecord
  # Extensions
  include Admin::SkillAdmin
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Scopes
  scope :by_users,     -> { order(users_count: :desc) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :oldest,       -> { order(created_at: :asc) }
  scope :alphabetical, -> { order(name: :asc) }

  # Associations
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}

  def self.seed
    names = %w(Design Development Rails Branding HTML CSS Acting Branding Elixir Javascript Marketing Modeling Phoenix Python Rails Ruby Sales SEO)
    names.each do |name|
      Skill.where(name: name).first_or_create
    end    
  end
end
