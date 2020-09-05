class SessionsController < ApplicationController
  def login
    render status: :ok, json: @myData
  end
end