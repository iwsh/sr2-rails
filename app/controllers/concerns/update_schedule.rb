module UpdateSchedule
  extend ActiveSupport::Concern

  def updateSchedule(scheduleInfo)
    begin
      ActiveRecord::Base.transaction do
        scheduleForId = Schedule.where(id: scheduleInfo[:id], user_id: scheduleInfo[:user_id])
        scheduleContentId = scheduleForId[0].content_id

        scheduleContent = ScheduleContent.find_by(id: scheduleContentId)
        scheduleContent.update!(
          title: scheduleInfo[:title],
          started_at: scheduleInfo[:started_at],
          ended_at: scheduleInfo[:ended_at],
          detail: scheduleInfo[:detail],
          updated_at: DateTime.now
        )

        schedule = Schedule.find_by(id: scheduleInfo[:id])
        schedule.update!(
          date: scheduleInfo[:date],
          content_id: scheduleContentId,
          updated_at: DateTime.now
        )
      end
    rescue ActiveRecord::RecordInvalid => e
      render status: :internal_server_error
    end
  end
end