module UpdateSchedule
  extend ActiveSupport::Concern

  def updateSchedule(scheduleInfo)
    begin
      ActiveRecord::Base.transaction do
        @scheduleContent.update!(
          title: scheduleInfo[:title],
          started_at: scheduleInfo[:started_at],
          ended_at: scheduleInfo[:ended_at],
          detail: scheduleInfo[:detail],
          updated_at: DateTime.now
        )

        @schedule.update!(
          date: scheduleInfo[:date],
          content_id: @scheduleContent.id,
          updated_at: DateTime.now
        )
      end
    rescue ActiveRecord::RecordInvalid => e
      render status: :internal_server_error
    end
  end
end