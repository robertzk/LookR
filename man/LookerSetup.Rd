\name{LookerSetup}
\alias{LookerSetup}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
LookerSetup
}
\description{
Takes API token, API secret, host and port as input and stores them for user in LookerQuery
}
\usage{
LookerSetup(token, secret, host, port)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{token}{
%%     ~~Describe \code{token} here~~
}
  \item{secret}{
%%     ~~Describe \code{secret} here~~
}
  \item{host}{
%%     ~~Describe \code{host} here~~
}
  \item{port}{
%%     ~~Describe \code{port} here~~
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
function (token, secret, host, port) 
{
    if (url.exists(paste("https://", host, sep = ""))) {
        Looker <<- new.env()
        Looker$token <- token
        Looker$secret <- secret
        Looker$host <- host
        Looker$port <- port
    }
    else {
        stop("The host name you entered does not exist.")
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
