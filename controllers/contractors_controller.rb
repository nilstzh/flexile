# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :set_contractor, only: %i[update]

  # POST /contractors
  def create
    @contractor = Contractor.new(contractor_params)
    rate_type = params[:rate_type]

    if rate_type == 'monthly' && monthly_params_valid?
      if @contractor.save
        render json: @contractor, status: :created
      else
        render json: @contractor.errors, status: :unprocessable_entity
      end
    elsif rate_type == 'project_based' && project_based_params_valid?
      if @contractor.save
        ProjectContractor.create!(project_id: params[:project_id], contractor_id: @contractor.id, rate: params[:rate])
        render json: @contractor, status: :created
      else
        render json: @contractor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid parameters' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contractors/:id
  def update
    rate_type = params[:rate_type]

    if rate_type == 'monthly' && monthly_params_valid?
      if @contractor.update(contractor_params)
        render json: @contractor
      else
        render json: @contractor.errors, status: :unprocessable_entity
      end
    elsif rate_type == 'project_based' && project_based_params_valid?
      if @contractor.update(contractor_params)
        project_contractor = @contractor.projects_contractors.find_or_initialize_by(project_id: params[:project_id])
        project_contractor.update!(rate: params[:rate])
        render json: @contractor
      else
        render json: @contractor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid parameters' }, status: :unprocessable_entity
    end
  end

  private

  def set_contractor
    @contractor = Contractor.find(params[:id])
  end

  def contractor_params
    params.require(:contractor).permit(:email, :name, :country, :start_date, :role_id, :hourly_rate, :avg_hours)
  end

  def monthly_params_valid?
    params[:hourly_rate].present? && params[:avg_hours].present?
  end

  def project_based_params_valid?
    params[:project_id].present? && params[:rate].present?
  end
end
