module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
end

# hilite helper func
def is_hilite(the_key)
  if @sort_key == the_key
    return "hilite"
  end
end