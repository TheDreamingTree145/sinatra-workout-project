module SlugHelper

  def slug
    name.downcase.gsub(" ", "-")
  end

  def find_by_slug(slug)
    self.all.find {|name| name.slug == slug}
  end

  def name_taken?(params)
    !!self.all.find do |instance|
      instance.name.downcase == params[:name].downcase
    end
  end

end
