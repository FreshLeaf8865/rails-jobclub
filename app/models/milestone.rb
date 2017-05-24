class Milestone < ApplicationRecord
  WORK = "work"
  EDUCATION = "education"
  KINDS = [
    WORK,
    EDUCATION
  ]

  # Extensions
  include Wisper::Publisher
  include ActsAsLikeable
  include FeedDisplayable
  acts_as_taggable_array_on :skills
  include HasTagsList
  has_tags_list :skills
  
  include HasSmartUrl
  has_smart_url :link

  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }
  
  # Scopes
  scope :by_oldest,     -> { order(start_date: :asc) }
  scope :by_newest,     -> { order(start_date: :desc) }
  scope :printable,     -> { where(printable: :true) }
  scope :work,          -> { where(kind: WORK) }
  scope :education,     -> { where(kind: EDUCATION) }

  # Associations
  belongs_to :user
  belongs_to :company
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user


  # Validations
  validates :user, presence: true
  validates :name, presence: true
  validates :facebook_id, uniqueness: true, allow_blank: true
  validate :skills_exist

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    self.subscribe(MilestoneListener.new)
  end

  def broadcast_update
    broadcast(:update_milestone, self)
  end

  def skills_exist
    skills.each do |name|
      if Skill.search_by_exact_name(name).empty?
        errors.add(:skills, "#{name} isn't a valid skill")
      end
    end
  end
end
