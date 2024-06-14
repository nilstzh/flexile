# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/:id
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/:id/edit
  def edit; end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      update_project_contractors(@project, params[:project][:contractor_ids])
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/:id
  def update
    if @project.update(project_params)
      update_project_contractors(@project, params[:project][:contractor_ids])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :description, :start_date, :end_date, contractor_ids: [])
  end

  # Update project contractors association
  def update_project_contractors(project, contractor_ids)
    project.contractors = Contractor.where(id: contractor_ids)
  end
end
