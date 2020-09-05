class SchedulesController < ApplicationController
  # before_action :set_schedule, only: [:show, :update, :destroy]
  include SelectSchedule
  include InsertSchedule
  include UpdateSchedule
  include DestroySchedule

  # GET /schedules/2020/8
  def getSchedules
    require 'date'
    if params[:year].present? && params[:month].present?
      year = params[:year].to_i
      month = params[:month].to_i
    else
      render status: :bad_request
    end
    @schedules = selectSchedule(@user['id'], year, month)
    render status: :ok, json: @schedules
  end

  # POST /schedules
  def postSchedules
    schedule = Hash.new
    schedule[:user_id] = @user['id']
    schedule[:date] = params['date']
    schedule[:title] = params['title']
    schedule[:detail] = params['detail']
    if params['allday']
      schedule[:started_at] = ""
      schedule[:ended_at] = ""
    else
      schedule[:started_at] = params['started_at']+":00"
      schedule[:ended_at] = params['ended_at']+":00"
    end
    insertSchedule(schedule)
    render status: :ok
  end

  # PUT /schedules/1
  def putSchedules
    schedule = Hash.new
    schedule[:user_id] = @user['id']
    schedule[:id] = params[:id]
    schedule[:date] = params['date']
    schedule[:title] = params['title']
    schedule[:detail] = params['detail']
    if params['allday']
      schedule[:started_at] = ""
      schedule[:ended_at] = ""
    else
      schedule[:started_at] = params['started_at'][0..4]+":00"
      schedule[:ended_at] = params['ended_at'][0..4]+":00"
    end
    updateSchedule(schedule)
    render status: :ok
  end

  # DELETE /schedules/1
  def deleteSchedules
    ids = Hash.new
    ids[:user_id] = @user['id']
    ids[:id] = params[:id]
    destroySchedule(ids)
    render status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule_by_id
      @schedule = Schedule.find(params[:id])
      unless @schedule
        render status: :not_found
      end
      if @schedule.content_id != @user['id']
        render status: :forbidden
      end
      @scheduleContent = ScheduleContent.find(@schedule.content_id)
      unless @scheduleContent
        render status: :not_found
      end
    end
end