# LookerStringToSignBuild(...) constructs a url which is used as the main argument in the GET request 
LookerStringToSignBuild = function(filters = Looker$filters, limit = Looker$limit){
  location <- Looker$location
  field_list <- Looker$field_list
  today <- Looker$today
  nonce <- Looker$nonce
  filter_list_clean <- Looker$filter_list_clean
  request_lines <- c("GET", location, today, nonce)
  request_lines <- c(request_lines, paste0("fields=", field_list))
  if (!identical(NA, filters))
    request_lines <- c(request_lines, paste0(gsub("&", "\n", filter_list_clean)))
  if (!identical(NA, limit))
    request_lines <- c(request_lines, paste0("limit=", limit))
  request_lines <- c(request_lines, c(""))
  request_lines <- paste(request_lines, collapse = "\n")
  request_lines
}				
