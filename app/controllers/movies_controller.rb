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
#debugger	
	  @selected = params[:ratings] || session[:selected] || Hash[@all_ratings.map {|r| [r, 1]}]
  #	session[:selected] ||= Hash[@all_ratings.map {|r| [r, 1]}]
	  @ordered = params[:order_by] || session[:order]
	  session[:selected], session[:order] = @selected, @ordered
	
	  if params[:ratings] != session[:selected] || params[:order_by] != session[:order]
	    flash.keep
	    redirect_to movies_path :ratings => @selected,  :order_by => @ordered
	  end  

#   debugger
    if session[:order] 
      @movies = Movie.where(rating: session[:selected].keys).order(session[:order])
      session[:order] == 'title' ?     @title_order = 'hilite' :   @release_date_order = 'hilite'
    else
      @movies = Movie.where(rating: session[:selected].keys)
      @title_order = nil	 
	    @release_date_order = nil
	  end   

  end

  def new
    # default: render 'new' templates
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
