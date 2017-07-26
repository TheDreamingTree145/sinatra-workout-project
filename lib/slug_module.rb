module SlugHelper

  def slug
    name.downcase.gsub(" ", "-")
  end

  def find_by_slug(slug)
    self.all.find {|name| name.slug == slug}
  end

end
