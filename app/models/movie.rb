class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list=[], sort_key)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    if ratings_list.empty?
      return Movie.all.order(sort_key)
    else
      return Movie.where(rating: ratings_list).order(sort_key)
    end
  end

end
