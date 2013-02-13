class PagesController < ApplicationController
  def home
  end

  def jobs
  end

  def monthly
  end

  def privacy
  end

  def airport
  end

  def contact
  end

  def about
  end

  def daily
  end

  def dailysearch
  end
  
  def daily_search
    @links = Spider.search("miami")
  end
end
