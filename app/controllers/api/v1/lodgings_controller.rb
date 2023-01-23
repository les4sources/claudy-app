# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::LodgingsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :lodging, through: :location, through_association: :lodgings

    # GET /api/v1/locations/:location_id/lodgings
    def index
    end

    # GET /api/v1/lodgings/:id
    def show
    end

    # POST /api/v1/locations/:location_id/lodgings
    def create
      if @lodging.save
        render :show, status: :created, location: [:api, :v1, @lodging]
      else
        render json: @lodging.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/lodgings/:id
    def update
      if @lodging.update(lodging_params)
        render :show
      else
        render json: @lodging.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/lodgings/:id
    def destroy
      @lodging.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def lodging_params
        strong_params = params.require(:lodging).permit(
          *permitted_fields,
          :name,
          :description,
          :summary,
          :price_night_cents,
          :price_weekend_cents,
          :party_hall_availability,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          room_ids: [],
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::LodgingsController
  end
end
