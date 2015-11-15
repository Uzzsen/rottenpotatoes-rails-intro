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
		
#	if params[:ratings].nil? || params[:order_by].nil?
#	  params[:ratings] ||= Hash[session[:selected].collect {|v| [v, 1]}]
#	  params[:order_by] ||= session[:order]
# 	  flash.keep
#	  redirect_to movies_path params
#	end
	
	session[:selected] = params[:ratings].keys unless params[:ratings].nil?
	session[:selected] ||= @all_ratings	
	session[:order] = params[:order_by] unless params[:order_by].nil?


#	session[:order] = nil
# 	params[:order_by] == nil ? session[:order] ='id' : session[:order] = params[:order_by]
   #debugger
  case session[:order] #!= nil 
    	#by = session[:order]
	when 'title'	
	  @title_order = 'hilite'
	  @movies = Movie.where(rating: session[:selected]).order(session[:order])
	when 'release_date'
	  @release_date_order = 'hilite'
    @movies = Movie.where(rating: session[:selected]).order(session[:order])	   
  else 
	  @title_order = nil	 
	  @release_date_order = nil
	  @movies = Movie.where(rating: session[:selected]).order("id")
  end
	@selected= []	
	@selected = session[:selected]

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
