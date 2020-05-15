class YoutubeAnalyticsApi
  BASE_URL = "https://youtubeanalytics.googleapis.com/v2/"

  def self.daily_metrics(date_str)
    client = Faraday.new BASE_URL do |b|
      b.request :url_encoded
      b.adapter Faraday.default_adapter
    end
    res = client.get 'reports' do |req|
      req.params[:access_token] = GoogleApi.retrieve_access_token
      req.params[:startDate] = date_str
      req.params[:endDate] = date_str
      req.params[:ids] = "channel==MINE"
      req.params[:dimensions] = "day"
      req.params[:sort] = "day"
      req.params[:metrics] = "views,estimatedMinutesWatched,subscribersGained"
    end
    json = JSON.parse(res.body)
    hash = {}
    hash["date"] = json["rows"].first[0]
    ap "日付: #{hash["date"]}"
    hash["views"] = json["rows"].first[1]
    ap "視聴回数: #{hash["views"]}"
    hash["watchHours"] = json["rows"].first[2] / 60
    ap "再生時間(時間): #{hash["watchHours"]}"
    hash["subscribersGained"] = json["rows"].first[3]
    ap "チャンネル登録者: #{hash["subscribersGained"]}"
    hash
  end
end