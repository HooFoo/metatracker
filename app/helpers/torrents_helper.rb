module TorrentsHelper

  MEDIA_TYPE = {
      :movies => 'video.png',
      :audio => 'audio.png',
      :soft => 'soft.png',
      :series => 'series.png',
      :music => 'music.png',
      :games => 'games.png',
      :books => 'books.png'
  }

  def autocomplete_path
    '/torrents/autocomplete?q=%QUERY'
  end

  def site_favicon link
    if link =~ /https?:\/\/([a-z_-]+)?rutracker\..+/
      'rutracker.ico'
    elsif link =~ /https?:\/\/([a-z_-]+)?rutor\..+/
      'rutor.ico'
    elsif link =~ /https?:\/\/([a-z_-]+)?piratebay\..+/
      'piratebay.ico'
    else
      'unknown.ico'
    end
  end
  def media_type_icon type
    icon_name = MEDIA_TYPE[type.downcase.to_sym]
    icon_name || 'other.png'
  end
end
