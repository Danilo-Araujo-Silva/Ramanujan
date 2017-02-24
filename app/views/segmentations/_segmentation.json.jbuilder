json.extract! segmentation, :id, :title, :description, :query, :parameters, :created_at, :updated_at
json.url segmentation_url(segmentation, format: :json)