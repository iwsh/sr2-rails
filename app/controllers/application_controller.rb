class ApplicationController < ActionController::API
  before_action :login_check

  private

  def login_check
    require 'base64'

    render status: :unauthorized and return if request.headers[:AuthHeader].nil?

    auth_header = Base64.decode64(request.headers[:AuthHeader])
    email = auth_header[/(.*)\:/, 1]
    password = auth_header[/\:(.*)/, 1]

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
