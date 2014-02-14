convertTypes = function(data, character.set = NULL, numeric.set = NULL, integer.set = NULL){

	asNumeric = function(x) as.numeric(as.character(x))

		
		if (length(numeric.set)==1) {
			
			data[ ,numeric.set] <- unlist(lapply(data[ ,numeric.set], asNumeric))
			
		} else if (length(numeric.set) > 1){
			
			data[ ,numeric.set] <- lapply(data[ ,numeric.set], asNumeric)
			
		} else {

			# do nothing

		}

		
		if (length(character.set)==1) {
			
			data[ ,character.set] <- unlist(lapply(data[ ,character.set], as.character))
			
		} else if (length(character.set) > 0){
			
			data[ ,character.set] <- lapply(data[ ,character.set], as.character)
			
		} else {

			# do nothing
		}

			
		if (length(integer.set)==1) {
			
			data[ ,integer.set] <- unlist(lapply(data[ ,integer.set], as.integer))
			
		} else if (length(integer.set) > 1){
			
			data[ ,integer.set] <- lapply(data[ ,integer.set], as.integer)
			
		} else {

			# do nothing

		}
		
	return(data)
}