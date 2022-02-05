require "timecop"
require "rate_limiter"

RSpec.describe "RateLimiter" do
  subject { RateLimiter.new(sliding_window_in_min, requests_per_window) }

  let(:sliding_window_in_min) { 2 }
  let(:requests_per_window) { 3 }

  context "single user" do
    let(:user) { :alice }

    context "when there are no requests stored for a user" do
      it "returns true" do
        expect(subject.endpoint(user)).to eq true
      end

      it "stores the request" do
        new_time = Time.local(2008, 9, 1, 12, 0, 0).utc

        Timecop.freeze(new_time) do
          expect { subject.endpoint(user) }
            .to change { subject.requests }
            .from({})
            .to({ alice: [new_time]})
        end
      end
    end

    context "when a user exhausts her quota" do
      it "blocks subsequent requests until the sliding window moves enough" do
        first_request_time = request_time = Time.now.utc - (60 * 1) # one minute before now

        # Do requests_per_window requests to fill up quota
        requests_per_window.times do
          Timecop.freeze(request_time) do
            subject.endpoint(user)
          end
          request_time = request_time + 10 # add ten seconds to last request time
        end

        expect(subject.requests[user].size).to eq 3

        # Try to request again
        expect(subject.endpoint(user)).to eq false
        expect(subject.requests[user].size).to eq 3

        # Wait for request slots to open up again
        Timecop.travel(first_request_time + (60 * sliding_window_in_min))

        # Now request again
        expect(subject.endpoint(user)).to eq true
        expect(subject.requests[user].size).to eq 3
      end
    end
  end

  context "multi user" do
    let(:user_1) { :alice }
    let(:user_2) { :bob }

    context "when two users exhaust their quota" do
      it "handles two user's request times" do
        first_request_time = request_time = Time.now.utc - (60 * 1) # one minute before now

        # Do requests_per_window requests to fill up quota
        requests_per_window.times do
          Timecop.freeze(request_time) do
            subject.endpoint(user_1)
            subject.endpoint(user_2)
          end
          request_time = request_time + 10 # add ten seconds to last request time
        end

        expect(subject.requests[user_1].size).to eq 3
        expect(subject.requests[user_2].size).to eq 3

        # Try to request again
        expect(subject.endpoint(user_1)).to eq false
        expect(subject.requests[user_1].size).to eq 3

        expect(subject.endpoint(user_2)).to eq false
        expect(subject.requests[user_2].size).to eq 3

        # Wait for request slots to open up again
        Timecop.travel(first_request_time + (60 * sliding_window_in_min))

        # Now request again
        expect(subject.endpoint(user_1)).to eq true
        expect(subject.requests[user_1].size).to eq 3

        expect(subject.endpoint(user_2)).to eq true
        expect(subject.requests[user_2].size).to eq 3
      end
    end
  end
end
