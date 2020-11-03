module SetScheduleById
  extend ActiveSupport::Concern

  def setScheduleById()
    error = ''
    @schedule = Schedule.find(params[:id])
    if @schedule.blank?
      error = 'not_found'
    elsif @schedule.user_id != @access_user[:id]
      error = 'forbidden'
    else
      @scheduleContent = ScheduleContent.find(@schedule.content_id)
      if @scheduleContent.blank?
        error = 'not_found'
      end
    end
    return error
  end
end