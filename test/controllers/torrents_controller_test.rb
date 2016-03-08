require 'test_helper'

class TorrentsControllerTest < ActionController::TestCase
  setup do
    @torrent = torrents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:torrents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create torrent" do
    assert_difference('Torrent.count') do
      post :create, torrent: { category: @torrent.category, description: @torrent.description, href: @torrent.href, images: @torrent.images, leech: @torrent.leech, magnet: @torrent.magnet, seeds: @torrent.seeds, size: @torrent.size, title: @torrent.title }
    end

    assert_redirected_to torrent_path(assigns(:torrent))
  end

  test "should show torrent" do
    get :show, id: @torrent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @torrent
    assert_response :success
  end

  test "should update torrent" do
    patch :update, id: @torrent, torrent: { category: @torrent.category, description: @torrent.description, href: @torrent.href, images: @torrent.images, leech: @torrent.leech, magnet: @torrent.magnet, seeds: @torrent.seeds, size: @torrent.size, title: @torrent.title }
    assert_redirected_to torrent_path(assigns(:torrent))
  end

  test "should destroy torrent" do
    assert_difference('Torrent.count', -1) do
      delete :destroy, id: @torrent
    end

    assert_redirected_to torrents_path
  end
end
