#' Tidy lead/lag coefficients to data frame
#' 
#' @param model fitted model object
#' @param varname quoted (partial) name of the time-to-event variable 
#' @param baseline optional reference period to add (see details)
#' @param ... further parameters passed to \code{tidy()}, e.g. \code{conf.int=TRUE}
#' 
#' 
#' @details 
#' The function extracts the coefficients using \code{\link[broom]{tidy}} and 
#' then subsets to the relevant coefficients based on \code{varname}.
#' 
#' The parameter \code{baseline} allows to add an estimate 
#' with value zero and with a confidence interval of length zero to 
#' visually highlight the reference period for the leads and lags.
#' 
#' All additional arguments are passed further to 
#' \code{\link[broom]{tidy}}. This can be a global argument 
#' (e.g., \code{conf.int=TRUE}) or extractor-specific
#' argument (e.g., \code{se.type='robust'}) when 
#' using \code{\link[lfe]{felm}} for fitting (see \code{\link[broom]{tidy.felm}}). 
#' 
#' 
#' @return 
#' A subset of the data frame as returned by \code{\link[broom]{tidy}} 
#' with the estimates for the leads and lags and a variable \code{eventtime}.
#' 
#' @seealso 
#' \code{\link[broom]{tidy}}
#' 
#' @examples 
#' library(dd)
#' 
#' data(goldendawn)
#' 
#' goldendawn$ttime <- code_eventtime(
#'        unit=muni,
#'        time=year,
#'        treat=post,
#'        data=goldendawn)
#' 
#' m <- lm(gd ~ ttime + factor(muni) + factor(year), data=goldendawn)
#' summary(m)
#' 
#' toplot <- tidy_eventcoef(m, varname='ttime', conf.int=TRUE)
#' 
#' with(toplot, plot(eventtime,estimate, pch=20, ylim=c(-2,3)))
#' with(toplot, segments(eventtime,conf.low, eventtime, conf.high))
#' 
#' 
#'@importFrom broom tidy
#'@export 
tidy_eventcoef <- function(model, varname, 
		baseline=NA, ...){
	mod <- tidy(model, ...)
	mod <- as.data.frame(mod)
	mod <- mod[grep(varname, mod[['term']],fixed=TRUE),]
	mod[['eventtime']] <- gsub(varname, "", mod[['term']], fixed=TRUE) 
	mod[['eventtime']] <- as.numeric(mod[['eventtime']])
	if(!is.na(baseline)){
		if(baseline %in% mod[['eventtime']]){
			stop(paste0(
				"There is an estimate at baseline (baseline=", baseline,")."))
		}
		N1 <- nrow(mod)+1
		mod <- mod[c(1:N1),]
		mod[N1,] <- 0
		mod[N1,'eventtime'] <- baseline
	}
	return(mod)
	}

