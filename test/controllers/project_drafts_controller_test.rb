require 'test_helper'

class ProjectDraftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_draft = project_drafts(:one)
  end

  test "should get index" do
    get project_drafts_url
    assert_response :success
  end

  test "should get new" do
    get new_project_draft_url
    assert_response :success
  end

  test "should create project_draft" do
    assert_difference('ProjectDraft.count') do
      post project_drafts_url, params: { project_draft: { content: @project_draft.content, name: @project_draft.name, published: @project_draft.published } }
    end

    assert_redirected_to project_draft_url(ProjectDraft.last)
  end

  test "should show project_draft" do
    get project_draft_url(@project_draft)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_draft_url(@project_draft)
    assert_response :success
  end

  test "should update project_draft" do
    patch project_draft_url(@project_draft), params: { project_draft: { content: @project_draft.content, name: @project_draft.name, published: @project_draft.published } }
    assert_redirected_to project_draft_url(@project_draft)
  end

  test "should destroy project_draft" do
    assert_difference('ProjectDraft.count', -1) do
      delete project_draft_url(@project_draft)
    end

    assert_redirected_to project_drafts_url
  end
end
