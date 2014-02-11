LookerToDataFrame = function(LookerObject){

	header <- unlist(fromJSON(LookerObject, nullValue = NA)$fields, use.names = FALSE)

	df <- as.data.frame(
					matrix(
						unlist(
							fromJSON(LookerObject, nullValue = NA)$data), 
						ncol = length(header), 
						byrow = TRUE)
					)

	names(df) <- header
	return(df)
}