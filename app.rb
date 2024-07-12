require 'sinatra'
require 'httparty'
require 'json'

get '/' do
  @artworks = fetch_random_artworks
  erb :index
end

post '/fetch_artworks' do
  @artworks = fetch_random_artworks
  erb :index
end

def fetch_random_artworks
  total_pages = 100 # Adjust based on the total number of pages available from the API
  random_page = rand(1..total_pages)
  response = HTTParty.get("https://api.artic.edu/api/v1/artworks?page=#{random_page}&limit=3&fields=id,title,image_id,artist_title")
  data = JSON.parse(response.body)
  artworks = data['data']
  artworks.each do |artwork|
    if artwork['image_id']
      artwork['image_url'] = "https://www.artic.edu/iiif/2/#{artwork['image_id']}/full/843,/0/default.jpg"
    else
      artwork['image_url'] = nil
    end
  end
  artworks
end
