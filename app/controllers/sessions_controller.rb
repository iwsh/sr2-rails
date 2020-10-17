class SessionsController < ApplicationController
  def login
    res = {id: @accessUser.id, name: @accessUser.name, is_admin: @accessUser.is_admin}
    render status: :ok, json: res
  end
end