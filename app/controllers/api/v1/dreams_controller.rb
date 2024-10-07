class Api::V1::DreamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dream, only: [:show, :update, :destroy]

  # GET /dreams
  def index
    @dreams = Dream.where(user_id: current_user.id).order(datedream: :desc)
    if params[:deleted].present?
      @dreams = @dreams.where(deleted: params[:deleted] == 'true')
    end
    if params[:complete].present?
      @dreams = @dreams.where(complete: params[:complete] == 'true')
    end
    render json: {dreams: @dreams}

  end

  # GET /dreams/:id
  def show
    if check_access
      render json: {dreams: @dream}
    end
  end

  # POST /dreams
  def create
    @dream = Dream.new(dream_params)
    @dream.user_id = current_user.id
    if @dream.save
      render json: @dream, status: 201
    else
      render json: { error:
        "Unable to create dream: #{@dream.errors.full_messages.to_sentence}"},
        status: 400
    end
  end

  # PUT /dreams/:id
  def update
    if check_access
      if @dream.update(dream_params)
        render json: { message: "Dream record id#{@dream.id} successfully updated." }, status: 200
      else
        render json: { error: "Dream record id#{@dream.id} update problem: #{@dream.errors.full_messages.to_sentence}" }, status: 400
      end
    end
  end

  # DELETE /dreams/:id
  def destroy
    if check_access
      if !@dream.deleted
        @dream.deleted = true
        if @dream.save 
          render json: { message: 'Dream marked as deleted.'}, status: 200
        else
          render json: { message: 'Dream delete mark failure.'}, status: 200
        end
        return
      else
        @dream.complete = true
        if @dream.save 
          render json: { message: 'Dream marked as complete deleted.'}, status: 200
        else
          render json: { message: 'Dream compleate delete mark failure.'}, status: 200
        end
      end
    end
  end


  def search
    query = params[:query]
    @dreams = Dream.where(user_id: current_user.id)
                 .where("description ILIKE ?", "%#{query}%")
    render json: { dreams: @dreams }
  end

  private

  def dream_params
    params.require(:dream).permit(:description, :datedream, :quality, :hours, :lucid, :deleted, :complete, :query, tags: [])
  end

  def set_dream
    @dream = Dream.find(params[:id])
  end

  def check_access
    if (@dream.user_id != current_user.id) 
      render json: { message: "The current user is not authorized for that data."}, status: :unauthorized
      return false
    end
    true
  end



end
