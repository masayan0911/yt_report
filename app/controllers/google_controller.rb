class GoogleController < ApplicationController
  def auth
    url = "https://accounts.google.com/o/oauth2/auth?client_id=#{ENV["CLIENT_ID"]}&redirect_uri=#{ENV["URL"]}/callback&scope=https://www.googleapis.com/auth/yt-analytics.readonly&response_type=code&access_type=offline"
    redirect_to url
  end

  def callback
    res = GoogleApi.fetch_access_token(params[:code])
    render :json => res
  end
end