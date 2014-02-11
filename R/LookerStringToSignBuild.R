# LookerStringToSignBuild(...) constructs a url which is used as the main argument in the GET request 

LookerStringToSignBuild = function(filters = Looker$filters, limit = Looker$limit){

	location <- Looker$location
	field_list <- Looker$field_list
	today <- Looker$today
	nonce <- Looker$nonce
	filter_list_clean <- Looker$filter_list_clean

	# case when filters IS NULL and limit IS NULL #
		if(is.na(filters) && is.na(limit)){

		StringToSign <- paste('GET', '\n',  
										location, '\n', 
										today, '\n',
										nonce, '\n',
										paste(
											"fields=", 
											field_list, 
											sep=""), 
											'\n',
										sep="")	

	# case when filters IS NULL and limit IS NOT NULL #
				} else if(is.na(filters) && !is.na(limit)){

		StringToSign <- paste('GET', 
									'\n',  
									location, '\n', 
									today, '\n',
									nonce, '\n',
									paste("fields=", field_list, sep=""), 
										'\n',
									paste("&limit=", limit, sep=""), '\n',
									sep = '')	

	# case when filters IS NOT NULL and limit IS NULL #
				} else if(!is.na(filters) && is.na(limit)){

		StringToSign <- paste('GET', '\n',  
										location, '\n', 
										today, '\n',
										nonce, '\n',
										paste(
											"fields=", 
											field_list, 
											sep=""), 
											'\n',
										paste(
											gsub("&", "\n", filter_list_clean), 
											"\n", 
											sep=""),
										sep = '')	

	# case when filters IS NOT NULL and limit IS NOT NULL #		
				} else {

		StringToSign <- paste('GET', '\n',  
										location, '\n', 
										today, '\n',
										nonce, '\n',
										paste(
											"fields=", 
											field_list, 
											sep=""), 
											'\n',
										paste(
											gsub("&", "\n", filter_list_clean), 
											"\n", 
											sep=""),
										paste("&limit=", limit, sep=""), '\n',
										sep = '')	
				}
return(StringToSign)				
}				