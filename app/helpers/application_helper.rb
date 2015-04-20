module ApplicationHelper

  # Grab the headlines and dates of the five most recent news article pages.
  # This isn't the most computationally efficient, as it returns the entire news table.
  def recent_news
    news_pages = @cms_site.pages.find do |page|  # Grab the sub-pages of the 'news' page...
      page.label == 'news'

    end

    if news_pages 
      news_pages.children.sort do |a, b|                   # ...order them by creation date, descending...
        b.created_at.to_i <=> a.created_at.to_i

      end.take(5).map do |page|                     # ...grab the first five and return their label and creation date.
        {
          label: page.label,
          slug:  page.slug, 
          date:  page.created_at.strftime("%F")
        }
      end
    else 
      []
    end
  end

  # Filter the site files by whether they're categorised as 'ships', and return their URLs.
  def ship_images
    @cms_site.files.find_all do |file|
      file.categories.map {|c| c.label }.include? 'ships'
    end
  end

  def current_link_to(content, url)
    klass = if current_page? url
      'current-page'
    else
      ''
    end
    
    link_to content, url, class: klass
  end

  # For /news. Return an array of page data - label, slug, date, content and an image.
  # Now. Get this, Comfy doesn't actually link pages with images. What it does is
  # embed them in the content HTML. So we're reduced to parsing the content with
  # Nokogiri and doing an <img> tag search.
  # If an article doesn't have any images, use a default news image at random.
  def news_pages   
    news_pages = @cms_site.pages.find do |page|
      page.label == 'news'

    end

    if news_pages
      news_pages.children.map do |article|
        content = article.blocks.map do |block|
          block.content
        end.join
        
        # Grab every <img> element
        images = Nokogiri::HTML(content).css('img')

        # Grab either the article's first image, or if it doesn't have one, one of the default_news
        # images at random.
        image_src = if images.length > 0
          images.first['src']
        else
          @cms_site.files.find_all do |file|
            file.categories.map {|c| c.label }.include? 'default_news'
          end.shuffle!.map do |file|
            file.file.url(:default_news)
          end.first
        end

        {
          label:     article.label,
          slug:      article.slug,
          image_src: image_src,
          content:   content,
          date:      article.created_at.strftime("%F")
        }
      end
    else 
      []
    end
  end

  def slugify(string)
    string.parameterize
  end
end
