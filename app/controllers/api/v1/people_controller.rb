# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PeopleController < Api::V1::ApplicationController
    account_load_and_authorize_resource :person, through: :team, through_association: :people

    # GET /api/v1/teams/:team_id/people
    def index
    end

    # GET /api/v1/people/:id
    def show
    end

    # POST /api/v1/teams/:team_id/people
    def create
      if @person.save
        render :show, status: :created, location: [:api, :v1, @person]
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/people/:id
    def update
      if @person.update(person_params)
        render :show
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/people/:id
    def destroy
      @person.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def person_params
        strong_params = params.require(:person).permit(
          *permitted_fields,
          :firstname,
          :lastname,
          :phone,
          :email,
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
  class Api::V1::PeopleController
  end
end
