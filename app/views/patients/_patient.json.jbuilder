json.extract! patient, :id, :name, :age, :contact_info, :created_at, :updated_at
json.url patient_url(patient, format: :json)
