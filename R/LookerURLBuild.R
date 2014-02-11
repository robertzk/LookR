# LookerURLBuild(...) constructs a url which is used as the main argument in the GET request 

LookerURLBuild = function(...){

	host <- Looker$host
	location <- Looker$location
	field_list <- Looker$field_list
	filters <- Looker$filters
	limit <- Looker$limit
	filter_list_clean <- Looker$filter_list_clean

	# case when filters IS NULL and limit IS NULL #
		if(is.na(filters) && is.na(limit)){

					url <- paste(
								"https://", 
								host, 
								location, 
								"?", 
								paste(
									"fields=", 
									field_list, 
									sep=""),
								sep=""
							)
	# case when filters IS NULL and limit IS NOT NULL #
				} else if(is.na(filters) && !is.na(limit)){
			
					url <- paste(
								"https://", 
								host, 
								location, 
								"?", 
								paste(
									"fields=", 
									field_list, 
									sep=""),
								paste("&limit=", limit, sep=""), 
								sep=""
							)
	# case when filters IS NOT NULL and limit IS NULL #
				} else if(!is.na(filters) && is.na(limit)){

					url <- paste(
								"https://", 
								host, 
								location, 
								"?", 
								paste(
									"fields=", 
									field_list, 
									sep=""), 
								'&', 
								filter_list_clean,
								sep=""
							)
	# case when filters IS NOT NULL and limit IS NOT NULL #			
				} else {

					url <- paste(
								"https://", 
								host, 
								location, 
								"?", 
								paste(
									"fields=", 
									field_list, 
									sep=""), 
								'&', 
								filter_list_clean,
								paste("&limit=", limit, sep=""), 
								sep="")
				}
return(url)				
}				