module Bookings
  class CreateService < ServiceBase
    attr_reader :booking, :reservation

    def initialize
      @booking = Booking.new
      @report_errors = true
    end

    def run(params = {})
      context = {
        params: params
      }

      catch_error(context: context) do
        run!(params)
      end
    end

    def run!(params = {})
      @booking.attributes = booking_params(params)
      @booking.location = Location.find(params[:location_id])
      byebug
      return false if !@booking.valid?
      # @booking.generate_token
      rooms = @booking.lodging&.rooms || @booking.rooms
      if check_availability(rooms)
        byebug
        build_reservations(rooms)
        byebug
        @booking.save!
      end
      raise error_message if !error.nil?
      true
    end

    private

    def booking_params(params)
      params
        .require(:booking)
        .permit(
          :lodging_id,
          :person_id,
          :from_date,
          :to_date,
          :status,
          :adults,
          :children,
          :checkin_time,
          :shown_price_cents,
          :price_cents,
          :payment_status,
          :payment_method,
          :invoice_status,
          :contract_status,
          :bedsheets,
          :towels,
          :comments,
          :notes,
          :selected_tier,
          options: [],
          room_ids: [],
        )
    end

    def build_reservations(rooms)
      rooms.each do |room|
        (@booking.from_date..@booking.to_date).each do |date|
          @booking.reservations.build(
            location: @booking.location,
            room: room,
            date: date
          )
        end
      end
    end

    def check_availability(rooms)
      rooms.each do |room|
        if room.reservations.where(date: (@booking.from_date)..(@booking.to_date)).any?
          @booking.errors.add(
            :base,
            message: "Cet hébergement n'est pas disponible à cette date. Pourrais-tu vérifier sur le calendrier?"
          )
          # set_error_message("Cet hébergement n'est pas disponible à cette date. Pourriez-vous vérifier sur le calendrier?")
          return false
        end
      end
    end
  end
end
