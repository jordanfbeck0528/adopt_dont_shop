class ApplicationsController < ApplicationController
  def show
    # if params[:search]
      @pets = Pet.search(params[:search])
      @application = Application.find(params[:id])
    # elsif params[:pet_id]
    #   @application = Application.find(params[:id])
    #   @application.add_pet(params[:pet_id])
    # else
    #   @application = Application.find(params[:id])
    # end
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(app_params)
    @application.update(application_status: "In Progress")

    if @application.save
      flash[:success] = "Create Application performed successfully"
      redirect_to "/applications/#{@application.id}"
    else
      flash[:warning] = "Create New Application failed, Please complete all fields"
      # flash.now[:error] = @applications.error.full_messages.to_sentence
      # redirect_to :action => "new"
      render :new
    end
  end

  def update
    application = Application.find(params[:id])
    # require "pry"; binding.pry
    if params[:app]
      application.update(description_of_applicant: params[:app], application_status: "Pending")
    else
      application.add_pet(params[:pet_id])
      application.update(app_params)
    end
    redirect_to "/applications/#{application.id}"
  end

  private

  def app_params
    params.permit(:name, :street_address,
    :city, :state, :zip_code, :description_of_applicant,
    :pet_name, :application_status)
  end
end
