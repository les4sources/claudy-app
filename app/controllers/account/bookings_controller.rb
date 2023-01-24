class Account::BookingsController < Account::ApplicationController
  account_load_and_authorize_resource :booking, through: :location, through_association: :bookings

  # GET /account/locations/:location_id/bookings
  # GET /account/locations/:location_id/bookings.json
  def index
    set_dates
    delegate_json_to_api
  end

  # GET /account/bookings/:id
  # GET /account/bookings/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/locations/:location_id/bookings/new
  def new
  end

  # GET /account/bookings/:id/edit
  def edit
  end

  # POST /account/locations/:location_id/bookings
  # POST /account/locations/:location_id/bookings.json
  def create
    service = Bookings::CreateService.new
    respond_to do |format|
      if service.run(params)
        format.html { redirect_to [:account, @location, :bookings], notice: I18n.t("bookings.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @booking] }
      else
        @booking = service.booking
        byebug
        # set_error_flash(service.booking, service.error_message)

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: service.booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/bookings/:id
  # PATCH/PUT /account/bookings/:id.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to [:account, @booking], notice: I18n.t("bookings.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @booking] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/bookings/:id
  # DELETE /account/bookings/:id.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @location, :bookings], notice: I18n.t("bookings.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date(strong_params, :from_date)
    assign_date(strong_params, :to_date)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end

  def set_dates
    # get the date from params if there is one - for display AND to limit our query
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @first = @date.beginning_of_month.beginning_of_day - 7.days
    @last = @date.end_of_month.end_of_day + 7.days
    # @dates = (@date.beginning_of_month..@date.end_of_month).map(&:to_date)
  end
end
