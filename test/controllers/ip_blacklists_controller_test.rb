require 'test_helper'

class IpBlacklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ip_blacklist = ip_blacklists(:one)
  end

  test "should get index" do
    get ip_blacklists_url
    assert_response :success
  end

  test "should get new" do
    get new_ip_blacklist_url
    assert_response :success
  end

  test "should create ip_blacklist" do
    assert_difference('IpBlacklist.count') do
      post ip_blacklists_url, params: { ip_blacklist: { duration: @ip_blacklist.duration, ip: @ip_blacklist.ip } }
    end

    assert_redirected_to ip_blacklist_url(IpBlacklist.last)
  end

  test "should show ip_blacklist" do
    get ip_blacklist_url(@ip_blacklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_ip_blacklist_url(@ip_blacklist)
    assert_response :success
  end

  test "should update ip_blacklist" do
    patch ip_blacklist_url(@ip_blacklist), params: { ip_blacklist: { duration: @ip_blacklist.duration, ip: @ip_blacklist.ip } }
    assert_redirected_to ip_blacklist_url(@ip_blacklist)
  end

  test "should destroy ip_blacklist" do
    assert_difference('IpBlacklist.count', -1) do
      delete ip_blacklist_url(@ip_blacklist)
    end

    assert_redirected_to ip_blacklists_url
  end
end
