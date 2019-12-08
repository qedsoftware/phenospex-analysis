
# estimate generalized additive model (gam) from mgcv library

PredictGrowthCurve <- function(data_property_unit, x, y, startx, endx){
    data_fit <- data.frame(x=data_property_unit[, x], y = data_property_unit[, y])
    fit <- gam(y~s(x), data=data_fit)
    predictx <- seq(startx, endx, by=8)
    predict_values <- data.frame(x=predictx, y= predict(fit, data.frame(x=predictx)))
    return(predict_values)
}

GetPhenospexAUC <- function(planteye_data, property, mintime, maxtime){

    dis_unit <- distinct(planteye_data, unit)
    n_dis_unit <- length(dis_unit)
    auc_temp <- rep(NA, n_dis_unit)
    genotype <- rep(NA, n_dis_unit)

    data_property <- planteye_data %>% 
            dplyr::select(timestamp, property, unit, genotype) %>% 
            mutate_(y = property)

    i <- 1

    for (b in dis_unit$unit){
        data_property_unit <- data_property %>% filter(unit == b)
        
        # align the prediction range for all the units
        startx <- (mintime - as.numeric(data_property_unit$timestamp[1]))/3600
        endx <- (maxtime - as.numeric(data_property_unit$timestamp[1]))/3600
        data_property_unit$timestamp <- as.numeric(data_property_unit$timestamp - data_property_unit$timestamp[1])/3600
        
        predict_values <- PredictGrowthCurve(data_property_unit,
                                        "timestamp",
                                        property,
                                        startx,
                                        endx)
        
        lentime <- (maxtime - mintime)/3600
        auc_temp[i] <- auc(predict_values$x, predict_values$y) - lentime*predict_values$y[1] 
        genotype[i] <- as.character(data_property_unit$genotype[1])
        i <- i + 1
    
    }
    auc_data <- data.frame(unit=dis_unit, auc = auc_temp, genotype)
    return(auc_data)
    
    }

PhenospexANOVA <- function(auc_data, properties){
    n_dis_prop <- length(properties)
    mse_results <- rep(NA, n_dis_prop)
    pvalues_results <- rep(NA, n_dis_prop)
    k <- 1
    for (property in properties){
        aov_genotype <- aov(auc_data[, property] ~ auc_data$genotype)
        aov_results <- summary(aov_genotype)[[1]]
        mse_results[k] <- aov_results[2, 3]
        pvalues_results[k] <- aov_results[1, 5]
        k <- k + 1
    }

    write.csv(data.frame(properties = properties,
                         mse_results = mse_results,
                         pvalues_results = pvalues_results),
              "auc_anova_results.csv", row.names = FALSE)
}

