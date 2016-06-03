class WebHooksController < ApplicationController

  MAPPING = {
      :Header => :title,
      :Description => :description,
      :Size => :size,
      :MagnetLink => :magnet,
      :Properties => :other,
      :Image => :images
  }
  def receive_page_data
    rec = params
    begin
      hash = {
          :sub_category => rec[:SubCategory],
          :href => rec[:SiteUrl],
          :category => rec[:Category]
      }
      members = rec[:ParsedContent][:Members]
      members.each do |ent|
        to = MAPPING[ent[:Key].to_sym]
        val_type = ent[:Value][:ValueType]
        vals = ent[:Value][:Value]
        add_to_hash hash,to,vals,val_type
      end
      Torrent.new(hash).save!
      render json: {:result => 'Ok'}
    rescue Exception => e
      Rails.logger.error e.backtrpace
      render json: {:result => 'Error', :message => e.message}
    end
  end

  private

  def add_to_hash(hash, field, values, type)
    arr = JSON.parse values
    if type == 'LinkToFile' || type == 'LinkToInternalStorage'
      hash[field] = arr
    elsif type == 'DateTime'
      hash[field] = DateTime.strptime(arr[0],'%Y-%m-%d %H:%M:%SW')
    else
      hash[field] = arr[0]
    end

  end

  def record_params
    params.permit(:SiteUrl, :Category, :SubCategory, :ParsedContent => {
        :Members => [:Key, :Value, :ValueType]
    })
  end
end
