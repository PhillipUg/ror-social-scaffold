class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @pending_friends = @user.pending_friends
    @friend_requests = @user.friend_requests
    @my_friends = current_user.my_friends
  end

  def invite
    @new_friendship = Friendship.add_friend(current_user.id, params[:friend_id], 'pending')
    flash[:notice] = 'Request Sent!'
    redirect_to users_path
  end

  def accept
    @friendship1 = Friendship.find_by(friend_id: current_user.id, user_id: params[:id])
    @friendship2 = Friendship.new(friend_id: params[:id], user_id: current_user.id, state: 'confirmed')
    friendship_params = params.require(:friendship).permit(:state)
    @friendship1.update(friendship_params)
    @friendship2.save
    redirect_to user_path(current_user.id), notice: 'Friend Successfully Accepted!'
  end

  def reject
    @friendship = Friendship.find_by(friend_id: current_user.id, user_id: params[:id])
    @friendship.destroy
    redirect_to user_path(current_user.id), alert: 'Removed!'
  end
end
