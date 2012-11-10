require 'test_helper'

class ForwardsControllerTest < ActionController::TestCase
  setup do
    @forward = forwards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forwards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forward" do
    assert_difference('Forward.count') do
      post :create, forward: { destination: @forward.destination, name: @forward.name }
    end

    assert_redirected_to forward_path(assigns(:forward))
  end

  test "should show forward" do
    get :show, id: @forward
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forward
    assert_response :success
  end

  test "should update forward" do
    put :update, id: @forward, forward: { destination: @forward.destination, name: @forward.name }
    assert_redirected_to forward_path(assigns(:forward))
  end

  test "should destroy forward" do
    assert_difference('Forward.count', -1) do
      delete :destroy, id: @forward
    end

    assert_redirected_to forwards_path
  end
end
