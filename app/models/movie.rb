class Movie < ActiveRecord::Base
  def self.all_ratings
    allRatings = Movie.uniq.pluck(:rating)
    return allRatings
  end
  def self.fliter_ratings(keys)
    return Movie.where(:rating =>keys)
  end
  def self.fliter_ratings_order(keys,sort_order)
    return Movie.where(:rating => keys).order(sort_order)
  end
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    return Movie.where(rating: ratings_list)
  end
end