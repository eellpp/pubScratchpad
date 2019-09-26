

Trending/popularity - This indicates what is being preferred and read by users and indicates content performance

The popular contents can be assigned higher weightage for recommendation, as compared to another article with the same features.

Trending can be based on :
- user hits
- feature trending (named entities that are getting popular)
- topic trending

Other Popularity based measures:
`Popularity - Basic`: The candidate set is all items in the dataset.  
`Popularity - Geolocation`: The candidate set is all items that have been read by users in the same geographical location as the target user.   
`Popularity - Item`: Categories Every item is associated with zero or more  news categories (business, sports, politics, etc.). The candidate set is all items whose categories intersect with the target article’s categories.  
`Popularity - Weekday`: The candidate set is all items that have been seen at least once in the same week day as the target article.  
`Popularity - Hour`: The candidate set is all items that have been seen at least once in the same hour as the target article.  
`Popularity - Freshness`: The candidate set is all articles that have been published or updated in the last 24 hours.  


### Exclusion List
Before returning the top-N recommendations to the user, we apply three basic filters to the candidate set:  
`Exclude items from other domains`: Recommendations must come from the same domain as the current article; we do not consider cross-domain recommendations although this is something we would like to investigate in the future, once we have an understanding of how single-domain recommenders  
`Exclude already read articles`: We do not make recommendations of articles we know the target user has already read, however we do allow previously recommended articles to be re-recommended if the user did not click on the recommendation the first time. As always, it’s hard to interpret non-clicks in recommender systems; a more mature model might limit the number of times the same recommendation is ultimately shown to a user.  
`Exclude non-recommendable items`: These are items that are flagged as nonrecommendable (usually older articles) 


