class SchedulesController < ApplicationController
  # before_action :set_schedule, only: [:show, :update, :destroy]
  include SetScheduleById
  include SelectSchedule
  include InsertSchedule
  include UpdateSchedule
  include DestroySchedule

  before_action :validationSchedule, only: [:postSchedules, :putSchedules]

  # GET /schedules/2020/8
  def getSchedules
    require 'date'
    if params[:year].present? && params[:month].present?
      year = params[:year].to_i
      month = params[:month].to_i
      @schedules = selectSchedule(@accessUser[:id], year, month)
      render status: :ok, json: @schedules
    else
      render status: :bad_request
    end
  end

  # POST /schedules
  def postSchedules
    schedule = Hash.new
    schedule[:user_id] = @accessUser[:id]
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
    if params[:id].blank?
      render status: :bad_request
    end
    schedule = Hash.new
    schedule[:user_id] = @accessUser[:id]
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

    error = setScheduleById()
    if error == 'not_found'
      render status: :not_found
    elsif error == 'forbidden'
      render status: :forbidden
    elsif error.blank?
      updateSchedule(schedule)
      render status: :ok
    else
      render status: :internal_server_error
    end
  end

  # DELETE /schedules/1
  def deleteSchedules
    if params[:id].blank?
      render status: :bad_request
    end

    error = setScheduleById()
    if error == 'not_found'
      render status: :not_found
    elsif error == 'forbidden'
      render status: :forbidden
    elsif error.blank?
      destroySchedule()
      render status: :ok
    else
      render status: :internal_server_error
    end
  end

  private
    # Check if the request params are valid.
    def validationSchedule
      if params['date'].blank? || params['title'].blank?
        puts 'VALIDATION_ERROR: no "date" or "title" in request body.'
        render status: :bad_request
      elsif params['allday'].blank? && params['started_at'].blank? || params['ended_at'].blank? || params['started_at'][0..3] > params['ended_at'][0..3]
        puts 'VALIDATION_ERROR: time-parameter in request body is incorrect.'
        render status: :bad_request
      end
    end
end