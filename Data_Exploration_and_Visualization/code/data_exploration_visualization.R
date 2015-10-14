# Script for following along in Data Exploration and Visualization module
# Copy-paste line by line or use the "Run" button in R Studio
library(lattice)

data(iris)
head(iris)

# Formula Data type
f.1 <- Species ~ .
f.2 <- ~ Species + Petal.Width
f.3 <- ~ Petal.Length | Species

class(f.1)

# Core boxplot
boxplot(Sepal.Length ~ Species, data=iris, 
    main="Sepal Length for Various Species", xlab="Species", ylab="Sepal Length"
)

boxplot(Sepal.Length ~ Species, data=iris, 
    main="Sepal Length for Various Species", xlab="Species", ylab="Sepal Length", 
    notch=TRUE
)

boxplot(Sepal.Length ~ Species, data=iris, 
    main="Sepal Length for Various Species", xlab="Species",  ylab="Sepal Length", 
    notch=TRUE, col=c("blue","green","red")
)

# Saving Plots. Can also use the "Plot" window in R Studio
# Saves to current working directory (getwd()) by default
pdf("myplot.pdf")

boxplot(Sepal.Length ~ Species, data=iris, 
    main="Sepal Length for Various Species", xlab= "Species", ylab="Sepal Length", 
    notch=TRUE, col=c("blue","green","red")
)

dev.off() # Returns plot to the IDE

# Lattice Histogram & Density
histogram(iris$Petal.Length, breaks=10, type="count", main="Histogram")

densityplot(iris$Sepal.Width, main="Kernel Density of Petal Width", 
    type="percent", n=150
)


densityplot(~ Petal.Width, data=iris, groups=Species, plot.points=F, 
    xlab=list(label="Kernel Density of Petal Width", fontsize=20), ylab="", 
    main=list(label="Density of Petal Width by Species", fontsize=24), 
    auto.key=list(corner=c(0,0), x=0.4, y=0.8, cex=2), scales=list(cex=1.5)
) # cex defines a scale multiplier for text

# Exercise 1:
# Make a 2-D scatter plot of Sepal Length vs Sepal Width and 
# Petal Length vs Petal Width using core. Then recreate the same graphs in 
# lattice, this time coloring the individual points by species.

# Extended scatter plots
plot(Petal.Length ~ Petal.Width, data=iris, main="Petal Width vs Length")

abline(lm(Petal.Length ~ Petal.Width, data=iris), col="red", lwd=2)

# Scatter plot matrix
pairs(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data=iris, 
    main="Simple Scatter Matrix"
)

# Getting settings for legend
super.sym <- trellis.par.get("superpose.symbol")

splom(iris[1:4], groups=iris$Species, panel=panel.superpose,
    key=list(title="Three Flower Types", columns=3, 
        points=list(pch=super.sym$pch[1:3],  col=super.sym$col[1:3]),
        text=list(c("Setosa","Versicolor","Verginica"))
    )
)

library(GGally)
ggpairs(iris, color="Species")

# Exercise 2:
# Load the mtcars dataset. If the goal is to predict the MPG column based on the
# other columns, create 2 different plots which illustrate useful relationships
# in the data.

## ggplot2 introduction ##
library(ggplot2)

data(diamonds)
head(diamonds)

# Basic plot types
ggplot(diamonds, aes(x=carat)) + geom_histogram()

ggplot(diamonds) + geom_density(aes(x=carat), fill="gray50")

ggplot(diamonds, aes(x=carat, y=price)) + geom_point()

# ggplot object
# Store the plot for future modification
g <- ggplot(diamonds, aes(x=carat, y=price))

# Second aesthetic adds settings specific to geom_point layer
g + geom_point(aes(color=color))

# Segment by factor
g + geom_point(aes(color=color)) + facet_wrap(~ color)

g + geom_point(aes(color=color)) + facet_wrap(cut ~ clarity)

## Extended Titanic Exploration ##

# Set your working directory to the bootcamp root folder using setwd()
# or this line won't work
titanic <- read.csv("Datasets/titanic.csv")
head(titanic)

str(titanic)

# Casting & Readability
titanic$Survived <- as.factor(titanic$Survived)
levels(titanic$Survived) <- c("Dead", "Survived")
levels(titanic$Embarked) <- c("Unknown", "Cherbourg",
                              "Queenstown", "Southampton")
str(titanic[,c("Embarked","Survived")])

# Pie chart
survivedTable <- table(titanic$Survived)
par(mar=c(0, 0, 0, 0), oma=c(0, 0, 0, 0), cex=1.5)
pie(survivedTable, labels=c("Dead", "Survived"))

# Is Sex a good predictor?
male <- titanic[titanic$Sex=="male",]
female <- titanic[titanic$Sex=="female",]
par(mfrow=c(1, 2))
pie(table(male$Survived), labels=c("Dead", "Survived"), 
    main="Survival Portion of Men"
)
pie(table(female$Survive), labels=c("Dead", "Survived"),
    main="Survival Portion of Women"
)

# Is Age a good predictor?
summary(titanic$Age)

summary(titanic[titanic$Survived=="Dead",]$Age)
summary(titanic[titanic$Survived=="Survived",]$Age)

# Exercise 3:
# Create 2 box plots of Age, one segmented by Sex, the other by Survived
# Create a histogram of Age
# Create 2 density plot of Age, also segmented by Sex and Survived

# Exercise 4:
# Create a new column "Child", and assign each row either "Adult" or "Child"
# based on a consistent metric. Then use ggplot to create a series of box plots
# relating Fare, Child, Sex, and Survived