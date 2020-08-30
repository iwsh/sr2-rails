class ApplicationController < ActionController::API
  before_action :login_check

  private
    def login_check
      email = request.headers[:email]
      password = request.headers[:password]

      unless validation(email, password)
        @status = 400
        render status: @status
      end

      # @user = User.select(:id, :name, :is_admin, :password_digest, :email).find_by(email: email)
      @user = User.find_by(email: email)

      if @user
        if @user.fails_count >= 3
          @status = 423 # Locked
          render status: @status
        elsif @user.authenticate(password)
          @user.update(fails_count: 0, last_login_at: DateTime.now, record_timestamps: false)
          @status = 200
        else
          @user.increment!(:fails_count)
          if @user.fails_count < 3
            @status = 401
            render status: @status
          else
            @status = 401
            render status: @status
          end
        end
      else
        @status = 401
        render status: @status
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
