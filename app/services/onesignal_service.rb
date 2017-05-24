class OnesignalService

  def self.base_url
    "https://onesignal.com/api/v1/"
  end

  def self.client
    @@client ||= OneSignal::OneSignal.api_key = Rails.application.secrets.onesignal_api_key
  end

  def self.create_notification(params)
    self.client
    params[:app_id] = Rails.application.secrets.onesignal_app_id
    puts "OnesignalService.create_notification #{params.inspect}"
    begin
      response = OneSignal::Notification.create(params: params)
      Rails.logger.info(response.body.inspect)
      notification_id = JSON.parse(response.body)["id"]
    rescue OneSignal::OneSignalError => e
      puts "--- OneSignalError  :"
      puts "-- message : #{e.message}"
      puts "-- status : #{e.http_status}"
      puts "-- body : #{e.http_body}"
    end 
  end

  def self.create_notification_for(user,params)
    params[:filters] = [
        {
          field: 'tag',
          key: 'user_id',
          relation: "=",
          value: user.id
        }
      ]
    self.create_notification(params)
  end

  def self.update_player(id, params)
    self.client
    params[:app_id] = Rails.application.secrets.onesignal_app_id
    puts "OnesignalService.update_player id: #{id}, #{params.inspect}"
    begin
      response = OneSignal::Player.update(id: id, params: params)
      json = JSON.parse(response.body)
      puts json.inspect
    rescue OneSignal::OneSignalError => e
      puts "--- OneSignalError  :"
      puts "-- message : #{e.message}"
      puts "-- status : #{e.http_status}"
      puts "-- body : #{e.http_body}"
    end 
  end

  def self.send(notification, title, url=nil, deep_link=nil)
    params = {
      contents: {
        en: title
      },
      ios_badgeType: 'Increase',
      ios_badgeCount: 1,
      url: url,
      data: {
        deep_link: deep_link,
        payload: notification.payload
      }
    }
    OnesignalService.create_notification_for(notification.user, params)
  end

  
end