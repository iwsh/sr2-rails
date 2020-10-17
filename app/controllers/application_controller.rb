class ApplicationController < ActionController::API
  before_action :login_check

  private
    def login_check
      require 'base64'

      email = Base64.decode64(request.headers[:email])
      password = Base64.decode64(request.headers[:password])

      unless validation(email, password)
        render status: :unauthorized
      end

      @accessUser = User.find_by(email: email)

      if @accessUser
        if @accessUser.authenticate(password)
          if @accessUser.fails_count >= 3
            render status: :locked # 423
          else
            @accessUser.update(fails_count: 0, last_login_at: DateTime.now, record_timestamps: false)
          end
        else
          if @accessUser.fails_count < 3
            @accessUser.increment!(:fails_count)
          end
          render status: :unauthorized
        end
      else
        render status: :unauthorized
      end
    end

    def validation(email, password)
      valid = true
      if email == '' || password == ''
        valid = false
      end
      return valid
    end
end
