# LookerQuery constructs the API call
LookerQuery = function(dictionary, query, fields, filters = NA, limit = NA, output = "data.frame"){

# required packages #
# require(RCurl)
# require(RJSONIO)
# require(digest)
# require(stringr)

		Looker$field_list <- paste(as.character(sort(fields)), sep="' '", collapse=",")

		if(any(is.na(filters))){
			Looker$filters <- NA
		} else { 
			Looker$filters <- filters[order(sapply(strsplit(filters, ":"), head, 1))]
    }

		Looker$filter_list_clean <- ifelse(any(is.na(filters)), NA, filtersClean(Looker$filters))

		Looker$limit <- limit

		Looker$today <- format(Sys.time(), format="%a, %d %b %Y %H:%M:%S %z")

		Looker$location <- paste(
								"/api/dictionaries", 
								dictionary, 
								"queries", 
								paste(query, '.json', sep = ""), 
								sep = "/"
							)

		Looker$nonce <- paste(sample(c(letters[1:26], sample(0:9, 10)), 32), collapse = "")

    Looker <<- Looker
		Looker$url <- LookerURLBuild(filters = Looker$filters, limit = Looker$limit)

		Looker$StringToSign <- LookerStringToSignBuild(filters = Looker$filters, limit = Looker$limit)

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
							.opts = list(ssl.verifypeer = FALSE, timeout = 120000)
			)

# output type can be a JSON object or data frame #
    results <- fromJSON(Looker$results, nullValue = NA)

    if (is.element('error_code', names(results)))
      stop("LookerQuery failed because of ", results$error_code, ": \n\n",
           (function(x) { if ('testthat' %in% installed.packages()[,1]) {
            require(testthat); testthat:::colourise(x, 'red') }
            else x })(Looker$results), "\n\n", call. = FALSE)

		if(output == "data.frame"){

			Looker$output <- LookerToDataFrame(LookerObject = results)

		} else {

			Looker$output <- Looker$results

		}


# print to screen the filters applied (it is not expicit in the result set) #
	if(any(!is.na(filters))){
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
	} else	{


	}
	return(Looker$output)

}
