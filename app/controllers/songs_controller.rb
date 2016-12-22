require 'rack-flash'
class SongsController < ApplicationController
enable :sessions
use Rack::Flash


  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

  post '/songs' do
    @song = Song.create(params[:song])
    @artist = Artist.find_or_create_by(params[:artist])
    @song.artist = @artist
    @song.save
    if !params[:genre]["name"].nil?
      @genre = Genre.find_or_create_by(params[:genre])
      @song.genres << @genre
    end
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  get "/songs/:slug/edit" do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(params[:song])
    @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    @song.save
    flash[:message] = "Successfully updated song."
    redirect("/songs/#{@song.slug}")
  end

end
