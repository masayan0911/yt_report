class GoogleApi
  def self.setup
    client = Faraday.new 'https://accounts.google.com/o/oauth2/' do |b|
      b.request :url_encoded
      b.adapter Faraday.default_adapter
    end
  end

  def self.fetch_access_token(code)
    client = self.setup
    res = client.post 'token' do |req|
      req.body = {
          :code => code,
          :client_id => ENV["CLIENT_ID"],
          :client_secret => ENV["CLIENT_SECRET"],
          :redirect_uri => ENV["URL"] + "/callback",
          :grant_type => "authorization_code"
      }
    end
    json = JSON.parse(res.body)
  end

  def self.retrieve_access_token
    res = self.refresh_access_token(ENV["REFRESH_TOKEN"])
    res["access_token"]
  end

  def self.refresh_access_token(refresh_token)
    client = self.setup
    res = client.post 'token' do |req|
      req.body = {
          :client_id => ENV["CLIENT_ID"],
          :client_secret => ENV["CLIENT_SECRET"],
          :refresh_token => refresh_token,
          :grant_type => "refresh_token"
      }
    end
    json = JSON.parse(res.body)
  end
end