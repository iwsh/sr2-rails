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

      @myData = User.find_by(email: email)

      if @myData
        if @myData.authenticate(password)
          if @myData.fails_count >= 3
            render status: :locked # 423
          else
            @myData.update(fails_count: 0, last_login_at: DateTime.now, record_timestamps: false)
            @myData = {id: @myData.id, name: @myData.name, is_admin: @myData.is_admin}
          end
        else
          if @myData.fails_count < 3
            @myData.increment!(:fails_count)
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