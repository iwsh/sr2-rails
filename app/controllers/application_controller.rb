class ApplicationController < ActionController::API
  before_action :login_check
  include ActionController::HttpAuthentication::Basic

  private

  def login_check
    require 'base64'

    render status: :unauthorized and return if request.headers[:Authorization].nil?

    auth_header = user_name_and_password(request)
    email = auth_header[0]
    password = auth_header[1]

    render status: :unauthorized and return unless validation(email, password)

    @access_user = User.find_by(email: email)
    if @access_user
      if @access_user.authenticate(password)
        if @access_user.fails_count >= 3
          render status: :locked # 423
        else
          @access_user.update(
            fails_count: 0,
            last_login_at: DateTime.now,
            record_timestamps: false
          )
        end
      else
        @access_user.increment!(:fails_count) if @access_user.fails_count < 3
        render status: :unauthorized
      end
    else
      render status: :unauthorized
    end
  end

  def validation(email, password)
    email == '' || password == '' ? false : true
  end
end
