class TorrentsController < ApplicationController

  layout 'application'

  def main
    render 'main'
  end

  def search
    q =  prepare_query(params[:q])
    Query.create q
    @torrents = Torrent.by_query(q ,params[:page])
    render partial: 'index'
  end

  def autocomplete
    render json: Query.autocomplete(prepare_query(params[:q]))
  end

  private

  def torrent_params
    params.require(:torrent).permit(:title, :description, :size, :href, :magnet, :seeds, :leech, :images, :category)
  end

  def prepare_query q
    q.downcase.strip
  end
end

