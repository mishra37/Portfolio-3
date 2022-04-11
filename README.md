# Portfolio-3

App: https://mishra37.shinyapps.io/portfolio-3/

## Motivation
After watching the recent Batman movie, I was intrigued to see how many other Batman movies are there. 
I was surprised to see that the Batman movies were not only famous because of its actors but also because of its directors. 
Hence, I decided to create an interactive network visualization to see common directors between movies, number of directors 
who directed past versus recent batman movies, and also movies that received the most awards. I also included the DataTable 
to show the corresponding information regarding the item(movie/director) that was brushed in the network graph.

## Findings
I was able to find that The Dark Knight, created in 2008, had the highest number of wins and nominations along with 2 Oscars. 
The movie had an Imdb Rating of 9.0 and it was directed by Christopher Nolan. Apart from that, one can easily make out through 
the network that movies directed by Christopher Nolan had the maximum number of nominations and awards won. Another surprising 
observation was that the 1st movie – Batman and 2nd movie – Batman Returns performed almost the same in terms of Awards and Nominations, 
movie runtime, Imdb Rating, etc., But after those 2 movies, none of the Batman movies seemed to receive any award until like 1995.  
Another surprising thing was that, Batman & Robin released in 1997, had the lowest Imdb rating of 3.7 even after winning 10 awards. 

## Steps taken
I created the visualization by first pre-processing the data. Initially, all the directors for a movie were given in a single row 
as a comma separated value. I decided to have individual rows for each director for a particular movie. This pre-processing step was 
necessary to get the DataFrame consisting of all edges. For this step, I used `separate` and `pivot_longer` functions. Furthermore, 
to differentiate between the nodes for movies and directors, I mutated a column called `is_movie` with Boolean values to show if a 
row item is a movie or a director. Then, I used this column to change the color, font and size of the node. I also depicted the total 
number of awards won and nomination of a particular movies by the edges of the graph. I added interactivity to the visualization by 
using plot_brush on the ggraph object, such that brushing on any part of the visualization filtered out the corresponding information 
of movie or director in the DataTable.

