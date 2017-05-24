class Job < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, squish: true
  include HasSmartUrl
  include ActsAsLikeable
  include FeedDisplayable
  has_smart_url :link
  is_impressionable

  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  include PgSearch
  multisearchable :against => [:name, :skills_list, :user_display_name, :user_username, :company_name, :location_name, :full_time_name, :part_time_name, :remote_name, :contract_name, :internship_name]

  acts_as_taggable_array_on :skills
  include HasTagsList
  has_tags_list :skills

  # Scopes
  scope :recent,          -> { order(created_at: :desc) }
  scope :published,       -> { where.not(published_on: nil) }
  scope :drafts,          -> { where(published_on: nil) }


  # Associations
  belongs_to :company
  belongs_to :user
  belongs_to :role
  belongs_to :location
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user


  # Validations
  validates :user, presence: true
  validates :company, presence: true
  validates :role, presence: true
  validates :location, presence: true
  validates :name, presence: true
  validates_length_of :name, minimum: 6, maximum: 50
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  validate :skills_exist
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def slug_candidates
    [
      [:name, :company_name, :id]
    ]
  end

  def skills_exist
    skills.each do |name|
      if Skill.search_by_exact_name(name).empty?
        errors.add(:skills, "#{name} isn't a valid skill")
      end
    end
  end


  def user_display_name
    user.display_name
  end

  def user_username
    user.username
  end

  def company_name
    company.try(:name)
  end

  def location_name
    location.try(:display_name)
  end

  def full_time_name
    return "full time" if full_time
  end

  def part_time_name
    return "part time" if part_time
  end

  def remote_name
    return "remote" if remote
  end

  def contract_name
    return "contract" if contract
  end

  def internship_name
    return "internship" if internship
  end

  def publish!
    unless published?
      self.published_on = DateTime.now
      self.save
      create_activity_once :publish, owner: self.user, private: false
    end
  end

  def published?
    published_on.present?
  end

  def unpublished?
    published_on.nil? 
  end

end
