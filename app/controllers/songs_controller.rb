require 'sinatra/base'
require 'rack-flash'


class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/songs' do
        erb :'songs/index'
    end

    get '/songs/new' do
        erb :'songs/new'
    end

    post '/songs' do
        @song = Song.create(params[:song])
        if !params[:artist][:name].empty? && !Artist.find_by(name: params[:artist][:name])
            @song.artist_id = Artist.create(params[:artist]).id
            @song.save
        else
            @song.artist = Artist.find_by(name: params[:artist][:name])
            @song.save    
        end
        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/edit'
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])
        if !params[:artist][:name].empty?
            if !Artist.find_by(name: params[:artist][:name])
                @song.artist_id = Artist.create(params[:artist]).id
                @song.save
            else   
                @song.artist_id = Artist.find_by(name: params[:artist][:name]).id
                @song.save
            end    
        end
        flash[:message] = "Successfully updated song."
        redirect "/songs/#{@song.slug}"
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/show'
    end
end