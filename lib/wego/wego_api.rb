module Wego
  class WegoApi
    def initialize()
      puts "Wego api Initialized"
    end

    def search_trip(departure_code, arrival_code, outbound_date, inbound_date, adults_count)
      trips = []
      trips.push(
          {
              departure_code: departure_code,
              arrival_code: arrival_code,
              outbound_date: outbound_date,
              inbound_date: inbound_date
          }
      )
      postBody = {trips: trips, departure_city: true, arrival_city: true, adults_count: adults_count}
      response = RestClient.post(Wego.config[:searches_url], postBody, params: Wego.config[:base_params])
      Wego.logger.debug(" response is ::: #{response.dump}")

    end

  end
end