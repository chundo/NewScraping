json.extract! post, :id, :name, :body, :image, :url, :sources, :video, :cover, :state, :category_id, :created_at, :updated_at
json.url post_url(post, format: :json)
