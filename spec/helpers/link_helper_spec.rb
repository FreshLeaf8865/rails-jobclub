require 'rails_helper'

describe LinkHelper do
  it "should only get host of a link" do
    expect(link_host("http://www.site.com")).to eq("site.com")

    expect(link_host("http://subdomain.site.com")).to eq("subdomain.site.com")

    expect(link_host("http://site.com/url/page")).to eq("site.com")

    expect(link_host("site.com")).to eq("site.com")

    expect(link_host("site.co.uk")).to eq("site.co.uk")

    expect(link_host("site.co.uk/test")).to eq("site.co.uk")
  end

  it "should display link without http or www" do
    
    expect(link_display("http://www.site.com")).to eq("site.com")

    expect(link_display("http://subdomain.site.com")).to eq("subdomain.site.com")

    expect(link_display("http://site.com/url/page")).to eq("site.com/url/page")

    expect(link_display("site.com")).to eq("site.com")

    expect(link_display("site.co.uk")).to eq("site.co.uk")

    expect(link_display("site.co.uk/test")).to eq("site.co.uk/test")
  end
end
