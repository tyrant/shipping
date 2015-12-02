class NewsController < ApplicationController

  # Grab and return a group of news article json - the preceding 12
  # articles from the given timestamp. If no timestamp is supplied,
  # return the most recent 12.
  # The timestamp measures published_at.
  # The timestamp fired off is the date of the earliest article currently shown
  # on the News page - so we'll want the 12 articles before but not including that one.

  # Params: before (timestamp (integer)).
  def index

    # Grab the master News page's children...
    news_pages = Comfy::Cms::Page.where(label: 'news').first.children

    news_json = if news_pages

      # ...select all articles earlier than the 'before' param...
      news_pages.find_all do |page|
        if params[:before]
          news_published_on(page).to_i < params[:before].to_i
        else
          true
        end

      # ...sort by published/created date, descending...
      end.sort do |page1, page2|
        news_published_on(page2).to_i <=> news_published_on(page1).to_i

      # ...and finally, of those, select the most recent 20 and return their data.
      end[0..19].map do |page|
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
          Comfy::Cms::File.where(1).find_all do |file|
            file.categories.map {|c| c.label }.include? 'default_news'

          end.map do |file|
            file.file.url(:default_news)

          end.shuffle.first
        end

        {
          label:     page.label,
          slug:      page.slug,
          image_src: image_src,
          content:   content,
          date:      news_published_on(page).strftime("%F"),
          timestamp: news_published_on(page).to_i
        }
      end
    else
      []
    end

    render json: news_json
  end


  # Given a news article, return (if it has one), its published_on block content, otherwise its created_at value.
  def news_published_on(page)
    published_on = page.blocks.find {|b| b.identifier == 'published_on' }
    if !!published_on && !published_on.content.blank?
      DateTime.parse published_on.content
    else
      page.created_at
    end
  end
end