class UserRolesController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index]

  before_action :set_user_role, only: [:show, :edit, :update, :destroy]

  # GET /user_roles
  def index
    @user_roles = policy_scope(UserRole)
  end

  # GET /user_roles/1
  def show
  end

  # GET /user_roles/new
  def new
    @user_role = current_user.user_roles.build

    authorize @user_role
  end

  # GET /user_roles/1/edit
  def edit
  end

  # POST /user_roles
  def create
    @user_role = current_user.user_roles.build(user_role_params)
    authorize @user_role
    
    if @user_role.save
      redirect_to current_user, notice: "Added #{@user_role.name} role"
    else
      render :new
    end
  end

  # PATCH/PUT /user_roles/1
  def update
    if @user_role.update(user_role_params)
      redirect_to current_user, notice: "Updated #{@user_role.name} role"
    else
      render :edit
    end
  end

  # DELETE /user_roles/1
  def destroy
    @user_role.destroy

    respond_to do |format|
      format.js   { render layout: false }
      format.html { redirect_to current_user, notice: "#{@user_role.name} role deleted" }
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_role
      @user_role = UserRole.find(params[:id])
      authorize @user_role
    end

    # Only allow a trusted parameter "white list" through.
    def user_role_params
      params.require(:user_role).permit(:user_id, :role_id, :position)
    end
end
