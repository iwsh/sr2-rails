require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get getSchedules" do
    get schedules_getSchedules_url
    assert_response :success
  end

  test "should get postSchedules" do
    get schedules_postSchedules_url
    assert_response :success
  end

  test "should get putSchedules" do
    get schedules_putSchedules_url
    assert_response :success
  end

  test "should get deleteSchedules" do
    get schedules_deleteSchedules_url
    assert_response :success
  end

end
