module ApplicationHelper

  # Given a news article, return (if it has one), its published_on block content, otherwise its created_at.
  def news_published_on(page)
    published_on = page.blocks.find {|b| b.identifier == 'published_on' }
    if !!published_on
      c = published_on.content
      y, m, d, h, i, s = c[0,4], c[5,2], c[8,2], c[11,2], c[14,2], c[17,2]
      Time.new(y, m, d, h, i, s)
    else
      page.created_at
    end
  end

  # Grab the headlines and dates of the five most recent news article pages.
  # This isn't the most computationally efficient, as it returns the entire news table.
  def recent_news
    news_pages = @cms_site.pages.find do |page|  # Grab the sub-pages of the 'news' page...
      page.label == 'news'

    end

    if news_pages
      news_pages.children.find_all do |page|
        page.is_published?

      end.sort do |page1, page2|                   # ...order them by either published or creation date, descending...
        news_published_on(page2).to_i <=> news_published_on(page1).to_i

      end.take(5).map do |page|            # ...grab the first five and return their label and creation date.

        {
          label: page.label,
          slug:  page.slug, 
          date:  news_published_on(page).strftime('%F')
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
      news_pages.children.find_all do |page|
        page.is_published? 

      end.sort do |page1, page2|           # ...order them by either published or creation date, descending...
        news_published_on(page2).to_i <=> news_published_on(page1).to_i

      end.map do |page|
        content = page.blocks.map do |block|
          block.content
        end.join
        
        # Grab every <img> element
        images = Nokogiri::HTML(content).css('img')

        # Grab either the page's first image, or if it doesn't have one, one of the default_news
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
          label:     page.label,
          slug:      page.slug,
          image_src: image_src,
          content:   content,
          date:      news_published_on(page).strftime("%F")
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
