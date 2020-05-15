class LineApi
  def self.notify(message)
    client = Faraday.new 'https://notify-api.line.me/api/notify' do |b|
      b.request :url_encoded
      b.adapter Faraday.default_adapter
    end
    token = ENV["LINE_NOTIFY_TOKEN"]
    header_hash = {'Authorization' => "Bearer #{token}"}

    res = client.post '' do |req|
      req.headers = header_hash
      req.body = {
          :message => message
      }
    end
    json = JSON.parse(res.body)
  end
end