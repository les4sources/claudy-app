class Account::PeopleController < Account::ApplicationController
  account_load_and_authorize_resource :person, through: :team, through_association: :people

  # GET /account/teams/:team_id/people
  # GET /account/teams/:team_id/people.json
  def index
    delegate_json_to_api
  end

  # GET /account/people/:id
  # GET /account/people/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/people/new
  def new
  end

  # GET /account/people/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/people
  # POST /account/teams/:team_id/people.json
  def create
    respond_to do |format|
      if @person.save
        format.html { redirect_to [:account, @team, :people], notice: I18n.t("people.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @person] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/people/:id
  # PATCH/PUT /account/people/:id.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to [:account, @person], notice: I18n.t("people.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @person] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/people/:id
  # DELETE /account/people/:id.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :people], notice: I18n.t("people.notifications.destroyed") }
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
