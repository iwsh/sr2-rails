module SelectSchedule
  extend ActiveSupport::Concern

  def selectSchedule(userId, displayYear, displayMonth)
    lastDay = Date.new(displayYear, displayMonth, -1).day
    dateFrom = format("#{displayYear}-%02d-01", displayMonth)
    dateTo = format("#{displayYear}-%02d-#{lastDay}", displayMonth)

    schedules = Schedule.eager_load(:schedule_content).where(date: dateFrom..dateTo, user_id: userId).order(:date, :started_at, :ended_at, :id)

    displaySchedules = {}
    schedules.each{|schedule|
      day = schedule.date.mday
      if displaySchedules[day].nil?
        displaySchedules[day] = []
      end
      displaySchedule = {
        id: schedule.id,
        date: schedule.date,
        title: schedule.schedule_content.title,
        started_at: schedule.schedule_content.started_at,
        ended_at: schedule.schedule_content.ended_at,
        detail: schedule.schedule_content.detail
      }
      p displaySchedule
      displaySchedules[day].push(displaySchedule)
    }
    return displaySchedules
  end
end