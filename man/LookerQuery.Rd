\name{LookerQuery}
\alias{LookerQuery}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
LookerQuery
}
\description{
Builds an API call in the form of a GET
}
\usage{
LookerQuery(dictionary, query, fields, filters = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dictionary}{
%%     ~~Describe \code{dictionary} here~~
}
  \item{query}{
%%     ~~Describe \code{query} here~~
}
  \item{fields}{
%%     ~~Describe \code{fields} here~~
}
  \item{filters}{
%%     ~~Describe \code{filters} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (dictionary, query, fields, filters = NULL) 
{
    require(RCurl)
    require(rjson)
    require(digest)
    Looker$field_list <- paste(as.character(sort(fields)), sep = "' '", 
        collapse = ",")
    Looker$today <- format(Sys.time(), format = "\%a, \%d \%b \%Y \%H:\%M:\%S -0800")
    Looker$location <- paste("/api/dictionaries", dictionary, 
        "queries", paste(query, ".json", sep = ""), sep = "/")
    Looker$nonce <- paste(sample(c(letters[1:26], sample(0:9, 
        10)), 32), collapse = "")
    if (is.null(filters)) {
        Looker$url <- paste("https://", Looker$host, Looker$location, 
            "?", paste("fields=", Looker$field_list, sep = ""), 
            sep = "")
    }
    else {
        filter_list_clean <- filtersClean(sort(filters))
        Looker$url <- paste("https://", Looker$host, Looker$location, 
            "?", paste("fields=", Looker$field_list, sep = ""), 
            "&", filter_list_clean, sep = "")
    }
    if (is.null(filters)) {
        Looker$StringToSign <- paste("GET", "\n", Looker$location, 
            "\n", Looker$today, "\n", Looker$nonce, "\n", paste("fields=", 
                Looker$field_list, sep = ""), "\n", sep = "")
    }
    else {
        Looker$StringToSign <- paste("GET", "\n", Looker$location, 
            "\n", Looker$today, "\n", Looker$nonce, "\n", paste("fields=", 
                Looker$field_list, sep = ""), "\n", paste(gsub("&", 
                "\n", filter_list_clean), "\n", sep = ""), sep = "")
    }
    Looker$signature <- base64(hmac(Looker$secret, enc2utf8(Looker$StringToSign), 
        algo = "sha1", raw = TRUE), encode = TRUE)[1]
    Looker$authorization <- paste(Looker$token, Looker$signature, 
        sep = ":")
    Looker$results <- getURL(Looker$url, httpheader = c(Authorization = Looker$authorization, 
        Date = Looker$today, `x-llooker-nonce` = Looker$nonce, 
        Accept = "application/json", `x-llooker-api-version` = 1), 
        .opts = list(ssl.verifypeer = FALSE, timeout = 3))
    Looker$output <- LookerToDataFrame(Looker$results)
    return(Looker$output)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
