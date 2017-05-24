class CloudinaryStore

  # Store the data AND meta, and return a unique string uid
  def write(content, opts={})
    result = Cloudinary::Uploader.upload(content.path, :resource_type => :auto)
    Rails.logger.info result.inspect
    uid = result['public_id']
    return uid
  end

  # Retrieve the data and meta as a 2-item array
  def read(uid)
    url = Cloudinary::Utils.cloudinary_url public_id(uid), format: ext(uid) || 'jpg'
    #meta = SomeLibrary.get_meta(uid)
    if url
      [
        Cloudinary::Downloader.download(url),     # can be a String, File, Pathname, Tempfile
        nil      # the same meta Hash that was stored with write
      ]
    else
      nil         # return nil if not found
    end
  end

  def destroy(uid)
    Cloudinary::Uploader.destroy public_id(uid)
  end

  def url_for(uid, options = {})
    options = {format: ext(uid)}.merge(options)
    Cloudinary::Utils.cloudinary_url(public_id(uid), options)
  end

  private

  def public_id(uid)
    File.basename(uid, ext(uid, true))
  end

  def ext(uid, with_dot = false)
    ext = File.extname(uid)
    ext[0] = '' if ext and !with_dot
    ext
  end

end

Dragonfly::App.register_datastore(:cloudinary_store){ CloudinaryStore }