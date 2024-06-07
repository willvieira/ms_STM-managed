# Figure to represent the effect size (in proportion to the managed state) of
# each management practice


library(tidyverse)

# load equilibrium proportion of states across the MAT gradient
dat_noCC <- readRDS('../ms_STM-managed/num-results//data//fig1//dat_noCC_0.RDS')
dat_rcp45 <- readRDS('../ms_STM-managed/num-results//data//fig1/dat_noManaged_4.5.RDS')

# link between management and state
practices <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')

mg_state <- tibble(
  manag = practices,
  state = c('R', 'B', 'B', 'M')
)

Alpha = 0.8
mgCols = c(
  rgb(11, 89, 105, maxColorValue = 255),
  rgb(249, 66, 37, maxColorValue = 255),
  rgb(144, 178, 67, maxColorValue = 255),
  rgb(253, 168, 48, maxColorValue = 255)
)


# summary table
dat_noCC |>
  select(contains('Eq'), env1a) |>
  bind_cols(sim = 'noCC') |>
  bind_rows(
    dat_rcp45 |>
      select(contains('Eq'), env1a) |>
      bind_cols(sim = 'rcp4.5')
  ) |>
  pivot_longer(
    cols = contains('Eq'),
    names_to = 'state'
  ) |>
  mutate(state = stringr::str_replace(state, 'Eq', '')) |>
  group_by(sim, state) |>
  reframe(total_prev = sum(value)) |>
  mutate(total_rel = round(total_prev/sum(total_prev)* 100, 1)) |>
  select(!total_prev) |>
  pivot_wider(
    names_from = sim,
    values_from = total_rel
  ) |>
  left_join(mg_state) |>
  mutate(
    legend_name = paste0(manag, ' - ', noCC, '%')
  ) ->
total_manag


# plot management proportion to state availability
dat_rcp45|>
  select(contains('Eq'), env1a) |> 
  pivot_longer(cols = contains('Eq')) |>
  mutate(
    state = stringr::str_replace(name, 'Eq', '')
  ) |>
  left_join(
    mg_state,
    relationship = 'many-to-many'
  ) |>
  drop_na() |>
  left_join(
    total_manag |>
      select(manag, state, legend_name)
  ) |>
  ggplot() +
  aes(env1a, value) +
  aes(color = legend_name) +  
  geom_line() +
  scale_color_manual(values = mgCols) +
  theme_classic() +
  labs(
    x = 'Mean annual temperature (°C)',
    y = 'Management intensity in total area (scaled)',
    color = NULL
  ) ->
p

print("Plot supplementary figure 5")  

ggsave(
    filename = 'manuscript/img/num-result_supp5.png',
    p,
    width = 7,
    height = 4.5
)

