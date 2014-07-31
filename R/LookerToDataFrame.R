LookerToDataFrame = function(LookerObject){

	header <- unlist(LookerObject$fields, use.names = FALSE)

	df <- as.data.frame(
					matrix(
						unlist(
							LookerObject$data), 
						ncol = length(header), 
						byrow = TRUE)
					)

	names(df) <- header
	return(df)
}
