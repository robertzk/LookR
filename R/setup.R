# LookerSetup simply declares token, secret, host, and port as variables 
# in the Looker environment. They are then used in the LookerQuery function.

LookerSetup = function(token, secret, host, port){

		if(url.exists(paste("https://", host, sep=""))){
		
		Looker <<- new.env()
	
		Looker$token <- token
	
		Looker$secret <- secret
	
		Looker$host <- host
	
		Looker$port <- port
		
		} else {

			stop("The host name you entered does not exist.")

		}
	}