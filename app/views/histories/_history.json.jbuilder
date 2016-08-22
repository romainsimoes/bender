json.extract! history, :id, :question, :answer, :created_at, :updated_at
json.url history_url(history, format: :json)