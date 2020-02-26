class UserController < ApplicationController
	def index
	end
	def edit
	end
	def new
	end
	def create
		@user = User.new(set_user)
		binding.pry
		respond_to do |format|
	      if @user.save
	        format.html { redirect_to @user, notice: 'Account was successfully created.' }
	        format.json { render :index, status: :created, location: @user }
	      else
	        format.html { render :new }
	        format.json { render json: @user.errors, status: :unprocessable_entity }
	      end
	    end
	end

	private

	def set_user
		params.require(:users).permit(:username, :email, :password, :password_confirm)
	end
end
