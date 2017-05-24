module LinkHelper
  def link_host(url)
    return if url.blank?
    uri = URI.parse(url)
    uri = URI.parse("http://" + url) if uri.scheme.blank?
    return uri.host.gsub("www.","")
  end

  def link_display(url)
    return if url.blank?
    uri = URI.parse(url)
    uri = URI.parse("http://" + url) if uri.scheme.blank?
    return uri.host.gsub("www.","") + uri.path
  end
end