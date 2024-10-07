require_dependency 'openai_service'
require 'json'

class Api::V1::InterpretationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_interpretation, only: [:show, :update, :destroy]
  # before_action :check_access

  # GET /dreams/:dream_id/interpretations
  def index
    @dream = Dream.find(params[:dream_id])
    if @dream.interpretations.empty?
      render json: { error: "No interpretations found for this dream." }, status: 404
    else
      render json: @dream.interpretations 
    end
  end

  # GET /dreams/:dream_id/interpretations/:id
  def show
    render json: {interpretation: @interpretation}, status: 200
  end

  # POST /dreams/:dream_id/interpretations
  def create
    @dream = Dream.find(params[:dream_id])
    
    assistant = OpenaiService.new
    assistant.get_assistant_info
    response = assistant.get_interpritation(@dream.description)
    cleaned_response = response.gsub(/```json\n|\n```/, '')
    
    begin
      parsed_response = JSON.parse(cleaned_response)
    rescue JSON::ParserError => e
      render json: { error: "Failed to parse JSON response: #{e.message}" }, status: 500
      return
    end
  
    interpretation_data = {
      lang: parsed_response["lang"],
      meaning: parsed_response["meaning"],
      jungian_perspective: parsed_response["jungian_perspective"],
      freudian_perspective: parsed_response["freudian_perspective"],
      tags: parsed_response["tags"],
      questions: parsed_response["questions"],
      loaded: true,
      initiated: true
    }
  
    @interpretation = @dream.interpretations.new(interpretation_data)
  
    if @interpretation.save
      render json: @interpretation, status: 201
    else
      render json: { error: "The interpretation entry could not be created. #{@interpretation.errors.full_messages.to_sentence}" }, status: 400
    end
  end
  

  # PUT /dreams/:dream_id/interpretations/:id
  def update
    if check_access
      if @interpretation.update(interpretation_params)
        render json: { message: "Interpretation record id#{@interpretation.id} successfully updated." }, status: 200
      else
        render json: { error: "Interpretation record id#{@interpretation.id} update problem: #{@interpretation.errors.full_messages.to_sentence}" }, status: 400
      end
    end
  end

  # DELETE /dreams/:dream_id/interpretations/:id
  def destroy
    if @interpretation.destroy
      render json: { message: "Interpretation record id#{@interpretation.id} successfully deleted." }, status: 200
    else
      render json: { error: "Failed to delete Interpretation record id#{@interpretation.id}: #{@interpretation.errors.full_messages.to_sentence}" }, status: 400
    end
  end

  private

  def interpretation_params
    params.require(:interpretation).permit(:lang, :meaning, :tags, :questions, :jungian_perspective, :freudian_perspective, :loaded, :initiated, tags: [], questions: [])
  end

  def set_interpretation
    @interpretation = Interpretation.find_by(id: params[:id], dream_id: params[:dream_id])
    unless @interpretation
      render json: { error: "Interpretation not found." }, status: 404
    end
  end
  
  def check_access 
    @dream = Dream.find(params[:dream_id])
    if @dream.user_id != current_user.id
      render json: { message: "The current user is not authorized for that data."}, status: :unauthorized
    end
  end
end