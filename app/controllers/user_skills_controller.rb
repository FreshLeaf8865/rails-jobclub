class UserSkillsController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index]

  before_action :set_user_skill, only: [:show, :edit, :update, :destroy]

  # GET /user_skills
  def index
    @user_skills = policy_scope(UserSkill)
  end

  # GET /user_skills/1
  def show
  end

  # GET /user_skills/new
  def new
    @user_skill = current_user.user_skills.build

    authorize @user_skill
  end

  # GET /user_skills/1/edit
  def edit
  end

  # POST /user_skills
  def create
    @user_skill = current_user.user_skills.build(user_skill_params)
    authorize @user_skill
    
    if @user_skill.save
      redirect_to current_user, notice: "Added #{@user_skill.name} skill"
    else
      render :new
    end
  end

  # PATCH/PUT /user_skills/1
  def update
    if @user_skill.update(user_skill_params)
      respond_to do |format|
        format.js   { }
        format.html { redirect_to current_user, notice: "Updated #{@user_skill.name} skill" }
      end
    else
      render :edit
    end
  end

  # DELETE /user_skills/1
  def destroy
    @user_skill.destroy

    respond_to do |format|
      format.js   { render layout: false }
      format.html { redirect_to current_user, notice: "#{@user_skill.name} skill deleted" }
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_skill
      @user_skill = UserSkill.find(params[:id])
      authorize @user_skill
    end

    # Only allow a trusted parameter "white list" through.
    def user_skill_params
      params.require(:user_skill).permit(:user_id, :years, :skill_id, :position)
    end
end
