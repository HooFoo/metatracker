class LinksController < ApplicationController

  def magnet
    torrent = Torrent.where( id: params[:torrent_id]).first
    if torrent.present?
      redirect_to torrent.magnet
    else
      render status: 404, :text => 'Not Found'
    end
  end
end
