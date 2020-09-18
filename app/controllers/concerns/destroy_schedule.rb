module DestroySchedule
  extend ActiveSupport::Concern

  def destroySchedule()
    begin
      ActiveRecord::Base.transaction do
        isDeleteAll = 1

        if isDeleteAll == 1
          @schedule = Schedule.where(content_id: @schedule.content_id)
          @schedule.delete_all
        else
          @schedule.delete
        end

        @scheduleContent.delete
      end
    rescue ActiveRecord::RecordInvalid => e
      render status: :internal_server_error
    end
  end
end