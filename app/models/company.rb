class Company < ApplicationRecord
  # Extensions
  #include Admin::SkillAdmin
  include PgSearch
  multisearchable :against => [:name, :website_url]

  include Searchable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  dragonfly_accessor :avatar
  dragonfly_accessor :logo
  is_impressionable
  acts_as_followable
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model

  include HasSmartUrl
  has_smart_url :website_url
  has_smart_url :twitter_url
  has_smart_url :instagram_url
  has_smart_url :facebook_url
  has_smart_url :angellist_url

  auto_strip_attributes :name, squish: true
  nilify_blanks
  acts_as_taggable_array_on :tags
  include HasTagsList
  has_tags_list :tags

  # Scopes
  scope :by_followers, -> { order(followers_count_cache: :desc) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :oldest,       -> { order(created_at: :asc) }
  scope :alphabetical, -> { order(name: :asc) }

  # Associations
  has_many :milestones, dependent: :nullify
  has_many :projects, dependent: :nullify
  has_many :jobs, dependent: :destroy
  has_many :users
  belongs_to :added_by, class_name: 'User'

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :facebook_id, uniqueness: {allow_blank: true}
  validates :website_url,   url: { allow_blank: true }
  validates :twitter_url,   url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }
  validates :facebook_url,  url: { allow_blank: true }
  validates :angellist_url, url: { allow_blank: true }

  def domain
    URI.parse(website_url).host.downcase if website_url.present?
  end

  def refresh
    if self.facebook_url.present?
      Company.import_facebook_url(self.facebook_url) 
      return true
    end
    return false
  end

  def self.import_facebook_url(url)
    puts "Company.import_facebook_url #{url}"
    client = FacebookService.get_client

    begin
      # fb_page = FacebookService.facebook_client.get_object(url, {"fields"=>"id,name,description,phone,website,location,cover"}) 
      fb_page = client.get_object('', {id: url, fields: "id,username,name,website,link,about,description,founded,location,phone,emails,cover,picture.type(large)"})
      puts fb_page.inspect
      
      facebook_id = fb_page["id"]
      puts "facebook_id #{facebook_id}"

      name = fb_page["name"]
      slug = fb_page["username"]

      if slug.blank?
        company = Company.new(name: name)
        company.send(:set_slug)
        slug = company.friendly_id
      end
      
      puts "name #{name}, slug #{slug}"
      
      company = Company.where('lower(slug) = ? OR facebook_id = ?', slug.downcase, facebook_id).take

      if company.nil? 
        company = Company.create(name: name, slug: slug, facebook_id: facebook_id)
      end
      company.name = name if company.name.blank?
      
      website_url = fb_page["website"]
      if company.website_url.nil? && website_url.present?
        company.website_url = website_url unless website_url.match(/\s/)
      end
      
      company.facebook_url = fb_page["link"] if company.facebook_url.nil? 
      company.tagline = fb_page["about"] if company.tagline.nil?

      if company.avatar_uid.nil? && !fb_page["picture"]["data"]["is_silhouette"]
        picture_url = fb_page["picture"]["data"]["url"]
        company.avatar_url = picture_url
      end
      
      company.save

      puts company.errors.inspect
      return company

    rescue Exception => e
      message = "Cound not import facebook page: #{url}" 
      puts message
      puts "   errors = #{e.inspect}"
    end
  end

  def self.import_facebook_id(facebook_id)
    puts "Company.import_facebook_id #{facebook_id}"
    client = FacebookService.get_client
    begin
      # fb_page = FacebookService.facebook_client.get_object(url, {"fields"=>"id,name,description,phone,website,location,cover"}) 
      fb_page = client.get_object(facebook_id, {fields: "id,username,name,website,link,about,description,founded,location,phone,emails,cover,picture.type(large)"})
      puts fb_page.inspect
      
      name = fb_page["name"]
      slug = fb_page["username"]
      
      if slug.blank?
        company = Company.new(name: name)
        company.send(:set_slug)
        slug = company.friendly_id
      end
      
      puts "name #{name}, slug #{slug}"
      company = Company.where('lower(slug) = ? OR facebook_id = ?', slug.downcase, facebook_id).take

      if company.nil? 
        company = Company.create(name: name, slug: slug, facebook_id: facebook_id)
      end
      company.name = name if company.name.blank?
      
      website_url = fb_page["website"]
      if company.website_url.nil? && website_url.present?
        company.website_url = website_url unless website_url.match(/\s/)
      end

      company.facebook_url = fb_page["link"] if company.facebook_url.nil? 
      company.tagline = fb_page["about"] if company.tagline.nil?

      if company.avatar_uid.nil? && !fb_page["picture"]["data"]["is_silhouette"]
        picture_url = fb_page["picture"]["data"]["url"]
        company.avatar_url = picture_url
      end
      
      company.save
      company
    rescue Exception => e
      message = "Cound not import facebook id: #{facebook_id}" 
      puts message
      puts "   errors = #{e.inspect}"
    end

  end

  def self.import
    file_name = "companies.json"
    path = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    return if !File.exist?(path)

    json = JSON.parse(open(path).read)
    json.each do |data|
      company = Company.where(:name => data["name"], :slug => data["slug"]).first_or_create

      company.twitter_url   = data["twitter_url"] if company.twitter_url.blank?
      company.facebook_url  = data["facebook_url"] if company.facebook_url.blank?
      company.instagram_url = data["instagram_url"] if company.instagram_url.blank?
      company.angellist_url = data["angellist_url"] if company.angellist_url.blank?
      company.website_url   = data["website_url"] if company.website_url.blank?
      company.tagline   = data["tagline"] if company.tagline.blank?
      # company.verified = data["verified"]
      # company.color = data["color"]
      
      company.save
    end
  end
end
