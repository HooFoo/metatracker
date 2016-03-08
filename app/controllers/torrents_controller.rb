class TorrentsController < InheritedResources::Base
  respond_to :html
  def main
    render 'main'
  end

  def search
    @torrents = Torrent.all
    render 'index'
  end

  private

    def torrent_params
      params.require(:torrent).permit(:title, :description, :size, :href, :magnet, :seeds, :leech, :images, :category)
    end
end

