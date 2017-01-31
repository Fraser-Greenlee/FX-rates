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
		amount = request.query_parameters["amount"]
		from = request.query_parameters["from"]
		to = request.query_parameters["to"]
		# return conversion
		@date = date
		@amount = amount
		@from = from
		@to = to
		# check variables
		begin
			 Date.parse(date)
		rescue ArgumentError
			 # invalid date
			 @date = ExchangeRate.lastupdated()
			 @error = "Date is invalid."
			 return
		end
		if ExchangeRate.currencies().include? to == false then
			@to = "USD"
			@error = "To currency not storred."
			return
		end
		if ExchangeRate.currencies().include? from == false then
			@from = "USD"
			@error = "From currency not storred."
			return
		end
		if (false if Integer(amount) rescue true) then
			@amount = "0"
			@error = "Amount must be an number."
			return
		else
			amount = amount.to_f
		end
		# get result
		# in case of error
		ex = ExchangeRate.at(date,to,from)
		if ex.kind_of? String then
			@error = ex
			return
		end
		@result = amount * ex
  end
	# cron job
	def cron
		ExchangeRate.update()
		render html: "success"
	end
end
