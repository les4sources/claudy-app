class Account::RoomsController < Account::ApplicationController
  account_load_and_authorize_resource :room, through: :location, through_association: :rooms

  # GET /account/locations/:location_id/rooms
  # GET /account/locations/:location_id/rooms.json
  def index
    delegate_json_to_api
  end

  # GET /account/rooms/:id
  # GET /account/rooms/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/locations/:location_id/rooms/new
  def new
  end

  # GET /account/rooms/:id/edit
  def edit
  end

  # POST /account/locations/:location_id/rooms
  # POST /account/locations/:location_id/rooms.json
  def create
    respond_to do |format|
      if @room.save
        format.html { redirect_to [:account, @location, :rooms], notice: I18n.t("rooms.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @room] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/rooms/:id
  # PATCH/PUT /account/rooms/:id.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to [:account, @room], notice: I18n.t("rooms.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @room] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/rooms/:id
  # DELETE /account/rooms/:id.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @location, :rooms], notice: I18n.t("rooms.notifications.destroyed") }
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
