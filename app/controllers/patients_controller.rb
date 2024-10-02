class PatientsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :ensure_receptionist, only: %i[new create edit update destroy] # Only receptionists can manage patients
  before_action :ensure_doctor, only: [:doctor_dashboard] # Only doctors can access the doctor dashboard



  def chart
    @patients_chart_data = Patient.group("DATE(created_at)").count.transform_keys { |date| date.to_date.to_time }

    # Log the patient data to check if it exists
    logger.debug "Patient data: #{@patients_chart_data.inspect}"
    # This returns a hash where the key is the date and the value is the count of patients for that date.
    # Example: { "2024-09-30" => 10, "2024-10-01" => 15, "2024-10-02" => 20 }
  end

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

  
  

  
  # app/controllers/patients_controller.rb
  

end
