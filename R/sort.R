ascii_sort <- function(string) {
  string2 <- force(string) # Duplicate so string isn't modified

  .Call('LookR_cpp_str_sort', string, PACKAGE = 'LookR')
}

ascii_order <- function(string) {
  match(ascii_sort(string), string)
}
