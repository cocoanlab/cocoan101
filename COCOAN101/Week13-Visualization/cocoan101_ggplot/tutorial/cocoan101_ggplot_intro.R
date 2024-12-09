library(ggplot2)
library(R.matlab)
library(RColorBrewer)

# Pokemon dataset

datdir <- "/Users/ladakohoutova/Dropbox/cocoan101_ggplot/"

# Pokemon dataset
#datamat <- readMat(paste(datdir, "pokemon.mat", sep = ""))
data <- read.csv(paste(datdir, "pokemon.csv", sep = ""), skipNul = T, sep = ",")
data <- data[data$gen=="I",]


df <- data.frame(name = data$english_name, 
                 primary_type = data$primary_type, 
                 height = data$height_m, 
                 attack = data$attack)

# basics of ggplot()

(p <- ggplot(df, aes(x = primary_type, y = height))
        + geom_violin())


# violin plot
(p <- ggplot(df, aes(x = primary_type, y = height, fill = primary_type)) +
                geom_violin(trim = F, show.legend = F, draw_quantiles = 0.5))




# boxplot
(p <- ggplot(df, aes(x = primary_type, y = height, fill = primary_type)) +
                geom_boxplot(show.legend = F) +
                theme_classic())


# customise colours

#display.brewer.all()

cols <- c("#B56B79", "#5786C3", "#C34FA3", "#11574E", "#1B919F", 
          "#90B34F", "#5F6D66", "#437F80", "#666139", "#292613",
          "#666191", "#A6671D", "#982643", "#ADD3A3", "#9B574E")

(p <- ggplot(df, aes(x = primary_type, y = height, fill = primary_type)) +
                geom_boxplot(show.legend = F) + 
                scale_fill_manual(values=cols) +
                theme_classic())


# scatter plot
(p <- ggplot(df, aes(x = height, y = attack)) +
                geom_point(aes(colour=primary_type)) +
                scale_colour_manual(values = cols)+
                theme_minimal()+
                labs(title = "Pokemon height vs. attack", x="Pokemon height", y = "Attack"))



# add regression line
cor.test(df[df$primary_type=="electric",]$height, df[df$primary_type=="electric",]$attack)

(p <- ggplot(df[df$primary_type=="electric",], aes(x = height, y = attack)) +
                geom_point() +
                #scale_colour_manual(values = cols)+
                theme_minimal()+
                labs(title = "Pokemon height vs. attack", x="Pokemon height", y = "Attack") +
                geom_smooth(method = "lm"))





# histogram
pdf(paste(datdir, "figure.pdf", sep = ""), width = 3, height = 4.5)
(p <- ggplot(df, aes(x = attack)) +
                geom_histogram(bins = 50)+
                theme_classic())
dev.off()




# save figure