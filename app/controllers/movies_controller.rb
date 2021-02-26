class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  if request.env['PATH_INFO']== '/'
    session.clear
  end
    @all_ratings = Movie.all_ratings
#    @filtered_ratings=params[:ratings]
    
#    @Keys=( params[:ratings].nil? ? [] : @filtered_ratings.keys)
 #   @movies=@filtered_ratings==[] ? Movie.all: Movie.with_ratings(@Keys)
    
 #   @ratings_to_show=@Keys
    
    @flag=0
    @flag2=0
  #  print('*-------')
  #  print(params[:utf8])
  #  print('-------')
    
    
    if params[:ratings] 
      @filtered_ratings = params[:ratings]
      session[:ratings] = @filtered_ratings
    elsif params[:click_button]
      @filtered_ratings = nil
      #If user selects no filter then everything should get cleared
      session[:sort_by] =nil
    
      session[:ratings] =nil
    elsif session[:ratings] 
      flag=1
      @filtered_ratings = session[:ratings]
    else
      @filtered_ratings = nil
    end

    if params[:sort_by]
      @sort_order = params[:sort_by]
      session[:sort_by] = @sort_order
    elsif session[:sort_by]
      flag=1
      @sort_order = session[:sort_by]
    else
      @sort_order = nil
    end 
    if flag==1
      redirect_to movies_path :sort_by => @sort_order, :ratings => @filtered_ratings
    end
    
    @ratings_to_show=[]
    if @filtered_ratings
      @ratings_to_show=@filtered_ratings.keys
    end
    # I removed this part of code which used to put back filters once sort is added 
    # if !@filtered_ratings
    #   @filtered_ratings = @all_ratings.each_with_object('1').to_h
    
    # end    
    
    if @sort_order and @filtered_ratings
      @movies = Movie.fliter_ratings_order(@filtered_ratings.keys,@sort_order)
   #   @ratings_to_show=@filtered_ratings.keys
    elsif @filtered_ratings
      @movies = Movie.fliter_ratings(@filtered_ratings.keys)
  #    @ratings_to_show=@filtered_ratings.keys
    elsif @sort_order
      @movies = Movie.all.order(@sort_order)
    else
      @movies = Movie.all
    end   
    
  #   if(params[:sort_by]=='title')
   #   @movies=Movie.order:title
#    end
 #   if(params[:sort_by]=='date')
  #    @movies=Movie.order:release_date
   # end
    
  
   
   
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
