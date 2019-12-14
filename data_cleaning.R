# R square function
rsquare <- function(x, y) {
    rsquare <- 1 - sum((x - y)^2) / sum((y - mean(y))^2)
    return(rsquare)
}

data_cleaning <- function(planteye_data, property) {
    dis_unit <- distinct(planteye_data, unit)
    data_property <- planteye_data %>%
    dplyr::select(timestamp, property, unit, genotype) %>%
    mutate_(y = property)

    fitted_values_total <- rep(NA, 3)
    error_unit <- NA
    planteye_data_cleaned <- NULL
    for (b in dis_unit$unit) {
        print(b)
        data_property_unit <- data_property %>% filter(unit == b)
        result_lm <- lm(Height~ timestamp, data = data_property_unit)
        resid_lm <- residuals(result_lm)
        median_resid <- (abs(resid_lm) - median(resid_lm)) / mad(resid_lm)
        # only keep points with standardized mad less than 2.5
        data_property_unit <- data_property_unit[median_resid < 2.5, ]
        # keep unit with more than 30 data points
        if (dim(data_property_unit)[1] > 30) {
            result_grofit <- gcFitModel(data_property_unit$timestamp, data_property_unit$Height)
            if (! result_grofit$fitFlag) {
                error_unit <- c(error_unit, b)
            }
            # keep units with larger than 0.3 R^2 of growth model fitting
            else if (rsquare(result_grofit$fit.data, result_grofit$raw.data) < 0.3) {
                error_unit <- c(error_unit, b)
            } else {
                planteye_data_cleaned <- rbind(planteye_data_cleaned, data_property_unit)
            }
        }
        else {
            error_unit <- c(error_unit, b)
        }
    }
    error_unit <- error_unit[-1]
    return(planteye_data_cleaned)
}
