class WebHooksController < ApplicationController

  def receive_page_data
    Rails.logger.debug params.inspect
    rec = params
    begin
      img = rec[:ParsedContent][:Members][:Image]
      images = []
      unless img.nil?
        images = img.split(',')
      end
      Torrent.new(:sub_category => rec[:SubCategory],
                  :href => rec[:SiteUrl],
                  :category => rec[:Category],
                  :images => images,
                  :title => rec[:ParsedContent][:Members][:Header],
                  :description => rec[:ParsedContent][:Members][:Description],
                  :size => rec[:ParsedContent][:Members][:Size],
                  :magnet => rec[:ParsedContent][:Members][:MagnetLink],
                  :other => rec[:ParsedContent][:Members][:Properties]).save!
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
