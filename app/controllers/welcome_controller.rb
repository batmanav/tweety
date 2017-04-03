class WelcomeController < ApplicationController
	def index
	end
	def getFeed
		client = Twitter::REST::Client.new do |config|
			config.consumer_key    = "6t9q5IH7o49ica1qyU7GJpbqK"
			config.consumer_secret = "4CzXhmELCMkWaoPLrAeQDojZ7rWvXfpzOwwO568J3gVkFMaCuO"
		end

		client_stream = Twitter::Streaming::Client.new do |config|
			config.consumer_key    = "6t9q5IH7o49ica1qyU7GJpbqK"
			config.consumer_secret = "4CzXhmELCMkWaoPLrAeQDojZ7rWvXfpzOwwO568J3gVkFMaCuO"
			config.access_token        = "2404897531-B6VrvxLuYamgmiaEY0AqljnC5JAhB3Xj0w85gai"
			config.access_token_secret = "iuIvWd6C4XkZqniKNht5W5bF39ZBm380beN5V1etMWVPU"
		end
		username = params[:username]

		begin 
			totalPosts = client.user(username).statuses_count
		rescue
			totalPosts = 0
		end		
		begin 
			name = client.user(username).name
		rescue
			name = "Could not retrieve"
		end
		begin 
			connections = client.user(username).connections
		rescue
			connections = "Could not retrieve"
		end
		begin 
			followers_count = client.user(username).followers_count
		rescue
			followers_count = "Could not retrieve"
		end
		begin 
			friends_count = client.user(username).friends_count
		rescue
			friends_count = "Could not retrieve"
		end
		begin 
			location = client.user(username).location
		rescue
			location = "Could not retrieve"
		end

		totalPostsNumber = totalPosts
		maxId = nil
		dates = Hash.new
		hours = Hash.new
		allPosts = []
		full_text = ""
		while (totalPosts > 0) do
			options = {count: 200, include_rts: true}
			options[:max_id] = maxId unless maxId.nil?
			feed = client.user_timeline(username, options)
			maxId = feed.last.id
			totalPosts -= 200
			for i in feed
				allPosts.push(i)
				text = i.full_text
				full_text += text.gsub(/(\W|\d)/, " ")
				created_at = "#{i.created_at}"
				created_at = created_at.split()
				date = created_at[0]
				date = date.split("-")
				date = date[1] + "-" + date[0]
				if(dates[date])
					dates[date] += 1
				else
					dates[date] = 1
				end
				hour = created_at[1].split(":")[0]
				if(hours[hour])
					hours[hour] += 1
				else
					hours[hour] = 1
				end
			end
		end
		render json: {:dates=> dates, :hours=>hours, :full_text=>full_text, :posts=>totalPostsNumber, :allPosts=>allPosts, :name=>name, :connections=>connections,:friends_count=>friends_count, :location=>location}
	end
end
