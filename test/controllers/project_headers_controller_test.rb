require 'test_helper'

class ProjectHeadersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_header = project_headers(:one)
  end

  test "should get index" do
    get project_headers_url
    assert_response :success
  end

  test "should get new" do
    get new_project_header_url
    assert_response :success
  end

  test "should create project_header" do
    assert_difference('ProjectHeader.count') do
      post project_headers_url, params: { project_header: { name: @project_header.name } }
    end

    assert_redirected_to project_header_url(ProjectHeader.last)
  end

  test "should show project_header" do
    get project_header_url(@project_header)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_header_url(@project_header)
    assert_response :success
  end

  test "should update project_header" do
    patch project_header_url(@project_header), params: { project_header: { name: @project_header.name } }
    assert_redirected_to project_header_url(@project_header)
  end

  test "should destroy project_header" do
    assert_difference('ProjectHeader.count', -1) do
      delete project_header_url(@project_header)
    end

    assert_redirected_to project_headers_url
  end
end
