
FitGrowthCurve <- function(data, x, y){
    fit <- gam(data[,y]~s(data[, x]))
    fitted_values <- data.frame(x = data[,x], y = fit$fitted.values)
    r2value <- summary(fit)$r.sq
    return(list(fitted_values = fitted_values, rsq = r2value))
}

# keep only data with good spline fitting (R2>0.9)

data_cleaning <- function(planteye_data, property){

    dis_unit <- distinct(planteye_data, unit)
    n_dis_unit <- length(dis_unit)


    data_property <- planteye_data %>%
    dplyr::select(timestamp, property, unit, genotype) %>%
    mutate_(y = property)

    fitted_values_total <- rep(NA, 3)
    error_unit <- NA
    planteye_data_cleaned <- NULL
    n <- 0
    for (b in dis_unit$unit){
        print(b)
        data_property_unit <- data_property %>% filter(unit == b)
        #
        # outliers <-  dbscanOutlierDetect(data_property_unit, 60, log(nrow(data_property_unit)), FALSE)
        # table_outliers <- table(outliers)
        # n_max_cluster <- max(table_outliers)
        # max_cluster <- as.numeric(names(table_outliers))[table_outliers == n_max_cluster]
        #
        # if(n_max_cluster<dim(data_property_unit)[1]*3/4){
        #     error_unit <- c(error_unit, b)
        # }
        # else{
        #     n <- n+n_max_cluster
        #     data_property_unit_cleaned <- data_property_unit[outliers==max_cluster, ]
        #     planteye_data_cleaned <- rbind(planteye_data_cleaned, data_property_unit_cleaned)
        # }
        #
        data_property_unit$timestamp <- as.numeric(data_property_unit$timestamp - data_property_unit$timestamp[1])/3600
        fitted_values <- FitGrowthCurve(data_property_unit,
                                        "timestamp",
                                        property)

        rsq <- fitted_values$rsq
        if(rsq< 0.9){error_unit <- c(error_unit, b)}
        
    
    }


    error_unit <- error_unit[-1]
    planteye_data_cleaned <- filter(planteye_data, !(unit %in% error_unit))

    return(planteye_data_cleaned)

}

