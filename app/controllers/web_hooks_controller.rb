class WebHooksController < ApplicationController

  def receive_page_data
    Rails.logger.debug params.inspect
    rec = params
    begin
      Torrent.new(:title => rec[:ParsedContent][:Members][:Header],
                  :description => rec[:SubCategory],
                  :href => rec[:SiteUrl],
                  :category => rec[:Category],
                  :magnet => rec[:ParsedContent][:Members][:MagnetLink]).save!
      render json: {:result => 'Ok'}
    rescue Exception => e
      Rails.logger.error e.backtrace
      render json: {:result => 'Error', :message => e.message}
    end

  end

  private

  def record_params
    params.require(:record).permit(:SiteUrl, :Category, :SubCategory, :ParsedContent => {
        :Members => [:Header, :MagnetLink]
    })
  end
end
