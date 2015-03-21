class TokensController < ApplicationController
  def index
    # https://oauth.vk.com/authorize?client_id=4798482&redirect_uri=http://api.vk.com/blank.html&scope=&display=page&response_type=token
    @url = VK.authorization_url(
      type: :client, 
      scope: %i(photos offline messages friends status wall)
    )
  end

  def create
    session[:token] = params[:token]
    redirect_to bots_path
  end
end