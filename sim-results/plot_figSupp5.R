##############################################################
# Figure to test how filtering extreme occupancy proportions
# affects state shift
# Will Vieira
# Feb 2022
##############################################################


suppressPackageStartupMessages(library(tidyverse))
library(ggpubr)


print('Plot supplementary figure 5')


# Because the script run_calculateShift.R already filters extreme prop
# Here I rerun the script to generate state shift without filtering (line 237)
scrpt <- readLines('sim-results/run_calculateShift.R')
scrpt <- scrpt[-grep('prop < 0.93 & prop > 0.07', scrpt)]
source(textConnection(scrpt))



# vector of names, color, practice and simulations
managName <- c('noManaged', 'Plantation', 'Harvest', 'Thinning', 'Enrichment')
stateCols <- setNames(
    c(rgb(0, 0.54, 0.54), rgb(1, 0.647, 0)),
    c('B', 'T')
)



# State shift in function of occ_i (proportion)
p1 <- summ_dt %>%
    filter(RCP == 4.5) %>%
    filter(sim == 'T150+CC+FM') %>%
    mutate(
        state = as.factor(state),
        mg = factor(mg, levels = managName[c(5, 2, 3, 4, 1)])
    ) %>%
    ggplot(aes(y = prop, x = diff, color = state)) +
        geom_point(size = .7, alpha = .4) +
        scale_color_manual(values = stateCols) + 
        facet_grid(~mg) +
        geom_hline(
            yintercept = c(0.07, 0.93),
            linetype = "dashed", 
            size = 0.6,
            color = rgb(0.6, 0, 0, 0.8)
        ) + 
        ggpubr::theme_classic2() +
        theme(
            axis.text.x = element_blank()
        ) +
        labs(
            x = '',
            y = 'Occupancy'
        ) +
        xlim(-3.1, 2.6)


# Boxplot with
p2 <- summ_dt %>%
    filter(RCP == 4.5) %>%
    filter(sim == 'T150+CC+FM') %>%
    mutate(
        state = as.factor(state),
        mg = factor(mg, levels = managName[c(5, 2, 3, 4, 1)])
    ) %>%
    ggplot(aes(x = diff, fill = state, color = state)) +
        geom_boxplot(alpha = 0.4) +
        scale_color_manual(values = stateCols) +
        scale_fill_manual(values = stateCols) +
        facet_grid(~mg) +
        ggpubr::theme_classic2() +
        theme(
            strip.background = element_blank(),
            strip.text.x = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_text(color = 'white'),
            axis.ticks.y = element_blank(),
            plot.subtitle = element_text(size = 10)
        ) +
        labs(
            subtitle = 'No occupancy filter',
            x = '',
            y = ''
        ) +
        xlim(-3.1, 2.6)

p3 <- summ_dt %>%
    filter(RCP == 4.5) %>%
    filter(sim == 'T150+CC+FM') %>%
    mutate(
        state = as.factor(state),
        mg = factor(mg, levels = managName[c(5, 2, 3, 4, 1)])
    ) %>%
    filter(prop < 0.93 & prop > 0.07) %>%
    ggplot(aes(x = diff, fill = state, color = state)) +
        geom_boxplot(alpha = 0.4) +
        scale_color_manual(values = stateCols) +
        scale_fill_manual(values = stateCols) +
        facet_grid(~mg) +
        ggpubr::theme_classic2() +
        theme(
            strip.background = element_blank(),
            strip.text.x = element_blank(),
            axis.text.y = element_text(color = 'white'),
            axis.ticks.y = element_blank(),
            plot.subtitle = element_text(size = 10)
        ) +
        labs(
            subtitle = '0.07 < occupancy < 0.93',
            x = 'Range shift in annual mean temperature (°C)',
            y = ''
        ) +
        xlim(-3.1, 2.6)


ggsave(
    filename = 'manuscript/img/sim-result_supp5.png',
    ggpubr::ggarrange(
        p1, p2, p3,
        nrow = 3,
        heights = c(2, 1, 1.15),
        vjust = .5,
        common.legend = TRUE,
        legend = 'right'
    ),
    width = 9,
    height = 4.9
)
