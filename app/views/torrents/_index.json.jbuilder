json.array!(@torrents) do |torrent|
  json.extract! torrent, :id, :title, :description, :size, :href, :magnet, :seeds, :leech, :images, :category
end
