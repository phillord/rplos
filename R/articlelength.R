#' Get article length of single paper by DOI, or of many papers as histogram.
#' 
#' @import RJSONIO RCurl ggplot2
#' @param id article identifier DOI = id, or subject area, e.g.: 'ecology'
#' @param fields fields to return from search (character) [e.g., 'id,title'], 
#'     any combination of search fields [see plosfields$field]
#' @param limit number of results to return (integer)
#' @param searchin search field to search in (character)
#' @param url the PLoS API url for the function (should be left to default)
#' @param key your PLoS API key, either enter, or loads from .Rprofile
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass 
#'  the returned value in here (avoids unnecessary footprint)
#' @return Length of articles (no. words) as text (single paper) or histogram 
#'  (>1 paper).
#' @examples \dontrun{
#' articlelength("10.1371/journal.pone.0004045", "body")
#' articlelength("10.1371/journal.pone.0004045", "everything")
#' articlelength("10.1371/journal.pone.0004045", "title")
#' articlelength("ecology", "materials_and_methods", 500, "subject")
#' articlelength("ecology", "results_and_discussion", 500, "subject")
#' }
#' @export
articlelength <- function(id = NA, fields = NA, limit = NA, searchin = NA,
  url = 'http://api.plos.org/search',
  key = getOption("PlosApiKey", stop("need an API key for PLoS Journals")),
  ..., curl = getCurlHandle() ) 
{
  args <- list(apikey = key)
  if(!is.na(searchin)) { mysearch  <- paste(searchin, ":", id, sep="") } else { mysearch <- id }
  if(!is.na(mysearch))
    args$q <- mysearch
  if(!is.na(fields))
    args$fl <- fields
  if(!is.na(limit))
    args$rows <- limit
  args$wt <- "json"
  
  if(is.na(searchin)) {
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl)
  jsonout <- fromJSON(I(tt))
  numwords <- length(strsplit(jsonout$response$docs[[1]][[1]], " ")[[1]])
  return(numwords)
  }
  
  else {
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl)
  jsonout <- fromJSON(I(tt))
  out <- jsonout$response$docs
  outvec <- do.call(c, out)
  vecc <- as.data.frame(sapply(as.list(outvec), function(x) nchar(x)))
  names(vecc) <- "No.Characters"
  a <- ggplot(vecc, aes(x=No.Characters)) + geom_histogram()
  return(a)
  }
}