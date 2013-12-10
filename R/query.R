# LookerQuery constructs the API call
LookerQuery = function(dictionary, query, fields, filters = NULL){

# required packages #
require(RCurl)
require(rjson)
require(digest)

		Looker$field_list <- paste(as.character(sort(fields)), sep="' '", collapse=",")

		Looker$today <- format(Sys.time(), format="%a, %d %b %Y %H:%M:%S -0800")

		Looker$location <- paste(
								"/api/dictionaries", 
								dictionary, 
								"queries", 
								paste(query, '.json', sep = ""), 
								sep = "/"
							)

		Looker$nonce <- paste(sample(c(letters[1:26], sample(0:9, 10)), 32), collapse = "")

# allow for queries without filters #
		if(is.null(filters)){

			Looker$url <- paste(
								"https://", 
								Looker$host, 
								Looker$location, 
								"?", 
								paste(
									"fields=", 
									Looker$field_list, 
									sep=""), 
								sep=""
							)

				} else {	

			filter_list_clean <- filtersClean(sort(filters))

			Looker$url <- paste(
								"https://", 
								Looker$host, 
								Looker$location, 
								"?", 
								paste(
									"fields=", 
									Looker$field_list, 
									sep=""), 
								'&', 
								filter_list_clean, 
								sep="")
				}

		if(is.null(filters)){

		Looker$StringToSign <- paste('GET', '\n',  
										Looker$location, '\n', 
										Looker$today, '\n',
										Looker$nonce, '\n',
										paste(
											"fields=", 
											Looker$field_list, 
											sep=""), 
											'\n',
										sep="")			
		} else {

		Looker$StringToSign <- paste('GET', '\n',  
										Looker$location, '\n', 
										Looker$today, '\n',
										Looker$nonce, '\n',
										paste(
											"fields=", 
											Looker$field_list, 
											sep=""), 
											'\n',
										paste(
											gsub("&", "\n", filter_list_clean), 
											"\n", 
											sep=""),
										sep = '')		
		}

		Looker$signature <- base64(
								hmac(
									Looker$secret, 
									enc2utf8(
										Looker$StringToSign), 
									algo="sha1", 
									raw=TRUE), 
								encode=TRUE)[1]
		
		Looker$authorization <- paste(Looker$token, Looker$signature, sep=":")

		Looker$results <- getURL(Looker$url, 
							httpheader = c(Authorization = Looker$authorization, 
										Date = Looker$today,
										'x-llooker-nonce' = Looker$nonce,
										Accept = "application/json",
										"x-llooker-api-version" = 1),
							.opts = list(ssl.verifypeer = FALSE, timeout = 30)
			)

		Looker$output <- LookerToDataFrame(Looker$results)

# print to screen the filters applied (it is not expicit in the result set) #
		message(
			sprintf(
				"%s has been applied as a filter\n", 
				gsub("^[[:space:]]|[[:space:]]$",
				"",
				paste(
					str_extract(filters, "^.*:"), 
					paste(
						"'", 
						gsub(
							":[[:space:]]*", 
							"", 
							str_extract(filters, ":.*[[:alnum:]].*")
							), 
						"'", 
						sep=""
						), 
					sep=""
					)
				)
			)
		)

	return(Looker$output)

}