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
      displaySchedules[day].push(schedule)
    }
    return displaySchedules
  end
end