xml.instruct! :xml, :version => "1.0"
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  for page in @microblogs do
    xml.url do
      xml.loc request.protocol + request.host_with_port + microblog_path(page)
      xml.lastmod page.updated_at.to_date
      xml.changefreq "monthly"
      xml.priority "0.5"
    end
  end
  for page in @microposts do
    xml.url do
      xml.loc request.protocol + request.host_with_port + micropost_path(page)
      xml.lastmod page.updated_at.to_date
      xml.changefreq "monthly"
      xml.priority "0.5"
    end
  end
end
