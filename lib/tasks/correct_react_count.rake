desc 'Correct react count for movies'
task correct_react_count: :environment do
  puts "Start at: #{DateTime.now}"
  movies = Movie.all
  success_count = 0
  puts "Number of movie: #{movies.size}"

  movies.each do |movie|
    movie.like_count = movie.reacts.like.count
    movie.dislike_count = movie.reacts.dislike.count
    if movie.save
      success_count += 1
    else
      puts "Failed with movie_id: #{movie.id}"
    end
  end
  puts "Finish at: #{DateTime.now}, total #{success_count} movies was corrected success"
end