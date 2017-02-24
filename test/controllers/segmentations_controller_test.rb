require 'test_helper'

class SegmentationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @segmentation = segmentations(:one)
  end

  test "should get index" do
    get segmentations_url
    assert_response :success
  end

  test "should get new" do
    get new_segmentation_url
    assert_response :success
  end

  test "should create segmentation" do
    assert_difference('Segmentation.count') do
      @segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
      @segmentation.parameters = '[["SC"], ["30"]]'
      post segmentations_url, params: { segmentation: { description: @segmentation.description, parameters: @segmentation.parameters, query: @segmentation.query, title: @segmentation.title } }
    end

    assert_redirected_to segmentation_url(Segmentation.last)
  end

  test "should show segmentation" do
    get segmentation_url(@segmentation)
    assert_response :success
  end

  test "should get edit" do
    get edit_segmentation_url(@segmentation)
    assert_response :success
  end

  test "should update segmentation" do
    @segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    @segmentation.parameters = '[["SC"], ["30"]]'
    patch segmentation_url(@segmentation), params: { segmentation: { description: @segmentation.description, parameters: @segmentation.parameters, query: @segmentation.query, title: @segmentation.title } }
    assert_redirected_to segmentation_url(@segmentation)
  end

  test "should destroy segmentation" do
    assert_difference('Segmentation.count', -1) do
      delete segmentation_url(@segmentation)
    end

    assert_redirected_to segmentations_url
  end
end
