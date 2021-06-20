library("tidyverse")
library("readxl")

############ IMPORT ############
raw <- read_xlsx("raw.xlsx", col_names = TRUE) # Columns:
    # Taxonomic Group
    # Increasing Populations
    # Stable
    # Decreasing Populations

avgdec <- 0.68  # Average overall population decline
############ TIDY ############
# group <- 


############ BAR PLOT ############
g <- ggplot(data = raw, mapping = aes(x = Group, y = Percent, fill = `Growth Type`)) +
    geom_col()

print(g)