#' Code time-to-event variable 
#' 
#' The function constructs a variable measuring the time to treatment
#' given a panel dataset with a time-varying treatment status indicator. 
#' 
#' @param unit unquoted variable name identifying the unit of the panel 
#' @param time unquoted variable name indicating the ordering of the observations 
#' @param treat unquoted variable name of the binary treatment status variable 
#' @param data data frame that includes the variables
#' @param baseline baseline or reference period for leads/lags
#' @param never coding for units for which never \code{treat=1} 
#' @param always coding for units for which always \code{treat=1} 
#' @param leads number of leads to include
#' @param lags number of lags to include
#' 
#' 
#' @details 
#' The output of this function is a factor variable. When passed to a 
#' standard fitting function, the factor variable is broken into 
#' dummies encoding leads and lags. 
#' 
#' Most fitting functions are using the first level of a factor variable as a reference category. 
#' This means that the first lead serves as the reference period. This can be changed 
#' by setting a value for the parameter \code{baseline}, e.g. -1 to use the last lead before the treatment as reference period. 
#' 
#' To exclude units that never receive treatment or that received treatment 
#' before the first period (i.e. for which the treatment status has no
#' variance), set the parameters \code{always} and \code{never}
#' to \code{NA}. The estimation sample is then limited to the  
#' switcher population.
#' 
#' To accumulate lags and leads set the parameters \code{leads} 
#' and \code{lags} to a value that is less than the maximum of 
#' feasible leads/lags. 
#'
#' 
#' @return 
#' A vector measuring time to event in the units of the panel dataset.   
#' 
#' @seealso 
#' \link[stats]{lm}
#' 
#' @examples 
#' library(dd)
#' 
#' data(goldendawn)
#' 
#' goldendawn$t <- code_eventtime(
#'        unit=muni,
#'        time=year,
#'        treat=post,
#'        data=goldendawn)
#' 
#' m <- lm(gd ~ t + factor(muni) + factor(year), data=goldendawn)
#' summary(m)
#' 
#' 
#' 
#' @export
code_eventtime <- function(
	unit, time, treat, data,
	baseline=NA, 
	never="min", 
	always="max", 
	leads=NA, 
	lags=NA){

	unit_ <- eval(substitute(unit), 
		envir=data, enclos=parent.frame() )
	time_ <- eval(substitute(time), 
		envir=data, enclos=parent.frame() )
	treat_ <- eval(substitute(treat), 
		envir=data, enclos=parent.frame() )

	check_01_vec(treat_,"treat")	

	# Generate treattime variable by unit
	treat_lst <- split(treat_, unit_)
	time_lst <- split(time_, unit_)

	l <- mapply( set_treattime_backend, 
		treat_lst, time_lst, SIMPLIFY=FALSE)
	out <- unsplit(l, unit_)

	# Code: Not yet switched 
	if(!is.na(never)){
		if(never=="min"){
			out <- ifelse(is.na(out) & treat_==0, min(out,na.rm=TRUE), out)
		} else {
			out <- ifelse(is.na(out) & treat_==0, never, out) 
		}
	} 
	
	if(!is.na(always)){
		if(always=="max"){
			out <- ifelse(is.na(out) & treat_==1, max(out,na.rm=TRUE), out)
		} else {
			out <- ifelse(is.na(out) & treat_==1, always, out) 
		}
	} 

	# Code: lags/leads
	if(!is.na(leads)){
		leads <- leads * (-1)
		out <- ifelse(out<leads, leads, out)
	} 
	if(!is.na(lags)){
		out <- ifelse(out>lags, lags, out)
	} 

	# Set baseline 
	if(!is.na(baseline)){
		if(!(baseline %in% out)) {
			out_min <- min(out)
			out_max <- max(out)
			stop(paste0(
				"Value for 'baseline' has to be between ",
				out_min, " and ", out_max, "."))
		}
		out <- factor(out)
		out <- relevel(out, as.character(baseline))
	} else {
		out <- factor(out)
	}

	return(out)
	}

set_treattime_backend <- function(treat,time){
	if( sum(is.na(time))>0 ) stop("'time' may not include missing values.")
	if( sum(is.na(treat))>0 ) warnings("'treat' includes missing values.")
	time_order <- order(time)
	time <- time[time_order]
	treat <- treat[time_order]
	ctreat <- cumsum(treat)
	treat1st <- time[ctreat==1 & time!=min(time)]
	if( length(treat1st)==0 ){
		if (class(time)=="Date"){
			treat1st <- as.Date(NA)
		} else {
			treat1st <- NA
		}
	}
	out <- time-treat1st
	return(as.vector(out))
	}

check_01_vec <- function(x, label){
	if(!is.numeric(x)) stop(paste(label, "has to be numeric."))
	if( sum(x %in% c(0,1,NA))!=length(x) ) stop(paste(label, "can only contain values c(0,1,NA)."))
	}	

