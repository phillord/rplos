\name{almupdated}
\alias{almupdated}
\title{Date when alt-metrics for the article (by DOI) data was last updated.}
\usage{
  almupdated(doi, url = "http://alm.plos.org/articles",
    key = getOption("PlosApiKey", stop("need an API key for PLoS Journals")),
    ..., curl = getCurlHandle())
}
\arguments{
  \item{doi}{digital object identifier for an article in
  PLoS Journals}

  \item{key}{your PLoS API key, either enter, or loads from
  .Rprofile}

  \item{url}{the PLoS API url for the function (should be
  left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\value{
  Date when article data was last updated.
}
\description{
  Date when alt-metrics for the article (by DOI) data was
  last updated.
}
\examples{
\dontrun{
almupdated(doi='10.1371/journal.pbio.0000012')
}
}

