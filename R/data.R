#' Golden Dawn Vote Share Data
#'
#' This data comes from Dinas, Matakos, Xefteris and Hangartner (2019) 
#' who show that the exposure to the European refugee protection crisis in 2015/2016
#' increased support for the Golden Dawn, a radical right party in Greece. 
#' 
#' 
#' @format A data frame with 380 rows and 4 variables:
#' \describe{
#'   \item{muni}{Municipality ID}
#'   \item{year}{Year of election}
#' 	 \item{post}{Post exposure?}
#'   \item{gd}{Vote share of Golden Dawn Party (in %)}
#' }
#' 
#' @references
#' Dinas Elias and Konstantinos Matakos, Dimitrios Xefteris, and Dominik Hangartner. 2019. "Waking up the Golden Dawn: Does Exposure to the Refugee Crisis Increase Support for Extreme-right Parties?" \emph{Political Analysis}, 27(2), 244–254.
#' 
"goldendawn"


#' Stevenson-Wolfers Divorce Data
#'
#' This data comes from Stevenson and Wolfers (2006) who
#' study how no-fault unilateral divorce reforms affect female 
#' suicide in the United States. The data here are taken from 
#' the documentation of the Stata ado BACONDECOMP.
#' 
#'
#' @format A data frame with 1617 rows and 7 variables:
#' \describe{
#'   \item{stfips}{US State (FIPS Code)}
#'   \item{year}{Calendar Year}
#' 	 \item{post}{Post reform?}
#'   \item{asmrs}{Suicide rate among women}
#' 	 \item{pcinc}{Per capita income}
#' 	 \item{asmrh}{Homicide mortality rate}
#' 	 \item{cases}{Aid to Families with Dependent Children (AFDC) rate (for a family of four)}
#' }
#' 
#' @references
#' 
#' Stevenson, Betsey and Justin Wolfers. 2006. "Bargaining in the Shadow of the Law: Divorce Laws and Family Distress." \emph{The Quarterly Journal of Economics}, 121(1), 267-288.
#' 
#' Goodman-Bacon, Andrew and Thomas Goldring and Austin Nichols. 2019. "BACONDECOMP: Stata Module to Perform a Bacon Decomposition of Difference-in-differences Estimation." Statistical Software Components S458676, Boston College Department of Economics, revised 15 Sep 2019.
#' 
"divorce"