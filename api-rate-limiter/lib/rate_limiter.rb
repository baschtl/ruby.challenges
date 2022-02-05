class RateLimiter
  attr_accessor :sliding_window_in_min, :requests_per_window, :requests

  def initialize(sliding_window_in_min, requests_per_window)
    @sliding_window_in_min = sliding_window_in_min
    @requests_per_window = requests_per_window
    @requests = {}
  end

  def endpoint(user)
    if @requests.include?(user)
      clean_requests(user, Time.now.utc)

      if @requests[user].size < @requests_per_window
        @requests[user] << Time.now.utc
        return true
      else
        return false
      end
    else
      @requests[user] = [Time.now.utc]
      return true
    end
  end

  private

  def clean_requests(user, now)
    window_start_time = now - (60 * @sliding_window_in_min)

    requests[user].delete_if { |r| r < window_start_time }
  end
end
