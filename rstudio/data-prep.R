library(foreach)
library(iterators)
library(parallel)
library(doParallel)
library(plyr)
library(dplyr)
library(tidyr)
library(Matrix)
library(lubridate)
library(ggplot2)
library(viridis)
library(broom)
library(xgboost)
library(randomForest)
library(caret)
library(caretEnsemble)

registerDoParallel(6, cores = 6)
getDoParWorkers()

setwd('/Users/Dino/Projects/nba-stats/rstudio')
raw.df <- read.csv(file.path('data', 'sc.csv'))

prep.df <- raw.df %>%
  mutate(GRID_TYPE = NULL, PLAYER_ID = NULL, PLAYER_NAME = NULL,
         SHOT_ATTEMPTED_FLAG = NULL, TEAM_ID = NULL, TEAM_NAME = NULL)

plot.df <- prep.df %>%
  select(LOC_X, LOC_Y, EVENT_TYPE)

p <- ggplot(data = plot.df, mapping = aes(
  x = LOC_X, y = LOC_Y, group = EVENT_TYPE))
p <- p + geom_point(size = 2, alpha = .55, aes(colour = EVENT_TYPE)) +
  scale_color_viridis(discrete = TRUE)
p

r.df <- prep.df %>%
  select(SHOT_DISTANCE, EVENT_TYPE)

rg.df <- r.df %>%
  mutate(MADE = as.numeric(EVENT_TYPE)) %>%
  mutate(EVENT_TYPE = NULL) %>%
  mutate(MADE = (MADE - 2) * (-1))

glm2 <- glm(MADE ~ SHOT_DISTANCE,
            family = binomial(), data = rg.df)

glm.df <- plot.df %>%
  mutate(MADE = as.numeric(EVENT_TYPE)) %>%
  mutate(EVENT_TYPE = NULL) %>%
  mutate(MADE = (MADE - 2) * (-1))

glm1 <- glm(MADE ~ LOC_X + LOC_Y,
            family = binomial(), data = glm.df)

