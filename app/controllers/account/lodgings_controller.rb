class Account::LodgingsController < Account::ApplicationController
  account_load_and_authorize_resource :lodging, through: :location, through_association: :lodgings

  # GET /account/locations/:location_id/lodgings
  # GET /account/locations/:location_id/lodgings.json
  def index
    delegate_json_to_api
  end

  # GET /account/lodgings/:id
  # GET /account/lodgings/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/locations/:location_id/lodgings/new
  def new
  end

  # GET /account/lodgings/:id/edit
  def edit
  end

  # POST /account/locations/:location_id/lodgings
  # POST /account/locations/:location_id/lodgings.json
  def create
    respond_to do |format|
      if @lodging.save
        format.html { redirect_to [:account, @location, :lodgings], notice: I18n.t("lodgings.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @lodging] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lodging.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/lodgings/:id
  # PATCH/PUT /account/lodgings/:id.json
  def update
    respond_to do |format|
      if @lodging.update(lodging_params)
        format.html { redirect_to [:account, @lodging], notice: I18n.t("lodgings.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @lodging] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lodging.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/lodgings/:id
  # DELETE /account/lodgings/:id.json
  def destroy
    @lodging.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @location, :lodgings], notice: I18n.t("lodgings.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
