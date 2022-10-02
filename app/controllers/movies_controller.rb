class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings =  Movie.all_ratings

    if params[:commit] == "Refresh"
      reset_session
    end

    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
    else
      @ratings_to_show = session[:ratings_to_show] || []
    end

    session[:ratings_to_show] = @ratings_to_show

    @movie_title_style = ""
    @release_date_style = ""
    @sort_key =  session[:sort_key] || ""

    case params[:sort]
    when "title"
      @movie_title_style = "hilite"
      @sort_key = "title"
    when "release_date"
      @release_date_style = "hilite"
      @sort_key = "release_date"
    end

    session[:sort_key] = @sort_key

    @movies = Movie.with_ratings(@ratings_to_show, @sort_key)
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
