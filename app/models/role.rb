class Role < ApplicationRecord
  # Extensions
  include Admin::RoleAdmin
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_tree order: "name"

  # Scopes
  scope :by_users,            -> { order(users_count: :desc) }
  scope :recent,              -> { order(created_at: :desc) }
  scope :oldest,              -> { order(created_at: :asc) }
  scope :alphabetical,        -> { order(name: :asc) }
  scope :without_parent,      -> { where(parent_id: nil) }

  # Associations
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}


  def self.seed
    file_name = "roles.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    lines = CSV.read(csv_file)

    lines.each do |line|
      name = line[0]
      parent_name = line[1]

      if parent_name.present? && parent_name != "null"
        parent = Role.search_by_exact_name(parent_name).first
      end

      Role.where(name: name, parent: parent).first_or_create
    end
   
  end
end
