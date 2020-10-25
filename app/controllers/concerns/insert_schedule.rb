module InsertSchedule
  extend ActiveSupport::Concern

  def insertSchedule(scheduleInfo)
    begin
      ActiveRecord::Base.transaction do
        ScheduleContent.create!(
          title: scheduleInfo[:title],
          started_at: scheduleInfo[:started_at],
          ended_at: scheduleInfo[:ended_at],
          detail: scheduleInfo[:detail],
          created_at: DateTime.now,
          updated_at: DateTime.now
        )

        Schedule.create!(
          date: scheduleInfo[:date],
          user_id: scheduleInfo[:user_id],
          content_id: ScheduleContent.last.id,
          created_at: DateTime.now,
          updated_at: DateTime.now
        )
      end
    rescue ActiveRecord::RecordInvalid => e
      render status: :internal_server_error
    end
  end
end