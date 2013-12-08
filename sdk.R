##########
# INPUTS #
##########

# token = "Mkz9GRYoIhyuJ898YG89Ig"
# secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd"
# host = "demo.looker.com"
# port = 443

#####################
# A ONE-OFF ATTEMPT #
#####################

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

LookerSetup(
	token = "Mkz9GRYoIhyuJ898YG89Ig", 
	secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd", 
	host = "demo.looker.com", 
	port = 443
)

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
			Looker$url <- paste(
								"https://", 
								Looker$host, 
								Looker$location, 
								"?", 
								paste("fields=", Looker$field_list, sep=""), 
								'&', 
								paste(
									"filters[", 
									unlist(strsplit(filters, split=":"))[1], "]=", 
									gsub(' ', '+', unlist(strsplit(filters, split=":"))[2]), 
									sep=""), 
								sep="")
				}
# TEST

filter_list = strsplit(filters, split=":")
if(length(filter_list)==1){
	# code for single filter
} else{
	for(i in 1:length(filter_list)){
			paste("filters[", filter_list[[i]][1]), "]=",
				gsub(' ', '+', unlist(strsplit(filter_list[[2]], split=":"))[2])
}
}

# END TEST

		Looker$StringToSign <- paste('GET', '\n',  
										Looker$location, '\n', 
										Looker$today, '\n',
										Looker$nonce, '\n',
										paste("fields=", Looker$field_list, sep=""), '\n',
										paste("filters[", unlist(strsplit(filters, split=":"))[1], "]=", gsub(' ', '+', unlist(strsplit(filters, split=":"))[2]), sep=""), '\n',
										sep = '')

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
	filters=c("users.state:California, Nevada", "users.gender:m")
)

setClass("Looker")
useMethod("Setup", "Looker", Setup.Looker)
Setup.Looker = function(token, secret, host, port){
			Looker$token <- token
	
		Looker$secret <- secret
	
		Looker$host <- host
	
		Looker$port <- port
}