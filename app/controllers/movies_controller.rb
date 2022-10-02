class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings =  Movie.all_ratings
    #clear session if click refresh
    if params[:commit] == "Refresh"
      reset_session
    end

    @ratings_to_show = session[:ratings_to_show] || @all_ratings
    @sort_key = session[:sort_key] || ""

    if (!params[:ratings] || !params[:sort]) && (@sort_key != "" || @ratings_to_show != @all_ratings)
      redirect_to movies_path(:sort => @sort_key,
                              :ratings => Hash[@ratings_to_show.map { |x| [x, 1]}])
    end

    #ratings
    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
    else
      @ratings_to_show = session[:ratings_to_show] || @all_ratings
    end

    session[:ratings_to_show] = @ratings_to_show

    #sort_key
    @sort_key = params[:sort] || session[:sort_key] || ""

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
