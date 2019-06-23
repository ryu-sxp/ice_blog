require 'test_helper'

class SocialMediaLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @social_media_link = social_media_links(:one)
  end

  test "should get index" do
    get social_media_links_url
    assert_response :success
  end

  test "should get new" do
    get new_social_media_link_url
    assert_response :success
  end

  test "should create social_media_link" do
    assert_difference('SocialMediaLink.count') do
      post social_media_links_url, params: { social_media_link: { name: @social_media_link.name, text: @social_media_link.text, url: @social_media_link.url, user_id: @social_media_link.user_id } }
    end

    assert_redirected_to social_media_link_url(SocialMediaLink.last)
  end

  test "should show social_media_link" do
    get social_media_link_url(@social_media_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_social_media_link_url(@social_media_link)
    assert_response :success
  end

  test "should update social_media_link" do
    patch social_media_link_url(@social_media_link), params: { social_media_link: { name: @social_media_link.name, text: @social_media_link.text, url: @social_media_link.url, user_id: @social_media_link.user_id } }
    assert_redirected_to social_media_link_url(@social_media_link)
  end

  test "should destroy social_media_link" do
    assert_difference('SocialMediaLink.count', -1) do
      delete social_media_link_url(@social_media_link)
    end

    assert_redirected_to social_media_links_url
  end
end
