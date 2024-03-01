json.extract! note, :id, :content, :user_id, :car_id, :created_at, :updated_at
json.url note_url(note, format: :json)
