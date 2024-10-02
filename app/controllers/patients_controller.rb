class PatientsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :ensure_receptionist, only: %i[new create edit update destroy] # Only receptionists can manage patients
  before_action :ensure_doctor, only: [:doctor_dashboard] # Only doctors can access the doctor dashboard
  skip_before_action :set_patient, only: [:chart]

  # GET /patients or /patients.json
  def index
    @patients = Patient.all
  end

  # GET /patients/1 or /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # GET /patients/doctor_dashboard
  def doctor_dashboard
    @patients = Patient.all
    @patients_by_day = Patient.group_by_day(:created_at).count
  end

  # POST /patients or /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: "Patient was successfully created." }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  
  

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: "Patient was successfully updated." }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1 or /patients/1.json
  def destroy
    @patient.destroy!

    respond_to do |format|
      format.html { redirect_to patients_path, status: :see_other, notice: "Patient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_patient
    @patient = Patient.find(params[:id]) 
  end

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(:name, :age, :contact_info)
  end

  # Ensure user is a receptionist
  def ensure_receptionist
    redirect_to root_path, alert: 'Access Denied' unless current_user.receptionist?
  end

  # Ensure user is a doctor
  def ensure_doctor
    redirect_to root_path, alert: 'Access Denied' unless current_user.doctor?
  end

  def chart
    # Group patients by the day they were created and count them
    @patients_chart_data = Patient.group_by_day(:created_at).count
  end
end
