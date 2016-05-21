class BannerController < ApplicationController

  layout 'banners'
  def banner
    type = params[:type]
    @banner = prepare_banner
    render "banner_#{type}"
  end

  private

  def prepare_banner
    banner = Hashie::Mash.new
    banner.link = 'https://global-market.net/'
    banner.img = 'https://global-market.net/b728.gif'
    banner
  end
end
