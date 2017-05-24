class Location < ApplicationRecord
  # Constants
  ROOT = "root"
  COUNTRY = "country"
  STATE = "state"
  CITY = "city"
  NEIGHBORHOOD = "neighborhood"

  VALID_LEVELS = [
    ROOT,
    COUNTRY,
    STATE,
    CITY,
    NEIGHBORHOOD
  ]
  # country codes can be found here
  # https://www.iso.org/obp/ui/#search

  # Associations
  has_many :users
  has_many :jobs
  
  # Extensions
  include Searchable
  extend FriendlyId
  friendly_id :name_and_short, :use => :slugged

  acts_as_tree order: "name"

  # Scope
  scope :by_users_count, -> { order(users_count: :desc) }

  # Validations
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :scope => [:parent_id], :case_sensitive => false
  validates_uniqueness_of :slug, :scope => [:parent_id], :case_sensitive => false
  validates :level, :presence => true,
                            :inclusion => { :in => VALID_LEVELS, :message => "%{value} is not a valid level" }
  validates :facebook_id, uniqueness: {allow_blank: true}

  def should_generate_new_friendly_id?
    name_changed? || parent_id_changed? || short_changed?
  end

  def display_name
    if parent.present? && (level == CITY || level == STATE) 
      return "#{name}, #{parent.short.upcase}" 
    end
    name
  end

  def name_and_short
    return name if parent.nil?
    return "#{name}-#{parent.short}" if parent.short
    return "#{name}-#{parent.name}"
  end

  def name_and_parent
    return name if parent.nil?
    return "#{name}, #{parent.name}"
  end


  def self.create_root
    root = Location.find_or_create_by(name: 'Anywhere', level: Location::ROOT, parent_id: nil)
  end

  def self.import_countries
    self.create_root

    file_name = "countries.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    countries = CSV.read(csv_file)
    countries.each do |data|
      country = Location.find_or_create_by(name: data[0], short: data[1].upcase, level: Location::COUNTRY)
    end
  end

  def self.import_states
    self.import_countries

    file_name = "states.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    states = CSV.read(csv_file)
    states.each do |data|
      country_code = data[2].upcase
      country = Location.where(short: country_code, level: Location::COUNTRY).first

      state = Location.find_or_create_by(name: data[0], short: data[1].upcase, level: Location::STATE, parent_id: country.id)
    end
  end

  def self.import_cities
    self.import_states

    file_name = "cities.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    cities = CSV.read(csv_file)
    cities.each do |data|
      name = data[0]
      state_code = data[1]
      country_code = data[2]
      country = Location.where(short: country_code, level: Location::COUNTRY).first
      state = Location.where(short: state_code, level: Location::STATE, parent_id: country.id).first
      if country && state
        city = Location.find_or_create_by(name: name, level: Location::CITY, parent_id: state.id)
      end
    end
  end

  def self.import_facebook_id(facebook_id)
    puts "Location.import_facebook_id #{facebook_id}"
    return if facebook_id.blank?
    client = FacebookService.get_client
    begin
      fb_page = client.get_object(facebook_id, {fields: "location{city,country, country_code, latitude, longitude, name, region, state}"})
      # puts fb_page.inspect

      fb_location = fb_page["location"]
      if fb_location.present?
        puts fb_location.inspect

        location = Location.where(facebook_id: facebook_id).first_or_initialize

        fb_city = fb_location["city"]
        fb_state = fb_location["state"]
        fb_country = fb_location["country"]
        country_code = fb_location["country_code"]

        if fb_city.present?
          location.level = CITY
          location.name = fb_city

          if fb_state.present?
            state = Location.where(short: fb_state, level: STATE).first
            if state.present?
              found_city = Location.where(name: fb_city, level: CITY, parent: state).first
              if found_city.present?
                location = found_city
              else
                location.parent = state
              end
            else
              # state doesn't exist but country might
              # happens in australia, uk
              country = Location.where(short: country_code, level: COUNTRY).first
              if country.present?
                location.parent = country
              end
            end
          else

            # importing from city with no state
            country = Location.where(short: country_code, level: COUNTRY).first
            if country.present?
              location.parent = country
            end
            
          end
        end
          
        location.facebook_id = facebook_id
        location.save

        #puts location.inspect
        #puts location.errors.full_messages

        return location
      end
    rescue
      message = "Cound not import facebook id: #{facebook_id}" 
      puts message
      puts "   errors = #{e.inspect}"
    end

  end


end
