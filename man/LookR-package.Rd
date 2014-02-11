\name{LookR-package}
\alias{LookR-package}
\alias{LookR}
\docType{package}
\title{
An Interface for the Looker API
}
\description{
LookR is a package that contains functions that interface with the Looker API (namely, LookerSetup and LookerQuery).
}
\details{
\tabular{ll}{
Package: \tab LookR\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-12-08\cr
}
LookerSetup takes the API token and secret, as well as the host and port as inputs and brings them into R in a Looker environments to be used in LookerQuery. LookerQuery builds a GET request from a list of fields (i.e., dimensions and measures) as well as filters specified as arguments in the function. 
}
\author{
Scott Hoover

Maintainer: <scott@looker.com>
}
\keyword{ Looker }
