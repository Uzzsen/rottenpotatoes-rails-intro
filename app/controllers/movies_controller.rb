class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
  @all_ratings = []
	Movie.find_each do |m|
	@all_ratings << m.rating if @all_ratings.none? {|r| r == m.rating}
		end
	
  #session[:selected] = params[:ratings].keys unless params[:ratings].nil?
	#session[:selected] ||= @all_ratings	
	sorting = params[:order] || session[:order]
	
  case sorting #!= nil 
    	#by = session[:order]
	when 'title'	
	  ordering, @title_order = {:order => :title}, 'hilite'
	when 'release_date'
	  ordering, @release_date_order = {:order => :release_date}, 'hilite'
#    @movies = Movie.where(rating: session[:selected]).order(session[:order])	   
#  else 
#	  @title_order = nil	 
#	  @release_date_order = nil
#	  @movies = Movie.where(rating: session[:selected]).order("id")
  end
	
	@selected = params[:selected] || session[:selected] || {}
	if @selected == {}
	   @selected = Hash[@all_ratings.map {|rating| [rating, rating]}] 
	end	

  if session[:selected] != params[:selected] || session[:order] != params[:order]
     session[:selected] = @selected
     session[:order] = sorting
     redirect_to :order => ordering, :selected => @selected and return
  end
     @movies = Movie.where(rating: @selected.keys).order(ordering)	   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
