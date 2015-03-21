class BotsController < ApplicationController
  def index
    session[:token] = params[:token] if params[:token]
    if session[:token]
      redirect_to process_path
    else
      # https://oauth.vk.com/authorize?client_id=4798482&redirect_uri=http://api.vk.com/blank.html&scope=&display=page&response_type=token
      @url = VkontakteApi.authorization_url(
        type: :client, 
        scope: %i(photos offline messages friends status wall)
      )

    def process
    end
  end
end