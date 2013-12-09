LookerToDataFrame = function(LookerObject){

	header <- unlist(fromJSON(LookerObject)$fields, use.names = FALSE)

	df <- data.frame(
					matrix(
						unlist(
							fromJSON(LookerObject)$data), 
						ncol = length(header), 
						byrow = TRUE)
					)

	names(df) <- header
	return(df)
}