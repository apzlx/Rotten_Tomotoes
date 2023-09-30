class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    @back_link_params = { sort: session[:sort], ratings: session[:ratings] }
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','R','PG','PG-13']
    allowed_sorts = ["title", "release_date"]

    sort = params[:sort] || session[:sort]
    ratings = params[:ratings] || session[:ratings]
    
    if params[:ratings] == nil
      @movies = Movie.all
      @ratings_to_show = @all_ratings
    else
      @movies = Movie.with_ratings(params[:ratings].keys)
      @ratings_to_show = params[:ratings].keys
    end

    if allowed_sorts.include?(sort)
      @movies = @movies.order(sort)
    end

    session[:sort] = sort
    session[:ratings] = ratings
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

  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  
end
