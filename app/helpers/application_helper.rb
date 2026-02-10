module ApplicationHelper
  def format_datetime(datetime)
    datetime_in_indo(datetime).strftime("%b %d, %Y %H:%M")
  end

  def datetime_in_indo(datetime)
    datetime.in_time_zone("Asia/Jakarta")
  end
end
