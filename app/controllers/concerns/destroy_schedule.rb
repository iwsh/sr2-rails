module DestroySchedule
  extend ActiveSupport::Concern

  def destroySchedule(ids)
    begin
      ActiveRecord::Base.transaction do
        selectedDeleteScheduleId = ids[:id]
        isDeleteAll = 1
        userId = ids[:user_id]

        selectedDeleteSchedule = Schedule.where(id: selectedDeleteScheduleId, user_id: userId)
        selectedDeleteScheduleContentId = selectedDeleteSchedule[0].content_id

        if isDeleteAll == 1
          @schedule = Schedule.where(content_id: selectedDeleteScheduleContentId)
          @schedule.delete_all
        else
          @schedule = Schedule.find_by(id: selectedDeleteScheduleId)
          @schedule.delete
        end

        @scheduleContent = ScheduleContent.find_by(id: selectedDeleteScheduleContentId)
        @scheduleContent.delete
      end
    rescue ActiveRecord::RecordInvalid => e
      render status: :internal_server_error
    end
  end
end