class SessionsController < ApplicationController
  def login
    res = {id: @access_user.id, name: @access_user.name, is_admin: @access_user.is_admin}
    render status: :ok, json: res
  end
end