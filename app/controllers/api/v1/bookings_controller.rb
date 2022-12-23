# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::BookingsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :booking, through: :location, through_association: :bookings

    # GET /api/v1/locations/:location_id/bookings
    def index
    end

    # GET /api/v1/bookings/:id
    def show
    end

    # POST /api/v1/locations/:location_id/bookings
    def create
      if @booking.save
        render :show, status: :created, location: [:api, :v1, @booking]
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/bookings/:id
    def update
      if @booking.update(booking_params)
        render :show
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/bookings/:id
    def destroy
      @booking.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def booking_params
        strong_params = params.require(:booking).permit(
          *permitted_fields,
          :person_id,
          :lodging_id,
          :from_date,
          :to_date,
          :status,
          :adults,
          :children,
          :checkin_time,
          :selected_tier,
          :payment_status,
          :payment_method,
          :bedsheets,
          :towels,
          :shown_price_cents,
          :price_cents,
          :invoice_status,
          :contract_status,
          :options,
          :comments,
          :notes,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::BookingsController
  end
end
