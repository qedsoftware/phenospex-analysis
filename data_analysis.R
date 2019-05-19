library(dplyr)
library(MESS)

FITSmoothSpline <- function(data, x, y){
    fit2 <- smooth.spline(data[,x], data[, y], cv = TRUE)
     # fitted values
    fitted_values <- predict(fit2, data[, x])
    fitted_values <- data.frame(x= fitted_values$x, y = fitted_values$y)
    return(fitted_values)
}

PhenospexAUC <- function(datafile, time_cutoff = NA, properties){
    planteye_data <- read.csv(datafile)
    planteye_data <- arrange(planteye_data, species, block, time)
    
    # filter out data points passing the time_cutoff
    if(!is.na(time_cutoff)){
        planteye_data <- filter(planteye_data, time <= time_cutoff)
    }

    n_dis_prop <- length(properties)
    dis_block <- distinct(planteye_data, block)
    n_dis_block <- length(dis_block)

    k <- 1
    auc_data <- data.frame(block=planteye_data$block)
    
    for(property in properties) {
        auc_temp <- rep(NA, n_dis_block)
        data_property <- planteye_data %>% 
                            select(time, property, block, species) %>%
                            mutate_(y = property)

        i <- 1
        fitted_values_total <- rep(NA, 3)
        for(b in dis_block$block){
            data_property_block <- data_property %>% filter(block == b) 
            
            fitted_values <- FITSmoothSpline(data_property_block, "time", property)
            fitted_values_total <- rbind(fitted_values_total, data.frame(data_property_block$species, fitted_values))

            auc_temp[i] <- auc(fitted_values$x, fitted_values$y)
            i <- i+1
        }
        auc_data <- cbind(auc_data, index = auc_temp)
        
        k <- k+1
        names(auc_data)[k] <- property
        
        fitted_values_total <- fitted_values_total[-1, ]
        names(fitted_values_total)[1] <- "species"

        fitted_mean <- fitted_values_total %>% group_by(x, species) %>% summarise(y = mean(y, na.rm=TRUE))
        data_property <- mutate(data_property, fitted = y)
        
        pdf(paste("plot", "_", property, ".pdf", sep=""))
        g <- ggplot(data_property, aes(time, y)) + geom_point() + geom_line(data=fitted_mean, aes(x, y, color=species))
        print(g)
        dev.off()
    }

    auc_data$species <- fitted_values_total$species

    # anova test on the auc values of different species

    mse_results <- rep(NA, n_dis_prop)
    pvalues_results <- rep(NA, n_dis_prop)
    k <- 1
    for(property in properties){
      aov_specis <- aov(auc_data[, property] ~ auc_data$species)
      aov_results <- summary(aov_specis)[[1]]
      mse_results[k] <- aov_results[2, 3]
      pvalues_results[k] <- aov_results[1, 5]
      k <- k+1
    }

    write.csv(data.frame(properties= properties, mse_results=mse_results, pvalues_results= pvalues_results), "auc_anova_results.csv", row.names=FALSE)
}
