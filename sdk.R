##########
# INPUTS #
##########

# token = "Mkz9GRYoIhyuJ898YG89Ig"
# secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd"
# host = "demo.looker.com"
# port = 443

# required packages
require(RCurl)
require(rjson)
require(digest)

# LookerSetup simply declares token, secret, host, and port as variables in the Looker environment which are then used in LookerQuery function
LookerSetup = function(token, secret, host, port){

		Looker <<- new.env()
	
		Looker$token <- token
	
		Looker$secret <- secret
	
		Looker$host <- host
	
		Looker$port <- port
	}

# LookerQuery constructs the API call
LookerQuery = function(dictionary, query, fields, filters = NULL){

		Looker$field_list <- paste(as.character(fields), sep="' '", collapse=",")

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
								paste("fields=", Looker$field_list, sep=""), 
								sep=""
							)

				} else {	

			filter_list_clean <- filtersClean(filters)

			Looker$url <- paste(
								"https://", 
								Looker$host, 
								Looker$location, 
								"?", 
								paste("fields=", Looker$field_list, sep=""), 
								'&', 
								filter_list_clean, 
								sep="")
				}

		if(is.null(filters)){

		Looker$StringToSign <- paste('GET', '\n',  
										Looker$location, '\n', 
										Looker$today, '\n',
										Looker$nonce, '\n',
										paste("fields=", Looker$field_list, sep=""), '\n',
										sep = '')			
		} else {

		Looker$StringToSign <- paste('GET', '\n',  
										Looker$location, '\n', 
										Looker$today, '\n',
										Looker$nonce, '\n',
										paste("fields=", Looker$field_list, sep=""), '\n',
										paste(gsub("&", "\n", filter_list_clean), "\n", sep=""),
										sep = '')		
		}

		Looker$signature <- base64(hmac(Looker$secret, enc2utf8(Looker$StringToSign), algo="sha1", raw=TRUE), encode=TRUE)[1]
		
		Looker$authorization <- paste(Looker$token, Looker$signature, sep=":")

		Looker$results <- getURL(Looker$url, 
							httpheader = c(Authorization = Looker$authorization, 
										Date = Looker$today,
										'x-llooker-nonce' = Looker$nonce,
										Accept = "application/json",
										"x-llooker-api-version" = 1),
							.opts = list(ssl.verifypeer = FALSE, timeout = 3)
			)
return(Looker$results)
}

# in the case of one or more filters, filtersClean handles proper url formatting #
filtersClean = function(filters){

filter_list = strsplit(filters, split=":")

		if(length(filter_list)==1){

			filter_list_clean <- gsub(" ", "+", paste("filters[", filter_list[[1]][1], "]=", gsub("^[[:space:]]|[[:space:]]$", "", filter_list[[1]])[2], sep=""))

		} else {

			filter_list_clean <- list()

			for (i in 1:length(filter_list)) {

					filter_list_clean[[i]] <- gsub(" ", "+", paste("filters[", filter_list[[i]][1], "]=", gsub("^[[:space:]]|[[:space:]]$", "", filter_list[[i]])[2], sep=""))
			}

		filter_list_clean <- paste(unlist(filter_list_clean), collapse="&")
	}
return(filter_list_clean)
}


# TEST QUERIES #
LookerSetup(
	token = "Mkz9GRYoIhyuJ898YG89Ig", 
	secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd", 
	host = "demo.looker.com", 
	port = 443
)

LookerQuery(
	dictionary="thelook", 
	query="orders", 
	fields=c("orders.count", "users.count", "users.created_month"), 
	filters=c("orders.created_date:365 days", "users.created_date: 12 months ago for 10 months ")
)

LookerQuery(
	dictionary="thelook", 
	query="orders", 
	fields=c("orders.count", "users.count", "users.created_month"), 
	filters=c("orders.created_date:365 days")
)

LookerQuery(
	dictionary="thelook", 
	query="users", 
	fields=c("users.age", "users.count"), 
	filters=c("orders.created_date:365 days")
)