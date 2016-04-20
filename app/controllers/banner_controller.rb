class BannerController < ApplicationController

  def banner
    type = params[:type]
    @banner = prepare_banner
    render "banner_#{type}", layout: false
  end

  private

  def prepare_banner
    banner = Hashie::Mash.new
    banner.link = 'https://sociale.space/?ref=hyipworld'
    banner.img = 'https://sociale.space/img/k2728rus.gif'
    banner
  end
end
