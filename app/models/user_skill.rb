class UserSkill < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include Wisper::Publisher
  counter_culture :skill, column_name: :users_count, touch: true
  acts_as_list scope: :user, top_of_list: 0
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Scopes
  scope :by_position, -> { order(position: :asc) }
  scope :by_longest,  -> { order(years: :desc) }

  # Associations
  belongs_to :user
  belongs_to :skill
  delegate :name, to: :skill
  
  # Validations
  validates :user, presence: true
  validates :skill, presence: true
  validates :skill_id, uniqueness: { scope: :user_id }
  validates :years, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    self.subscribe(UserSkillListener.new)
  end

  def broadcast_update
    broadcast(:update_user_skill, self)
  end

  def name_years
    if skill.present?
      return "#{skill.name} : #{years}"
    end
  end

  def name_years=(input)
    split = input.split(":")
    skill_name = split[0].strip
    found_skill = Skill.search_by_exact_name(skill_name).first
    if found_skill
      self.skill = found_skill
      if split[1]
        found_years = split[1].strip.to_i 
        self.years = [found_years,0].max
      end
    end
  end

  def bar_width
    return 0 if years == 0
    years / 10.0 * 100
  end

end
