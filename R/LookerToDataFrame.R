LookerToDataFrame = function(LookerObject){

	header <- unlist(LookerObject$fields, use.names = FALSE)

	df <- data.frame(
					matrix(
						unlist(
							LookerObject$data), 
						ncol = length(header), 
						byrow = TRUE),
            stringsAsFactors = FALSE
					)

	names(df) <- header
	return(df)
}
