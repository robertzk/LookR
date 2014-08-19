# In the case of one or more filters, filtersClean handles 
# proper url cleanup and formatting

filtersClean = function(filters = Looker$filters){

filter_list = strsplit(filters, split=":")

		if(length(filter_list)==1){

			filter_list_clean <- gsub(
									" ", 
									"+", 
									paste(
										"filters[", 
										filter_list[[1]][1], 
										"]=", 
										gsub("^[[:space:]]|[[:space:]]$", "", filter_list[[1]])[2], 
									sep="")
								)

		} else {

			filter_list_clean <- list()

			for (i in 1:length(filter_list)) {

					filter_list_clean[[i]] <- gsub(
												" ", 
												"+", 
												paste(
													"filters[", 
													filter_list[[i]][1], 
													"]=", 
													gsub("^[[:space:]]|[[:space:]]$", "", filter_list[[i]])[2], 
													sep="")
												)
			}

		filter_list_clean <- paste(unlist(filter_list_clean), collapse="&")
	}

return(URLencode(filter_list_clean))

}
