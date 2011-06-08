# Function to search results on a keyword over all fields in PLoS Journals

plosword <- 
# Args:
#   terms: search terms (character)
#   vis: visualize results in bar plot or not (TRUE or FALSE) 
# Examples:
#   plosword('Helianthus')
#   plosword(list(monkey','Helianthus','sunflower','protein','whale'), vis = 'TRUE')
#   out <- plosword(list(monkey','Helianthus','sunflower','protein','whale'), vis = 'TRUE')
#   out[[1]] # results in a data frame 
#   out[[2]] # results in a bar plot

function(terms, vis = FALSE,
  url = 'http://api.plos.org/search',
  key = getOption("PlosApiKey", stop("need an API key for PLoS Journals")),
  ..., 
  curl = getCurlHandle() ) 
{
  if (length(terms) == 1) {
  args <- list(apikey = key)
  if(!is.na(terms))
    args$q <- terms
  args$fl <- "id" # just ID field to speed up return of search results
  args$wt <- "json"
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl)
  numres <- fromJSON(I(tt))$response$numFound
  names(numres) <- 'Number of articles with search term'
  return(numres)
  }  
  else {
    search_ <- function(x) {
        args <- list(apikey = key)
        if(!is.na(x))
        args$q <- x
        args$fl <- "id" # just ID field to speed up return of search results
        args$wt <- "json"
        tt <- getForm(url, 
          .params = args,
          ...,
          curl = curl)
        numres <- fromJSON(I(tt))$response$numFound
        return(numres)
    }
    temp <- ldply(terms, search_)
    names(temp) <- "No_Articles"
    temp$Term <- terms
    temp$Term <- as.character(temp$Term)
      if (vis == "TRUE") {
        if(!require(ggplot2)) stop("must first install 'ggplot2' package.")
        p <- ggplot(temp, aes(x=Term, y=No_Articles)) + geom_bar()
      }
    return(list(table = temp, plot = p))
  }
}