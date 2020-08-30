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

      # @user = User.select(:id, :name, :is_admin, :password_digest, :email).find_by(email: email)
      @user = User.find_by(email: email)

      if @user
        if @user.authenticate(password)
          if @user.fails_count >= 3
            render status: :locked # 423
          else
            @user.update(fails_count: 0, last_login_at: DateTime.now, record_timestamps: false)
          end
        else
          if @user.fails_count < 3
            @user.increment!(:fails_count)
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
