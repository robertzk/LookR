# INPUTS 
# token = "Mkz9GRYoIhyuJ898YG89Ig"
# secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd"
# host = "demo.looker.com"
# port = 443
# https://demo.looker.com/explore/thelook/orders.json?fields=orders.count,users.count,users.created_month&f[users.created_month]=6+months

require(RCurl)
require(rjson)
require(digest)

#####################
# A ONE-OFF ATTEMPT #
#####################

token = "Mkz9GRYoIhyuJ898YG89Ig"
secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd"
host = "demo.looker.com"
port = 443
dictionary = "thelook"
query = "orders"
fields = c("orders.count", "users.count", "users.created_month")
filters = c("orders.created_date:365 days")
field_list = paste(as.character(fields), sep="' '", collapse=",")
# today = format(Sys.time(), format="%a, %d %b %Y %H:%M:%S -0800")
today = "Wed, 04 Dec 2013 16:13:49 -0800"
location = paste("/api/dictionaries", dictionary, "queries", paste(query, '.json', sep = ""), sep = "/")
# nonce = paste(sample(c(letters[1:26], sample(0:9, 10)), 32), collapse = "")
nonce = "ib1ft86rwc0d5hnex4lomjqv7zkya93p"
query_params = paste(paste("fields=", field_list, sep=""), paste("filters[", unlist(strsplit(filters, split=":"))[1], "]=", gsub(' ', '+', unlist(strsplit(filters, split=":"))[2]), sep=""), sep="&")
StringToSign = paste('GET', '\n',  
						location, '\n', 
						today, '\n',
						nonce, '\n',
						query_params, '\n',
						sep = '')
signature = base64(hmac(secret, enc2utf8(StringToSign), algo="sha1", raw=TRUE), encode=TRUE)
authorization = paste(token, signature, sep=":")

getURL("https://demo.looker.com/api/dictionaries/thelook/queries/orders.json?fields=orders.count,users.count,users.created_month&filters[orders.created_date]=365+days", 
					httpheader = c(Authorization = authorization,
								Date = today,
								'x-llooker-nonce' = nonce,
								Accept = "application/json"),
					.opts = list(ssl.verifypeer = FALSE, verbose = TRUE)
)

# Ruby output
# "GET\n/api/dictionaries/thelook/queries/orders.json\nWed, 04 Dec 2013 16:13:49 -0800\nib1ft86rwc0d5hnex4lomjqv7zkya93p\nfields=orders.count,users.count,users.created_month\nfilters[orders.created_date]=365+days\n"
# AUTH: Mkz9GRYoIhyuJ898YG89Ig:+L+w38E7dt7RwxlzYuRON3giLwE=

# R output
# "GET\n/api/dictionaries/thelook/queries/orders.json\nWed, 04 Dec 2013 16:13:49 -0800\nib1ft86rwc0d5hnex4lomjqv7zkya93p\nfields=orders.count,users.count,users.created_month\nfilters[orders.created_date]=365+days\n"
# AUTH: Mkz9GRYoIhyuJ898YG89Ig:NWQwM2QzMDZjMzdlMDEyNzgxN2I5ODRjNzBlZmIxZDNkZDMxODRkNg==


#########################
# A PROGRAMATIC ATTEMPT #
#########################

# LookerSetup simply declares token, secret, host, and port as variables in the Looker environment which are then used in LookerQuery function
LookerSetup = function(token, secret, host, port){

		Looker <<- new.env()
	
		Looker$token <- token
	
		Looker$secret <- secret
	
		Looker$host <- host
	
		Looker$port <- port
	}

LookerSetup(token = "Mkz9GRYoIhyuJ898YG89Ig", secret = "v1+MNxMg1vdmljYbtBhEDFEQSlAUEZd4xWd", host = "demo.looker.com", port = 443)

# LookerQuery constructs the API call
LookerQuery = function(dictionary, query, fields, filters){

		Looker$field_list <- paste(as.character(fields), sep="' '", collapse=",")

		Looker$today <- format(Sys.time(), format="%a, %d %b %Y %H:%M:%S -0800")

		Looker$location <- paste("/api/dictionaries", dictionary, "queries", paste(query, '.json', sep = ""), sep = "/")

		Looker$nonce <- paste(sample(c(letters[1:26], sample(0:9, 10)), 32), collapse = "")

		Looker$query_params <- paste(paste("fields=", Looker$field_list, sep=""), paste("filters[", unlist(strsplit(filters, split=":"))[1], "]=", gsub(' ', '+', unlist(strsplit(filters, split=":"))[2]), sep=""), sep="&")

		Looker$StringToSign <- paste('GET', '\n',  
								Looker$location, '\n', 
								Looker$today, '\n',
								Looker$nonce, '\n',
								Looker$query_params, '\n',
								sep = '')

		Looker$signature <- base64Encode(hmac(Looker$secret, enc2utf8(Looker$StringToSign), algo="sha1"))
		
		Looker$authorization <- paste(Looker$token, Looker$signature, sep=":")

		Looker$results <- getURL("https://demo.looker.com/api/dictionaries/thelook/queries/orders.json?fields=orders.count,users.count,users.created_month&filters[orders.created_date]=365+days", 
							httpheader = c(Authorization = Looker$authorization, 
										Date = Looker$today,
										'x-llooker-nonce' = Looker$nonce,
										Accept = "application/json"),
							.opts = list(ssl.verifypeer = FALSE, verbose = TRUE)
			)
return(results)
}

LookerQuery(dictionary="thelook", query="orders", fields=c("orders.count", "users.count", "users.created_month"), filters=c("orders.created_date:365 days"))