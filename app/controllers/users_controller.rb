class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @user_stocks = @user.stocks
  end

  def my_friends
    @friendships = current_user.friends
  end

  def search
    if params[:search_param].blank?
      flash.now[:danger] = "You have entered an empty string"
    else
      @users = User.search(params[:search_param])
      flash.now[:danger] = "No users matched this search criteria" if @users.blank?
    end
    respond_to do |format|
      format.js { render partial: "friends/result"}
    end
  end
end
