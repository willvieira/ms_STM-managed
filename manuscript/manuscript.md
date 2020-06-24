# Introduction

There is a growing concern in how tree species will respond to climate change, and how fast they can migrate to keep pace with warming temperature.
Correlative statistical models have projected large range shifts following warming temperature, such as the migration of plant species hundreds of kilometers northward by the end of this century [@Malcolm2002; @Mckenney2007].
While it is true that the range of short-lived mobile species may keep pace with climate change [@Chen2011], the range of long-lived tree species generally does not [@Harsch2009; @Zhu2012].
In fact, trees of eastern North America have shifted their range limits at less than 50% of the pace required to keep up with warming temperature [@Sittaro2017].
This mismatch between climate conditions and forest community composition leads us to anticipate maladaptation of trees to their environment, and therefore a possible loss of future forest productivity [@Aitken2008].
Quantifying the mechanisms determining species range limits is, therefore, critical for formulating adaptive management strategies [@Becknell2015].

Range limits of forest trees is driven by colonization and extinction dynamics [@Levins1969; @Hanski1998; @Holt2000].
The metapopulation theory predicts the boundary of a species’ range occurs where the colonization rate equals the extinction rate, wherever habitat is available [@Holt2000].
Assuming that colonization and extinction rates depend on temperature, then we expect range limits to change with climate warming.
However, colonization and extinction rates depend on many processes other than climate such as dispersal ability, establishment of propagules, survival and growth until maturity [@Jackson2010; @Schurr2012].
Colonization and extinction rates also depend on each species’ life-history traits as well as on the nature and recurrence of forest disturbances [@Butterfield2019; @Schurr2012].
Changes in any of these factors are likely to lead to colonization credit for some species whereby suitable habitat is left unoccupied [@Jackson2010; @Cristofoli2010], or to extinction debt whereby populations persist in unsuitable habitats [@Kuussaari2009; @Tilman1994a].
Accordingly, because of their slow demographic rates, eastern North American trees will have delayed range shifts due to extinction debt at the trailing edge of their range and colonization credit at the leading edge [@Talluto2017].

Forest management provides an opportunity to reduce colonization credit and extinction debt and, therefore, accelerate range shift to help trees keep pace with climate warming.
Although some management practices, such as assisted migration [@Peters1985a], have been proposed as a potential tool towards this end [*e.g.* @Gray2011], there has been extensive debate about its effectiveness with no definite conclusion [*e.g.* @McLachlan2007; @Vila2010; @Ricciardi2009; @Schwartz2009].
The truth is, temperature is warming and there is an increased need to consider the future environmental conditions in the adaption of forest management practices [@Keenan2015; @Ameztegui2018].
Reduce colonization credit and extinction debt to accelerate tree range shifts can be obtained through different management approaches involving different ecological processes.
For instance, large-scale harvesting may reduce extinction debt by removing maladapted individuals at the trailing edge, and also reduce colonization credit by reducing competitive interactions at the leading edge [@Leithead2010; @Steenberg2013; @Brice2020].
Similarly, stand thinning could improve the competitive ability of certain tree species that thrive in forest gaps.
Yet another management option would be the planting of novel species or genotypes in open areas, or enrichment planting in mature stands, which could favor the desired successional pathways. 
These examples show how we can use ecological knowledge to adapt management practices to reduce colonization credit and extinction debt.

In this study, our main objective was to assess how forest management can accelerate the response of the boreal-temperate ecotone to warming temperature by reducing colonization credit and extinction debt.
We first established a general modelling framework based on the metapopulation theory, to determine how different management practices affect the processes driving range dynamics.
We then assessed the effectiveness of these practices to move and maintain species in their optimal climate envelopes, using comparative simulations.
Our empirical model accounts for colonization and extinction dynamics, along with competitive exclusion and invasion processes, to predict how the boreal-temperate ecotone responds to climate warming [@Vissault2020].
Our model was initially calibrated with data from over 40,000 plots from eastern North America and integrates the effect of plantation, enrichment planting, harvest and thinning on the colonization and extinction dynamics of temperate deciduous and boreal conifer stands.

We tested the effectiveness of the four management practices by quantifying both the short-term and the long-term dynamics after climate warming (Figure @fig:concept).
The short-term and long-term response of different tree species to disturbance may differ, yet most ecological studies focus only on the long-term response.
The short-term response (or transient dynamics) is defined here as the period a forest stand at equilibrium takes to reach a new equilibrium after a disturbance [@Hastings2004].
Characterizing short-term dynamics along with the long-term equilibrium is crucial when planning adaptive forest management strategies, given the slow response of forest ecosystems to environmental changes [@Hastings2004; @Svenning2013; @Ezard2010].
More specifically, we first analyzed how each of our selected management practices affects the resilience, state change, and time to reach the novel equilibrium, using five metrics of transient dynamics in a spatially implicit version of the model.
Finally for the long-term response, we developed a spatially explicit version of the model, to consider the dispersal limitations of trees and stochastic events.
Specifically, we quantified how each of the management practices accelerates the northward range shift of the boreal-temperate ecotone in a landscape grid.
These analyses might guide future empirical studies by revealing the potential effect of forest management in accelerating the response of forest to climate warming and thus contribute to the advancement of adaptive management practices.

![Conceptual schema of the two approaches used to test the effect of forest management on the response of forest to warming temperature. (a) Redrawn from @Boulangeat2018. The spatially implicit version of the model to test the effect of forest management on the short-term dynamics after warming temperature. Given a patch (e.g. in the figure mainly composed of boreal species) at equilibrium with climate conditions, the warming temperature will shift the state proportion to a new equilibrium, and the response of the system to this perturbation can be characterized by five metrics: initial resilience ($-R_0$), asymptotic resilience ($R_{\infty}$), exposure ($\Delta_{state}$), sensitivity ($\Delta_{time}$) and  cumulative amount of changes ($\int S(t)dt$). (b) The spatially explicit version of the model accounting for limited dispersal of trees and stochastic dynamics. The bars limit the trailing edge of boreal and the leading edge of temperate states. Warming temperature drives a temperate range shift, but not for the boreal trailing edge [red arrows @Vissault2020]. We use this approach to test the effect of forest management to accelerate the northward range shift of the boreal-temperate ecotone following warming temperature.](manuscript/img/concept.png){#fig:concept}

# Methods

## Modelling forest range limits and management practices

A classical model to study spatial dynamics at the regional spatial scale comes from Levins' metapopulation theory [@Levins1969].
The theory is particularly suitable to describe the mosaic of forest successional stages in a landscape constantly changing because of small and large natural disturbances.
The model describes metapopulation as a set of patches that are either occupied or empty and connected by dispersal.
The dynamics of the metapopulation is given by individuals arriving and establishing in empty patches through the process of colonization ($\alpha$), and occupied patches becoming empty through the process of extinction ($\varepsilon$):

$$
\frac{dp}{dt} = \alpha(1 - p) - \varepsilon p
$$

Where $p$ is the proportion of occupied patches.
We can further extend this model to incorporate the environmental gradient by turning the demographic parameters ($\alpha$ and $\varepsilon$) into functions of climate conditions.
As a result, we can derive range limits as the set of environmental conditions where the extinction rate equals the colonization rate [@Holt2005].
Relaxing the assumption of one single species dynamics, we can consider multiple species competing for the same patches by having both demographic parameters varying as a function of species interactions [@Gravel2020].
This theoretical framework in a spatially explicit landscape grid, allows us to account for both the long-life cycle and slow migration rates of trees, along with species interaction, to predict the response of trees to climate warming.

We used a State and Transition Model derived from this theory and parameterized for eastern North American forests [@Vissault2020].
This approach models the dynamics of three discrete forest compositions along a gradient of temperature: (B)oreal, (T)emperate, and (M)ixed forest states; and the (R)egeneration (or empty) state.
Further than the colonization ($\alpha$) and extinction ($\varepsilon$) processes driving the transitions between empty (R) and occupied (by either B, M or T) patches, the model describes species interaction through the mechanisms of succession and competitive exclusion.
On one hand, succession ($\beta$) happens when either an occupied patch of pure boreal or temperate is colonized by species from the opposite composition, becoming then a mixed state.
On the other hand, competitive exclusion ($\theta$) drives the transitions from mixed patches to either pure boreal or temperate, depending on the competitive ability of each of the pure states.

![Schema of the State and Transition Model [@Vissault2020] with integrated forest management practices. Directional arrows describe the possible transitions between the four forest states: (R)egeneration, (B)oreal, (T)emperate, and (M)ixed. For each arrow, equations represent how the transition between states is calculated, with parameters changing as a function of mean annual temperature and precipitation. In red are the parts of the equation describing the natural dynamics, which are reduced when the respective management practice is applied. The values of each of the 9 parameters are shown in supplementary figure 4.](manuscript/img/model_equation_fm.png){#fig:model}

The functions describing transitions among states were evaluated using over 40,000 plots from the eastern North American forest inventory database, located between 57$^{\circ}$W to 96$^{\circ}$W and 35$^{\circ}$N to 52$^{\circ}$N [@Vissault2020].
Time was discretized because of the seasonality of forest dynamics and the nature of forest inventory data.
This time-discrete Markov Chain approach is dynamic as each parameter is calculated based on previous environmental conditions (annual mean temperature and annual precipitation) only, and the transitions are dependent on the neighborhood proportion (Figure @fig:model).
For each plot (measured between 1960 and 2010) and each measure (standardized to a 5 year interval via rescaling), the forest states (B, M, and T) were classified following its species composition.
A stand was classified as T whenever one of the following 7 species was present and none of the boreal species: *Prunus serotina*, *Acer rubrum*, *Acer saccharum*, *Fraxinus americana*, *Fraxinus nigra*, *Fagus grandifolia*, *Ostrya virginiana*, and *Tilia americana*; alternatively, a stand was classified as B whenever one of the following 8 species was present and none of the temperate species: *Picea mariana*, *Picea glauca*, *Picea rubens*, *Larix laricina*, *Pinus banksiana*, *Abies balsamea*, *Thuja occidentalis*.
The stand was classified as mixed when both boreal and temperate species were present.
The regeneration plot was classified when the basal area was inferior to 5m$^2$ ha$^{-1}$, irrespective of the composition.
Transition probabilities (scaled to respect the same time interval to all plots) were estimated by maximum likelihood.
Importantly, the use of extensive forest inventory data to calibrate the parameters allowed the model to predict with good confidence the distribution of the boreal, mixed and temperate states using current environmental data.

## Adapted forest management: reducing the gap between potential and actual forest distribution

It is expected with warming temperature that the distribution of the boreal-temperate ecotone will shift northward, however, due to slow demographic rates and limited dispersal of forest trees, these forest compositions may lag behind climate change [@Talluto2017; @Vissault2020].
Here we define how four management practices may reduce this gap between potential and realized forest distribution after warming temperature.
The four management practices implemented in the model are plantation and enrichment planting to potentially reduce colonization credit, and harvest and thinning to potentially reduce extinction debt.
The rationale of these management practices is to favor the spread of the temperate forest when the climate context allows temperate tree regeneration, and to reduce maladaptation of boreal forest when temperate trees should dominate.
The following sections detail the ecological assumptions and mathematical formulation for each practice implemented in the model.

### Managing to reduce colonization credit

Colonization of temperate species beyond the leading edge of their distribution may depend on many factors such as climate conditions, competitive ability, and seed sources.
The first factor limiting the colonization of a population beyond its range is the environmental conditions.
Once the environmental limitation is relaxed with warming temperature, species interactions such as competition for light may limit the development of regenerating individuals [e.g. @Bianchi2018].
Finally, seed source is a density-dependent process which, associated with the slow migration rate of trees, contributes to the lack of colonization beyond the population range limits.
In the context of managing ecological processes, some of these factors can be modified with forest management.
Here we choose two management practices that may operate at different spatial scales to simulate density-independent colonization: plantation (i.e. assisted migration) at the large spatial scale, and enrichment planting at the local spatial scale.
Enrichment planting, contrary to plantation relate to the plantation of tree in a mature stand, which enrich it in the type of the planted species.
Following warming temperature, plantation and enrichment planting of temperate species should overcome dispersal limitation and the lack of seed sources and may increase the northward range shift of the temperate-mixed regions by colonizing stands beyond the current distribution.

#### Plantation of temperate stands

In our model, colonization of regeneration stands by either boreal, mixed or temperate depends on the capacity of boreal and temperate species to establish ($\alpha_B$ and $\alpha_T$), and their proportion in the neighboring stands.
The plantation practice is modelled as an increase in the probability of regeneration stands to become temperate $P(T|R)$.
A proportion $p$ of available regeneration stands are directly converted each time step into the temperate forest.
Only the remaining regeneration stands ($1-p$) follow natural succession.
Plantation thus involves an additional parameter $p$ that modifies the following probabilities:

$$
\begin{aligned}
  P(T|R) &= [\alpha_T (T+M) \times (1-\alpha_B (B+M))] \times (1 - p) +  p \\
  P(B|R) &= [\alpha_B (B+M) \times (1-\alpha_T (T+M))] \times (1 - p) \\
  P(M|R) &= [\alpha_T (T+M) \times \alpha_B (B+M)] \times (1 - p)
\end{aligned}
$$

where $p$ is the proportion of R stands that are planted per time step.
Note that when $p=0$, the natural dynamics occurs and when $p=1$, $P(T|R)=1$,  $P(B|R)=P(M|R)=0$.

#### Enrichment planting of temperate trees on boreal stands

Invasion of temperate species on boreal stands is a function of the capacity of temperate species to colonize boreal forest $\beta_T$, and the proportion of available sources, *i.e.* the neighboring stands of mixed and temperate trees.
Invasion only applies to stands that are neither disturbed nor harvested: $P(M|B) = \beta_T(T + M)(1- (\varepsilon \times (1 - h) + h))$.
Enrichment planting of temperate species on boreal stands is modelled as an increase of the probability of boreal stands to become mixed.
Among boreal stands available to invasion, a proportion $e$ is directly assigned to mixed stands, representing the plantation of temperate trees.
The colonization probability of temperate species establishing boreal stands after enrichment planting adds a parameter $e$ to the model:

$$
P(M|B) = [(1- (\varepsilon \times (1 - h) + h)) \times \beta_T(T + M)] \times (1-e) + e
$$

Where $e$ is the proportion of available boreal stands (*i.e.*, neither disturbed nor harvested) that are enriched at each time step.
Natural dynamics occurs when $e=1$, while direct conversion by forest management occurs when $P(M|B)= 1- (\varepsilon \times (1 - h) + h)$.

### Managing to reduce extinction debt

Different ecological mechanisms can explain extinction debt caused by delayed response of forest trees to warming temperature.
Slow demographic rates along with dispersal limitations can delay the response of species to environmental changes [@Dullinger2012].
These life-history traits, associated with source-sink dynamics [@Schurr2012], can increase considerably the extinction debt of tree populations following warming temperature.
To reduce this delayed response, unadapted populations must disappear and therefore make room for the new population that is better adapted to the novel environmental conditions.
Disturbance and competitive exclusion are two ecological processes suitable to influence the rate of extinction and, if well directed, reduce extinction debt.
Here we choose harvest and thinning, which is a selective harvest within a stand, as complementary management practices that may influence disturbance and competitive exclusion.
Harvest of boreal stands can simulate large spatial scale disturbances, such as fire, and transform a proportion of boreal stands in a regeneration state.
Similarly, thinning of boreal species in mixed stands can simulate an increase in the fitness of temperate species which then can competitively exclude boreal species.
Both harvest and thinning are intended to open space and reduce the proportion of boreal species, and  therefore increase the likelihood of temperate species to shift northward.

#### Harvest of boreal stands

In the natural extinction model, boreal stands turn into a regeneration state only after disturbances, occurring at a probability ($\varepsilon$).
Harvest is modelled as an increase in the probability of boreal stands to become regeneration $P(R|B)$.
A proportion $h$ of boreal stands that are not disturbed, is converted into regeneration stands, featuring the cut of all trees.
This proportion of boreal stands is thus excluded from following natural dynamics.
Harvest thus involves an additional parameter $h$ that modifies the following probabilities:

$$
\begin{aligned}
  P(R|B) &= [\varepsilon \times (1 - h)] + h \\
  P(M|B) &= (1- (\varepsilon \times (1 - h) + h)) \times \beta_T(T + M)
\end{aligned}
$$

Where $h$ is the proportion of boreal stands that are harvested at each time step.
If $h=1$, no boreal stands will be maintained, and only natural disturbance occurs when $h=0$.

#### Thinning of boreal trees in mixed stands

The exclusion of boreal trees by temperate trees in mixed stands is a function of the instability of the mixed stand $\theta$ and the ratio of competitive abilities between temperate and boreal species, $\theta_T$.
Thinning of boreal species in mixed stands is modelled as an increase of the probability of mixed stands to become temperate by two different ways.

First, thinning of boreal species can be translated into a decrease of the persistence of the mixed stand ($P(M|M) = 1-\theta$), thus increasing $\theta$:

$$
  \theta_{m} = [\theta \times (1 - s1)] + s1
$$

Second, thinning of boreal species can be translated into an increase of the ability of temperate species to exclude boreal ones by competition:

$$
\theta_{T, m} = [\theta_{T} \times (1 - s2)] + s2
$$

It is unclear if we need to distinguish between the two processes.
The rationale is that the proportion $s1$ of mixed stands that are managed this way is directly converted into temperate.
It means that $s2$ should at least be equal to $s1$.
$s2$ can be greater than $s1$ if thinning further boost the competitively (fitness) of temperate species.
For a parsimonious approach, it is reasonable to set $s1=s2$.
These modifications directly affect $P(T|M)$ and $P(B|M)$:

$$
\begin{aligned}
  \theta_{m} &= [\theta \times (1 - s)] + s \\
  \theta_{T, m} &= [\theta_{T} \times (1 - s)] + s \\[6pt]
  P(T|M) &= \theta_m \times \theta_{T,m} \times (1 - \varepsilon) \\
  P(B|M) &= \theta_m (1 - \theta_{T,m}) \times (1 - \varepsilon)
\end{aligned}
$$

Where $s$ is the proportion of mixed stands that are available (not disturbed) and where thinning is applied, per time step.
When $s=1$, $P(T|M) = 1$ and $P(B|M) = 0$.


## Range shift analysis

### Analysis of the transient dynamics after warming temperature

We used the spatially implicit version of the model at equilibrium with current climate conditions to test the effect of forest management on the short-term dynamics following warming temperature.
To do so, we applied warming temperature and focused on the dynamics of the transient period of the four forest states until they reach the new steady state.
Steady state was considered as being reached when the difference between the current and previous state was inferior to $10^{-7}$ for 10 steps.
We computed five metrics characterizing the transient dynamics over a latitudinal gradient of annual mean temperature ranging from -2.61 to 5.07$^{\circ}$C, representing the ecotone gradient from boreal dominant species to a temperate dominant composition.
This gradient of temperature can be expressed as a straight line going from Montreal to Chibougamau, in Quebec, Canada.
While temperature varied, annual mean precipitation was fixed to mean value extracted from the database (998.7 mm), as precipitation has relatively small effects on the model compared to temperature [@Vissault2020].
For each initial temperature condition (*i.e.* latitude position), temperature increased of 0.09 $^{\circ}$C at each time step for the first 20 steps (100 years; RCP4.5) and then remained constant until the model reached the steady state.
As we use a linear increase of temperature to represent the boreal-temperate ecotone (ranging from -2.61 to 5.07$^{\circ}$C) instead of a real landscape, the RCP scenarios are based in the mean global projections [@IPCC2013].
We further tested the RCP8.5 scenario, however, the response to forest management was roughly similar to RCP4.5, and the only change was the latitudinal position that shifted farther north due to a stronger effect of warming temperature.

The five metrics characterizing the transient phase [@Boulangeat2018] after warming temperature for each latitude position allowed us to fully describe the transient phase and the effect of forest management during this phase.
The first two metrics are the asymptotic and initial resilience as measures of local stability derived from the Jacobian Matrix $J$ at the new equilibrium [@Arnoldi2016].
$J$ was numerically calculated using the R package rootSolve [@Soetaert2009; @Soetaert2009a].
The asymptotic resilience ($R_{\infty}$) is the leading eigen value of $J$, and quantifies the asymptotic rate of return to equilibrium after small perturbation.
The more negative $R_{\infty}$, the greater asymptotic resilience.
Initial resilience ($-R_0$) is the leading eigen value of the following matrix:

$$
M = \frac{-J + J^T}{2}
$$

Positive values of $-R_0$ indicate a smooth transition to the new equilibrium whereas negative values indicate reactivity, *i.e.* an initial amplification against final equilibrium.
The third metric is the exposure of the ecosystem states ($\Delta_{state}$), defined by the difference in state proportion between pre- and post-temperature warming [@Dawson2011].
The fourth metric is the return time ($\Delta_{time}$) or ecosystem sensitivity, which is estimated by the number of steps of the transitory phase, where each time step of the model is equal to 5 years.
The last metric is the cumulative amount of changes in the transitory phase, or ecosystem vulnerability [@Boulangeat2018].
It is defined as the sum of all changes in the states after warming temperature and is obtained by the integral of the states change over time ($\int S(t)dt$).
These five metrics together can summarize the multidimensionality of the response of a system to external disturbances.

We used five distinct simulation scenarios: natural dynamics without forest management, 0.25% of plantation, 0.25% of enrichment planting, 1% of harvest and 0.25% of thinning, in an annual rate.
The above values were chosen to maintain a certain degree of reality.
In the Canadian province of Quebec, about 1% of the forest territory is harvested annually.
Of this 1% harvested, only 20 to 25% is followed by planting.
To our knowledge, enrichment planting and thinning of a specific species are rarely used in Quebec and should not overpass the other practices, hence we choose to analyse the same amount as the plantation.
To further quantify the effect of increasing the intensity of forest management from 0 to 100% for each practice, we choose two locations from the gradient of temperature in which forest management had the most effect on the metrics of transient dynamics: -1 and 0$^{\circ}$C of annual mean temperature which represents the leading and trailing edge of the ecotone.
To overcome the multidimensionality of the simulations, we developed an online application to quantify the five metrics of the transient dynamics for any location of the temperature gradient, using any intensity of forest management, with three scenarios of warming temperature: https://ielab-s.dbio.usherbrooke.ca/STM-managed.

### Analysis of the northward range shift after warming temperature

We used a spatially explicit version of the model with an artificial landscape (lattice) representing a latitudinal gradient between temperate and boreal biomes, allowing us to account for explicit dispersal limitations and stochastic dynamics, to test the capacity of forest management to accelerate northward range shift of the boreal-temperate ecotone.
The latitudinal gradient of the landscape grid is defined using the same annual mean temperature range of the spatially implicit model (-2.61 to 5.07$^{\circ}$C), with cells of 300 m$^2$, to capture the whole ecotone from boreal to temperate dominant species, with constant annual mean precipitation of 998.7 mm.
Sensitivity analysis showed that range shift after warming temperature increased with larger grid cells (from 0.1 to 5 km$^2$), but the influence was stronger in cells larger than 1 km$^2$.
Although the smaller the cell the better we model dispersion, smaller cells are computationally expensive; therefore the size of 300 m$^2$ had a better compromise between these two factors.
Further, while the cell size affects the absolute value of range shift, it does not affect the relative effect of the different forest management strategies.
The prevalence of each state at time $t + 1$ was calculated considering the stand composition of the eight neighbors' cells and the temperature and precipitation condition of the cell at time $t$.
The state of the current cell at time $t + 1$ was then drawn from the matrix of transition probabilities.
The effect of warming temperature in the landscape dynamics is included by increasing temperature of 0.09 $^{\circ}$C for each cell at each time step for the first 20 steps (100 years; RCP4.5).
Similar to the same approach, we further performed simulations using the RCP8.5 scenario, and the results are shown in the supplementary materials.
The spatially explicit version of the model was bind into an R package stored on GitHub [@STManaged2020].
We used the released version v2.0 to run the simulations for this article.

We ran three simulations to compare the relative importance of warming temperature, forest management, and their interaction with the equilibrium distribution in future climate conditions.
The intensity of the four management practices was the same as used in the first approach.
The model ran for 150 years under three different scenarios: (i) only climate change, (ii) only one practice of forest management, and (iii) climate change and one practice of forest management at a time.
These three simulations were then compared with current ($T_0$) and future ($T_1$) forest distribution at equilibrium with the climate as reference points.
For each simulation, we quantified the boreal and the mixed + temperate occupancy over the latitudinal gradient of mean annual temperature.
As the chosen time scale (150 years) and management intensity may not be large enough to detect the response of forest to warming temperature and forest management, we ran the same configuration of simulations but increasing both time and management intensity.
The running time of each simulation was increased to 250, 500 and 1000 years (supp figures 2), and management intensity for all practices increased to 2, 5, 10 and 20% (supp figure 3).
We performed 15 replications varying the initial landscape for each simulation, however, we found little variation between replicates, and therefore choose to omit the confidence intervals for the sake of simplicity.


# Results

## Effect of Forest Management on Transient Dynamics After Climate Change

Plantation and enrichment planting of temperate species, which simulate the payment of colonization credit, were the only two practices affecting the transient dynamics after warming temperature (Figure @fig:num-res1).
When the system was perturbed with warming temperature, enrichment planting promoted the shift of forest states to a new equilibrium in the boreal region (Figure @fig:num-res1 c).
Plantation and enrichment planting reduced by about 40 and 80%, respectively, at around -1.5$^{\circ}$C the time for the forest to reach the new equilibrium after warming temperature (Figure @fig:num-res1 e).
The cumulative state changes (Figure @fig:num-res1 f) integrate the changes in both exposure and sensitivity.
Forest management reduced considerably the cumulative state changes in the boreal/mixed transition region by (i) reducing the time to reach the new equilibrium, and slightly increased cumulative state changes in the boreal region by (ii) increasing the shift of forest states to a new equilibrium.
In both boreal/mixed and mixed/temperate transition regions, asymptotic resilience was close to zero (weak resilience to perturbations) and initial resilience greater than zero (smooth response to perturbations).
Enrichment planting altered both resilience metrics in the boreal/mixed transition region only, where asymptotic resilience was increased (Figure @fig:num-res1 b) and initial resilience reduced (Figure @fig:num-res1 d).
Reducing colonization credit through plantation and enrichment planting of temperate species were effective in changing the transient dynamics after warming temperature, helping forest to keep pace with climate change.

![(a) Expected occupancy of boreal and mixed + temperate states at equilibrium with climate before ($T_0$) and after ($T_1$) warming temperature as a climatic reference. (b-f) Transient dynamics after warming temperature over the latitudinal gradient of annual mean temperature for five different scenarios: natural dynamics without forest management, 0.25% of plantation, 0.25% of enrichment planting, 1% of harvest and 0.25% of thinning. Transient dynamics are described by (b) asymptotic resilience or the rate in which the system recovery to equilibrium; (d) initial resilience or the reactivity of the system after warming temperature; (c) exposure or the shift of forest states to the new equilibrium; (d) sensitivity or the time for the state reach equilibrium after warming temperature; and (f) vulnerability or the cumulative amount of state changes after warming temperature.](manuscript/img/num-result.png){#fig:num-res1}

All management practices altered the transient dynamics after warming temperature, with the greatest impacts at the edge of temperate/mixed tree distribution and slightly into the boreal forest (Figure @fig:num-res1).
Plantation and enrichment planting had non-linear response to management intensity  in the boreal region (Figure 4); while enrichment planting and thinning had non-linear responses in the temperate/mixed region.
Overall, increasing plantation and enrichment planting intensity increased exposure and asymptotic resilience and reduced sensitivity at both spatial regions.
Harvest of boreal species also increased exposure but reduced asymptotic resilience and increased sensitivity.
Surprisingly, thinning of boreal species had a negative effect reducing asymptotic resilience and increased sensitivity at the boreal/mixed transition region.
In conclusion, increasing management intensity can accelerate forest response to climate change by reducing colonization credit but can delay this response by reducing extinction debt.
For the sake of simplicity, initial resilience and cumulative state changes are omitted in the Figure @fig:num-res2 and can be found in the supporting information (Figure @fig:sim-result-supp1).

![Transient dynamics (metrics described in Figure @fig:num-res1) following warming temperature along with the increasing management intensity for plantation, harvest, thinning and enrichment planting. Climatic condition is fixed at the boreal (annual mean temperature of -1; left panels) and the boreal/mixed transition (annual mean temperature of 0; right panels) regions.](manuscript/img/num-result_2.png){#fig:num-res2}

## Effect of Forest Management on Range Limits Shift Under Climate Change

We investigated how forest management affects the range limit shift of the boreal trailing edge and the temperate + mixed leading edge using spatially explicit simulations accounting for dispersal limitations and stochastic dynamics (Figure @fig:sim-result).
After 150 years with only forest management ($T_{150}$ + FM), both the boreal trailing edge and the temperate leading edge slightly shifted southwards.
After 150 years with temperature warming in the first 100 years (RCP 4.5), both the boreal and temperate range limit shifted northward.
However, boreal receded to a certain extent, and the smooth transition to temperate through mixed was reduced to an abrupt transition ($T_{150} + CC$).
Lastly, with both warming temperature and forest management interacting, enrichment planting of temperate species was the only practice to increase both the boreal and the temperate northward shift.
Plantation had a very small effect close to the transition limit, harvest reduced the proportion of boreal states but had no effect on range shifts, and thinning also did not have any effect on range limits.
Reducing colonization credit, through enrichment planting, increased the northward shift of forest states only when interacting with climate change, creating a smooth transition from boreal to mixed state.

![Boreal (left panels) and temperate plus mixed (right panels) occupancy along the latitudinal gradient of the boreal-temperate ecotone. Light and dark shaded areas are a reference of the state occupancy at equilibrium before and after warming temperature, respectively. Each line is a different simulation to differentiate the isolated and interacting effects of climate change (CC) and forest management (FM). The results are the mean of 15 replicates. Confidence intervals are omitted for simplicity as we found little variation between replicates. Management intensity was set to 0.25% for plantation, thinning and enrichment planting, and 1% for harvest. The climate change scenario was RCP 4.5.](manuscript/img/sim-result_RCP4.5.png){#fig:sim-result}

Simulation time and management intensity of figure @fig:sim-result were kept small for the sake of realism, but we further tested how increasing management intensity and time of simulation will affect range limits shift of boreal and temperate stands.
These simulations better reveal differences between scenarios.
Increasing simulation time up to 1000 years was just enough for both boreal and temperate range limits to reach the expected equilibrium, and reduce colonization credit with 0.25% of plantation and enrichment planting of temperate species (SI Figure S@fig:sim-result-supp3).
Increasing management intensity of up to 20% per year had different effects according to the four practices.
Plantation and enrichment planting at such intensity increased northward range limits shift linearly, and overpassed the expected equilibrium with future warming temperature (SI Figure S@fig:sim-result-supp2).
Harvest of boreal species at high intensity reduced the proportion of boreal and increased the proportion of regeneration state but did not break the abrupt transition into a smooth shift between boreal and mixed states.
Thinning of boreal species increased the transition from mixed to temperate stands but did not have any effect on range limits shift.


# Discussion

There is an increasing need to investigate how forest biomes will respond to warming temperature, and how forest management can mitigate the negative impacts of this perturbation.
We developed a simple and informative modelling framework based on the metapopulation theory that let us to (i) establish the link between forest management and the ecological processes setting range limits, and to (ii) investigate the effect of forest management on the response of the boreal-temperate ecotone to climate change.
Our study suggest that all management practices are expected to impact forest dynamics in the short term (transient phase).
However, to reduce the period of transient dynamics after warming temperature and increase range limit shifts at large spatial scale in the long term, only planting temperate tree stands and enrichment planting of temperate trees in boreal stands are likely to play a role by paying the colonization credit.
Our results, based on two complementary simulation techniques, suggest that forest management could help the boreal/temperate ecotone keep pace with climate change.
This theoretical investigation supported by long-term data provides new expectations to design future experiments testing the potential of forest management to adapt to climate change.
It should guide future managers to take into account both natural and anthropogenic perturbations on forest dynamics.

***How plantation and enrichment planting can reduce colonization credit?***

Although climate change is expected to drive a shift in forest composition by favoring temperate over boreal trees, the boreal-temperate ecotone is lagging behind climate change [@Talluto2017; @Vissault2020].
Our results suggest that plantation and enrichment planting of temperate species on the boreal region can reduce this lag by reducing the transient period and increasing the northward range shift of the boreal-temperate ecotone.
To date few empirical studies have tested how assisted migration increases northward range shift of trees.
For instance, modelling the plantation of tree species more suitable to future climate is predicted to increase resilience indicators such as carbon stocks and tree species diversity [@Hof2017], and therefore plantation is assumed to increase tree range shift under climate change.
Using the same rationale, simulating the plantation of climate suitable tree species have been shown to increase both biomass productivity and species diversity in multiple scenarios of climate change [@Duveneck2015].
We found enrichment planting slightly increased asymptotic resilience, which means a faster recovery to equilibrium after climate change (Figure @fig:num-res1).
This is similar to simulations of species composition change over time, from which resistance and resilience have been explicitly assessed, suggesting that forest management had limited ability to increase these indicators in the face of climate change [@Duveneck2016].

***Why is enrichment planting practice more efficient than planting?***

Enrichment planting of temperate trees into boreal areas had a stronger effect on both reducing the transient period and increasing range shift when compared with planting.
This is due to three different mechanisms.
First, it is related to the prevalence of the different forest states and the dependence of the management scenarios to these values.
The intensity of forest management in the model is relative to the state abundance; hence 0.25% of boreal stands being enriched is much higher than 0.25% of regeneration stands being planted.
That explains the need to increase planting intensity beyond 0.25% to increase the boreal northward range shift (Supp fig SI3).
Second, management practices are not spatially organized.
While enrichment planting is necessarily applied on boreal stands, planting is applied in regeneration stands that are distributed across the landscape.
The third mechanism is however independent from the design of the management scenarios.
The number of transitions to reach the expected state at equilibrium with climate depends on the management practice; enrichment planting needs only one transition (B -> M) while planting temperate species needs two (R -> T -> M).
These results suggest that enrichment planting in local gaps has the best potential compared to plantation to assist forest keep pace with climate change.
Similarly, tree recruitment of northern temperate forests was more effective in the presence of local canopy gaps compared to recruitment on open areas after clearcut [@LePage2000].
It means enrichment planting in local gaps is expected to be more effective, but this practice alone may not be as effective as expressed here because empty places are needed to perform this practice.
Naturally, canopy gaps in mixed forests facilitate the establishment of temperate species [@Leithead2010].
Therefore, enrichment planting may be more effective when associated with other practices such as thinning.

***Why does reducing colonization credit increase range shift but reducing extinction debt does not?***

Reducing extinction debt by increasing the frequency of disturbance (natural or anthropogenic) is expected to drive range shift by eliminating maladapted species that would persist for a long period, and then create colonization opportunities for advancing species [@Renwick2015; @Kuparinen2010].
For instance, moderate disturbance has been shown to amplify compositional shift to warm-adapted species in the boreal-temperate ecotone of Quebec [@Brice2019].
Here intensifying disturbance by increasing harvest of boreal stands did not affect the rate of northward range shift after warming temperature.
This result corroborates with @Vanderwel2014 in which harvest of boreal species amplifies transitions to early-successional forest type, but have no effect on the range shift of boreal conifers.
Similarly, moderate disturbances increased the probability of transition from mixed to temperate stands, but had a small effect on the transition from boreal to mixed [@Brice2020].
Such lack of effect on range shift when reducing extinction debt may be explained by source-sink dynamics that, despite the increase in the extinction rate of patches due to harvest, increases the likelihood of harvested boreal stands becoming boreal in the future.
Furthermore, limited dispersal may contributes to a lack of temperate colonization in harvested patches.
The likelihood of harvested patches becoming boreal again may reduce if there is a demographic limit in the persistent boreal species (*e.g.* physiological responses @Reich2015), and further intensified if species better adapted to the new climate arrive (*e.g.* plantation), in which competitive exclusion will eliminate the less adapted species.

***Thinning increases temperate tree range expansion, but does not affect boreal stands***

We explored the hypothesis that selective harvesting of boreal tree species (thinning) on the mixed region would increase the proportion of temperate species, and therefore increase the regional pool to favor the colonization of temperate trees into the boreal region.
Thinning indeed increased the proportion of temperate stands in the mixed region, because it helps competitive exclusion.
Such expansion of the temperate range limits in response to harvest of boreal species corroborates with literature, where harvest has increased temperate species in the mixed region of Quebec [@Boulanger2019; @Brice2020].
However, thinning did not have any effect on the range limit of boreal stands.
In other words, temperate trees did not colonize boreal stands, even with increasing source pools.
Such lack of temperate progression onto on the boreal region may be explained by the difficulty of temperate trees to settle in boreal stands due to priority effects and unfavourable substrates [@Solarik2018; @Solarik2020].
This effect is included in the model indirectly through the succession (mean $\beta_{T}$ = 0.62) and colonization (mean $\alpha_{T}$ = 0.99) parameters associated with the temperate stand.
This  may be the result of plant-soil feedbacks, or the importance of gaps for temperate tree regeneration.
For instance, regeneration of temperate species such as red maple and red oak have been shown to be facilitated in gaps, while boreal species showed no difference [@Leithead2010].

***Limitations and future perspectives***

We have argued that plantation and enrichment planting may have the potential to reduce colonization credit and therefore help forests to keep pace with climate change.
However, further experiments are necessary as the four simulated practices in our study are an approximation of real management practices.
For instance, we simulated thinning as selective logging boreal species in favor of temperate, while in practice, thinning generally focuses on reducing stand density regardless of the species being thinned.
Such density reduction is tricky to address with our model because local abundances are not accounted for.
There is generally a mismatch between our simulations at the community stand resolution with the management practices that occur at the population level.
Aware of that, we call for studies taking account of forest dynamics at several organizational scales to complement our results with the inclusion of more details on local management practices.
Demographic models are useful to predict local mechanisms such as species interaction scale up to determining species range limits at the metapopulation level [@Araujo2014; @Normand2014].
However, these models are limited in the literature when compared with models at the metapopulation level [@Hylander2013].
In our context, demographic models can test the effect of forest management in the growth, mortality and regeneration processes, and a landscape-level model such as ours helps better understanding how the effect of management practices scales up to a larger spatial scale.
We should also cautiously interpret the effect of climate change as simulated here.
Although it is predicted that drought intensity will increase in the future and may drive how the forest will respond to climate change [@Greenwood2017], we have simulated only warming temperature, while precipitation remained constant.
Some studies have shown tree species to be more sensitive to an increase in drought rather than temperature [*e.g.* white spruce @Andalo2005].
Drought is, however, more a pulse disturbance (or shock) and should be investigated fully with different frequencies and intensities.
The present study rather shows how communities could adapt to a continuous change in the environment and how management could help.

We have demonstrated here that management practices could help forest communities to cope with a fast change in climate along latitude.
However, we can expect that the spatial distribution of different practices would interact and change the final outcomes.
For instance, creating gaps with a selective harvest of boreal stands nearby the mixed distribution or the temperate tree plantations may create a synergy.
Furthermore, we have simulated here the effect of four management practices alone, while the interaction between them may have an even greater effect.
Our simulations show no effect of plantation and harvest on the northward range shift of the boreal-temperate ecotone at a short time scale of 150 years (figure @fig:sim-result).
However, planting temperate trees after harvesting boreal stands may overcome the limitations of these two practices when applied individually, and therefore increase the northward range shift.
Interacting management practices such as harvest and plantation, and applying these practices in particular locations may increase the potential of forest management to help forest keep pace with climate change.
We propose future studies should focus on the interaction between the management practices, and how the spatial distribution of these practices alter the shift in tree range limit.

\newpage


# References

<div id="refs"></div>
\newpage


# Appendix

![Figure S1](manuscript/img/num-result_supp1.png){#fig:sim-result-supp1 width=80%}


![Figure S2: Increasing simulation time to 250, 500 and 1000 years.](manuscript/img/sim-result_supp2.png){#fig:sim-result-supp2}


![Figure S3: Increasing management intensity in 2, 5, 10 and 20%.](manuscript/img/sim-result_supp3.png){#fig:sim-result-supp3}

![Figure S4: Boreal (left panels) and temperate plus mixed (right panels) occupancy along the latitudinal gradient of the boreal-temperate ecotone. Light and dark shaded areas are a reference of the state occupancy at equilibrium before and after warming temperature, respectively. Each line is a different simulation to differentiate the isolated and interacting effects of climate change (CC) and forest management (FM). The results are the mean of 15 replications. For the sake of simplicity, the confidence interval is omitted as we found little variation between replicates. Management intensity was set to 0.25% for plantation, thinning and enrichment planting, and 1% for harvest. The climate change scenario was RCP 8.5.](manuscript/img/sim-result_RCP8.5.png){#fig:sim-result-supp4}

![Figure S5: Parameters of the State and Transition Model varying as a function of annual mean temperature from @Vissault2020. Annual mean precipitation is fixed to 998.7 mm. Parameters for (b) before and after warming temperature following (c) RCP4.5 and (d) RCP8.5 climate change scenarios over the same latitudinal position.](manuscript/img/num-result_supp2.png){#fig:sim-result-sup5}