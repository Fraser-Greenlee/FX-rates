class PagesController < ApplicationController
	# main page
	def home

		# get currencies in use
		@currencies = ExchangeRate.currencies()
		# default date value
		@date = ExchangeRate.lastupdated()

		# if doesn't have params
		['date','amount','from','to'].each do |param|
			if request.query_parameters.key?(param) == false then
				# leave page
				return
			end
		end
		# else
		# process values (not cleaning for simplicity)
		date = request.query_parameters["date"]# can send Date value or just as string
		amount = request.query_parameters["amount"].to_i
		from = request.query_parameters["from"]
		to = request.query_parameters["to"]
		# return conversion
		@date = date
		@amount = amount
		@from = from
		@to = to
		@result = amount * ExchangeRate.at(date,to,from)
  end
	# cron job
	def cron
		ExchangeRate.update()
		render html: "success"
	end
end
