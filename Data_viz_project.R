#==DATA VISUALIZATION PROJECT===#
setwd("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Capstone and Data Viz Projects\\Data Visualization Project")

library(ggplot2)

#Load dataset
df <- read.csv("Economist_Assignment_Data.csv")
#Drop spurious column X
df$X <- NULL

df

head(df)

pointsToLabel <- c("Russia", "Venezuela", "Iraq", "Myanmar", "Sudan",
                   "Afghanistan", "Congo", "Greece", "Argentina", "Brazil",
                   "India", "Italy", "China", "South Africa", "Spane",
                   "Botswana", "Cape Verde", "Bhutan", "Rwanda", "France",
                   "United States", "Germany", "Britain", "Barbados", "Norway", "Japan",
                   "New Zealand", "Singapore")

plot <- ggplot(data=df, aes(x=CPI, y=HDI, colour=Region)) + 
        geom_point() + #generate scaterplot
        geom_smooth(colour="Red", 
                    method="lm", 
                    formula="y~log(x)", se=F) +  #create trendline
        geom_text(data=subset(df, Country %in% pointsToLabel), 
                  check_overlap=T, 
                  aes(label=Country), 
                  colour="Black") +
        scale_x_discrete(name="Corruption Index",limits=seq(1,10,1), breaks=1:10) +
        scale_y_discrete(name="Human Development Index", limits=seq(0.2,1,0.1))
        
      

plot  
