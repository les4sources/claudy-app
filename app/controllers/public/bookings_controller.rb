class Public::BookingsController < Public::ApplicationController
  def new
    @booking = Booking.new(
      booking_type: "lodging",
      adults: 0,
      children: 0
    )
  end

  def create
    @service = Public::Bookings::CreateService.new
    if @service.run(params)
      redirect_to "/public/reservation/#{@service.booking.token}",
                  notice: "Merci, votre demande de réservation est enregistrée. Vous allez recevoir un email de confirmation de notre part et nous vous recontactons très prochainement."
    else
      @booking = @service.booking
      set_error_flash(@service.booking, @service.error_message)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # TODO add token to access booking based on token
    @booking = Booking.find_by(token: params[:token])
  end
end
