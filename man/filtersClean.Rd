\name{filtersClean}
\alias{filtersClean}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
filtersClean
}
\description{
this function cleans up the filters string(s) taken as input in LookerQuery
}
\usage{
filtersClean(filters = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
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
function (filters = NULL) 
{
    filter_list = strsplit(filters, split = ":")
    if (length(filter_list) == 1) {
        filter_list_clean <- gsub(" ", "+", paste("filters[", 
            filter_list[[1]][1], "]=", gsub("^[[:space:]]|[[:space:]]$", 
                "", filter_list[[1]])[2], sep = ""))
    }
    else {
        filter_list_clean <- list()
        for (i in 1:length(filter_list)) {
            filter_list_clean[[i]] <- gsub(" ", "+", paste("filters[", 
                filter_list[[i]][1], "]=", gsub("^[[:space:]]|[[:space:]]$", 
                  "", filter_list[[i]])[2], sep = ""))
        }
        filter_list_clean <- paste(unlist(filter_list_clean), 
            collapse = "&")
    }
    return(filter_list_clean)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
