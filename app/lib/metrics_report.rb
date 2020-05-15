class MetricsReport
  def self.report_text(today_api_hash, yesterday_api_hash)
    view_rate = ((today_api_hash["views"].to_f / yesterday_api_hash["views"].to_f - 1) * 100).floor(1)
    watch_hours_rate = ((today_api_hash["watchHours"].to_f / yesterday_api_hash["watchHours"].to_f - 1) * 100).floor(1)
    subscribers_gained_rate = ((today_api_hash["subscribersGained"].to_f / yesterday_api_hash["subscribersGained"].to_f - 1) * 100).floor(1)

    text =<<EOF

お疲れ様です、〇〇です。
〇〇チャンネルの数値報告になります。

・対象日
#{Date.parse(today_api_hash["date"]).strftime("%Y年%-m月%-d日")}

・視聴回数
#{today_api_hash["views"]}回(#{view_rate}%)

・再生時間
#{today_api_hash["watchHours"]}時間(#{watch_hours_rate}%)

・チャンネル登録者
#{today_api_hash["subscribersGained"]}人(#{subscribers_gained_rate}%)

ご確認よろしくお願いいたします。
EOF
    puts text
    text
    text.chomp!
  end

  def self.push_report
    ## YouTubeAnalyticsの更新は数日の時差がある
    delayed_day = 3
    today = (Date.today - delayed_day.day).strftime("%Y-%m-%d")
    yesterday = (Date.yesterday - delayed_day.day).strftime("%Y-%m-%d")
    today_api_hash = YoutubeAnalyticsApi.daily_metrics(today)
    yesterday_api_hash = YoutubeAnalyticsApi.daily_metrics(yesterday)
    text = self.report_text(today_api_hash, yesterday_api_hash)
    LineApi.notify(text)
  end
end