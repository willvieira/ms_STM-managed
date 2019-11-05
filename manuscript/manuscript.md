---
  title: Forest Management Affect Colonization Credit, but not Extinction Debt, to Reduce Delayed Range Shifts under Climate Change
  author: Willian Vieira, Isabelle Boulangeat, Marie-Hélène Brice, Robert Bradley, Dominique Gravel
  date: This manuscript was compiled on \today
  output:
    redoc::redoc:
      highlight_outputs: yes
    bookdown::pdf_document2:
      fig_caption: yes
      includes:
          in_header: conf/config_md.sty
  bibliography: "conf/refs.bib"
  fontsize: 11pt
  link-citations: true
---

\newpage

# Introduction

**Forest dynamics under climate change**

There is a growing concern in how species will respond to climate change.
Correlative statistical models, which are based in the niche concept, have projected species' range to shift following warming temperature, and trees are expected to migrate hundreds of meters by the end of this century [@Malcolm2002; @Mckenney2007].
However, despite the observed shift of many species’ range following warming temperature [@Chen2011], many tree species have undergone no change [@Harsch2009; @Zhu2012].
For instance, trees of the eastern North America have shifted their range limits to fewer than 50% of the required to keep pace with warming temperature [@Sittaro2017].
This mismatch between climate conditions and forest composition leads us to anticipate maladaptation, and therefore a possible loss of forest productivity [@Aitken2008]
Quantify the mechanisms determining species range limits is critical to understanding species response to climate warming, and the potential actions to mitigate this perturbation [@Becknell2015].

Fast climate change has fostered the need to mechanistically understand the drivers of species’ range distribution as an effort to improve our projection abilities [@Evans2016].
Colonization and extinction are well-established mechanisms determining species’ range limits [@Levins1969; @Hanski1998; @Holt2000].
The metapopulation theory predicts species range limits to be defined as the moment colonization rate equals extinction rate, assuming habitat is available [@Holt2000].
Assuming colonization and extinction rate depend on temperature, it is expected, with climate warming, that species’ range limits will be relocated.
Range expansion depends on many processes such as dispersion capacity, establishment of propagules, survival, and growth until maturity [@Jackson2010; @Schurr2012].
On the other hand, excluding metapopulation dynamics [@Pulliam2000], range compression depends on species life-history trait and perturbation regimes that will define how individuals are persistent to local extinction [@Butterfield2019; @Schurr2012].
A failure on any of the above processes lead respectively to colonization credit, where locations are suitable but unoccupied [@Jackson2010; @Cristofoli2010], and extinction debt, where populations remain in unsuitable locations [@Kuussaari2009; @Tilman1994a].
Indeed, for trees that have slow demographic rates, the eastern North American trees are out of equilibrium with climate due to extinction debt at the trailing edge of the distribution, and colonization credit at the leading edge [@Talluto2017].

Integrating spatial constraints, demography and species interaction is of crucial importance to assess colonization credit and extinction debt.
It is well known that dispersal limitation will affect how species respond to environmental change [@Holt2005; @Scheller2008].
Trees naturally present low migration rates, and current land-use change through habitat loss and fragmentation will further contribute to reducing tress dispersion rates [@Collingham2000; @Malanson1996].
Furthermore, interspecific interactions such as competition can negatively affect demography and dispersal, and therefore reduce the potential range expansion of species [@Svenning2014].
On the other hand, for range compression, trees' growth rate will decrease in unsuitable habitats; but its extinction will depend on the species mortality rate [@Kuparinen2010] as well as the arrival of better competitors adapted to the new climate.
Furthermore, source-sink dynamics may contribute to the persistence of species in unsuitable habitats [@Pulliam2000].
Using a state and transition model for the eastern North American forest compositions, @Vissault2020 integrated slow demography of trees, species interaction and dispersal deficiency, and showed that the temperate-boreal ecotone will have minimal range shift following climate warming.
Such mechanistic models are ideal tools to explicit test the potential of management to mitigate the impact of climate change.

***Forest management***

Reduce colonization credit and extinction debt is an opportunity to help forest adapt by favoring the range shift of trees following climate warming [@Talluto2017].
Forest management, such as the well-known assisted migration [@Peters1985a], has been proposed as a potential tool in this direction [*e.g.* @Gray2011].
However, there has been extensive debate about its effectiveness [*e.g.* @McLachlan2007; @Vila2010; @Ricciardi2009; @Schwartz2009], with no “one size fits all” solution [@Hewitt2011;@Vila2010].
The truth is, temperature is warming and there is an increased need to adapt forest management practices under climate change [@Keenan2015; @Ameztegui2018].
Management practices can alter forest dynamics at different spatial scales, from local light gaps by selective logging, to larger areas by clearcutting.
Opening space at any spatial level may reduce extinction debt by removing species expected to go extinct, but also reduce colonization credit by creating available areas to be colonized [@Leithead2010; @Steenberg2013].
On the other hand, planting and enrichment planting of species or genotype in regions beyond its current range may reduce colonization credit.
Indeed, forest management can be adapted and optimized with small trade-offs between productivity and ecosystem services to enhance forest multifunctionality [@VanderPlas2018; @Trivino2017].

Before taking actions, however, we need a mechanistic understanding of the interaction between forest management and climate change [@Millar2007].
Empirical evidence testing the potential of forest management to adapt to climate change is limited, even for the highly discussed assisted migration [@Bucharova2017].
Modeling how management practices affect the mechanisms driving forest dynamics may improve our understanding about its effectiveness and orientate future experiments.
When modeling stand productivity of *Pinus sylvestris L.* under climate change, for instance, the use of thinning to reduce stand density between 20 and 40% was found to be optimal to maintain stand productivity [@Ameztegui2017].
Here we extend @Vissault2020’ model to integrate four simulated management practices to affect the colonization-extinction dynamics in an attempt to increase northward range shift.
To do so, for instance, plantation of temperate species is simulated by selecting random empty plots in the boreal region and transforming it in temperate plots.
Although the simplicity of the management practices, this approach captures the core result of managing at a broad spatial and temporal scale.
Quantify the effect of forest management on colonization and extinction mechanisms allows us to better assess the potential of management to help forest keep pace with climate change.

***Transient dynamic***

The potential of adaptive management has often been poorly accessed through indirect factors such as species richness.
The rationale is that increasing species diversity will increase the likelihood natural selection will keep the same services under uncertain climate changes [@Kolstrom2011].
However, given the slow response of forest ecosystems to environmental changes, forest adaptation to new climate conditions may last for a long period until reaches equilibrium.
Therefore, characterize the short-term dynamics rather than the long-term equilibrium is crucial to adaptive management as both happens at the same short time scale [@Hastings2004; @Svenning2013; @Ezard2010].
The short-term dynamics or the period a system at equilibrium takes to reach a new equilibrium after a disturbance is defined here as transient dynamics.
When analyzing the effect of harvest on the dynamics of the African tree *Khaya senegalensis*, for instance, the transient dynamics revealed an effect not captured when only analysis the long-term dynamics [@Gaoue2016].
Transient dynamics, especially for long-lived species, can provide insights on how management can help species keep pace with climate change.

***The challenge***

In an attempt to help forest keep pace with climate change, here we test the potential of forest management to increase northward range shift of the temperate-boreal ecotone following warming temperature.
We use a model based in the metapopulation theory and parametrized for the eastern North American trees [@Vissault2020] that decompose forest dynamics in colonization-extinction processes.
We measure the effect of reducing colonization credit through plantation and enrichment planting, and reducing extinction debt through harvest and thinning using two different approaches.
First, we perturb the system at equilibrium with warming temperature and characterize its recovery to the new equilibrium through five metrics of the transient dynamic: (i) initial resilience or the reactivity of the system after warming temperature; (ii) local resilience or the rate in which the system recovery to equilibrium; (iii) exposure or the shift of forest states to the new equilibrium; (iv) sensitivity or the time for the state reach equilibrium after warming temperature and (v) vulnerability or the cumulative amount of state changes after warming temperature.
We hypothesize that reducing colonization credit and extinction debt will reduce the transient period until forests reach its new equilibrium.
Second, we spatially-explicit the first approach to account for deficient migration of trees and stochastic dynamics, and predict how the range limits of the temperate-boreal ecotone will shift in the next 150 years.
We hypothesize that reducing colonization credit and extinction debt will increase the northward range shift of the temperate-boreal ecotone.



![Conceptual hypothesis. The left panel is the result of the forest states at equilibrium with climate extracted from the State and Transition Model parametrized for the North American forest. In this panel we can see how boreal trailing edge and temperate/mixed leading edge are expected to shift northward after climate change (CC). The left panel of the hypothesis 1 box shows the five metrics to characterize the transient dynamics of a system after perturbation: initial resilience ($-R_0$), asymptotic resilience ($R_{\infty}$), exposure ($\Delta_{state}$), sensitivity ($\Delta_{time}$) and  cumulative amount of changes ($\int S(t)dt$). Our first question is how forest management will affect these five metrics and our hypothesis is described in the right panel. On the hypothesis 2 box we show the first (before CC) and last (after CC) landscape of a simulation using the spatially-explicit version of the model. The bars limit the trailing edge of boreal and the leading edge of temperate states. We question if forest management can increase the northward shift of the boreal trailing edge which is lagging behind CC. Our hypothesis is that forest management will increase the northward shift and smooth the transition between boreal and mixed states.](img/concept.pdf){#fig:concept}

# Methods

## State and Transition Model with forest management
We used a State and Transition Model parameterized for the eastern North American forest (Vissault et al. submitted) in which we integrated four practices of forest management to test their impact in the response of forest states to climate change.
The model has four states defined by succession and species composition: (R)egeneration, (T)emperate, (M)ixed and (B)oreal (Figure \@ref(fig:model)).
The transition probabilities between states are defined by four ecological processes.
Succession ($\alpha$) promotes the transition from regeneration state to either boreal, mixed or temperate; the opposite process is disturbance ($\varepsilon$), increasing the transition of matures states to regeneration.
Colonisation ($\beta$) of either boreal or temperate species in the opposite state promotes the transition to mixed state; competitive exclusion ($\theta$ and $\theta_{T}$) between boreal and temperate species increases the probability of mixed stands become either boreal or temperate.
The probability of each of these processes is calculated based in temperature, precipitation and the states neighbours proportion.
Details in the classification of states and parametrization of the model can be found in Vissaut et al..
Plantation, harvest, thinning and enrichment planting are the four practices of forest management implemented in the model.
The rational of these four management practices is to favour the spread of the temperate forest when the climate context allows temperate tree regeneration.
The following sections details how each practice is implemented in the model.

![State and Transition Model and the integrated forest management practices in red.\label{fig:model}](img/model_equation_fm.pdf){#fig:model}

\comment{}{keep the same order than in the intro}

### Plantation of temperate stands
Succession from regeneration stands to either boreal, mixed or temperate is a function of the capacity of boreal and temperate species to establish ($\alpha_B$ and $\alpha_T$), and the proportion of neighbouring stands.
Plantation practice increases the probability of regeneration stands to become temperate $P(T|R)$.
It gets a proportion of available regeneration stands, and convert it to temperate, reducing then the probability that regeneration stands become either boreal or mixed.
This proportion of regeneration stands is not available anymore for natural succession.
Plantation thus involves an additional parameter $p$ that modifies the following probabilities:

$$
\begin{aligned}
  P(T|R) &= [\alpha_T (T+M) \times (1-\alpha_B (B+M))] \times (1 - p) +  p \\
  P(B|R) &= [\alpha_B (B+M) \times (1-\alpha_T (T+M))] \times (1 - p) \\
  P(M|R) &= [\alpha_T (T+M) \times \alpha_B (B+M)] \times (1 - p)
\end{aligned}
$$

where $p$ is the proportion of R stands that are managed per time step. Note that when $p=0$, the natural dynamic occurs and when $p=1$, $P(T|R)=1$,  $P(B|R)=P(M|R)=0$.

### Harvest of boreal stands

Perturbation of boreal stands to regeneration is a function of extreme events ($\varepsilon$).
Harvest practice increases the probablity of boreal stands to become regeneration $P(R|B)$.
It gets a proportion of boreal stands that were not disturbed, and convert it in regeneration stands by cutting all trees.
Harvest thus involves an additional parameter $h$ that modifies the following probabilities:

$$
\begin{aligned}
  P(R|B) &= [\varepsilon \times (1 - h)] + h \\
  P(M|B) &= (1- (\varepsilon \times (1 - h) + h)) \times \beta_T(T + M)
\end{aligned}
$$

Where $h$ is the proportion of boreal stands that are harvested at each time step. If $h=1$, no boreal stands will be maintained, and when $h=0$, the natural disturbance occurs.

### Enrichment planting

Colonization (invasion) of temperate species on boreal stands is a function of the capacity of temperate species to colonize $\beta_T$, and the proportion of neighbouring stands of mixed and temperate. This only applies to stands that are neither disturbed nor harvested: $P(M|B) = \beta_T(T + M)(1- (\varepsilon \times (1 - h) + h))$.
Enrichment planting of temperate species on boreal stands increases the probability of boreal stands to become mixed.
It gets a proportion of boreal stands available to colonization, and convert it in mixed stands by planting temperate trees.
The colonization probability of temperate species on boreal stands after enrichment planting adds a parameter $e$ to the model:

$$
  P(M|B) = [(1- (\varepsilon \times (1 - h) + h)) \times \beta_T(T + M)] \times (1-e) + e
$$

Where $e$ is the proportion of available boreal stands (ie, neither disturbed nor harvested) that are enriched at each time step. When $e=0$, the natural dynamic occurs, when $e=1$, $P(M|B)= 1- (\varepsilon \times (1 - h) + h)$.

### Thinning of boreal trees in mixed stands
The exclusion of boreal trees by temperate trees in mixed stands is a function of instability of the mixed stand $\theta$ and the ration of competitive ability between temperate and boreal species, $\theta_T$.
Thinning of boreal species in mixed stands can increase the probability of mixed stands to become temperate by two different ways.

First, thinning of boreal species should decrease the stability of the mixed stand ($P(M|M) = 1-\theta$), thus increase $\theta$:

$$
  \theta_{m} = [\theta \times (1 - s1)] + s1
$$

Second, thinning of boreal species should increase the ability of temperate species to exclude boreal ones by competition:

$$
  \theta_{T, m} = [\theta_{T} \times (1 - s2)] + s2
$$

It is unclear if we need to distinguish between the two parameters. The rational is that the proportion $s1$ of mixed stands that are managed this way are directly converted into temperate. It means that $s2$ should at least be equal to $s1$. $s2$ can be greater than $s1$ if thinning further boost the competitively (fitness) of temperate species. For a parsimonious approach, it seems reasonable to set $s1=s2$. These modifications directly affect $P(T|M)$ and $P(B|M)$:

$$
\begin{aligned}
  P(T|M) &= \theta_m \times \theta_{T,m} \times (1 - \varepsilon) \\
  P(B|M) &= \theta_m (1 - \theta_{T,m}) \times (1 - \varepsilon)
\end{aligned}
$$

Where $s$ is the proportion of mixed stands that are available (not disturbed) and where thinning is applied, per time step. When $s=1$, $P(T|M) = 1$ and $P(B|M) = 0$.

## Spatially-implicit model analysis
The spatially-implicit version of the model concentrates in a determined climatic condition (fixed temperature and precipitation), and giving an initial proportion of the four states in non-equilibrium with the climatic condition, we can evaluate the transient dynamic of the four states over time until they reach the steady state.
The impact of warming temperature is included in the model by setting an initial proportion of states at temperature $x$, and running the model with temperature $x + warming$.
In the context of slow transition rate of boreal forest under climate change (Vissault et al.), we will set an initial condition where boreal is the dominant state, and run the model with temperature increasing of 0.11 $^{\circ}$C at each time step for the first 20 steps (100 years; RCP6) in which the final condition should be dominated by mixed state.

Using five metrics to characterize the response of boreal state to warming temperature, we can have a mechanistic understanding of the transient phase and test the potential of forest management in each of these metrics.
We used asymptotic and initial resilience as measures of local stability [@Arnoldi2016].
Asymptotic resilience ($R_{\infty}$) quantifies the asymptotic rate of return to equilibrium after small perturbation.
Initial resilience ($-R_0$) describes the response of initial equilibrium to warming temperature.
Positive values of $-R_0$ indicates smoothly transition to the new equilibrium wether negative values indicates reactivity, i.e. an initial amplification against final equilibrium.
The exposure of the ecosystem states ($\Delta_{state}$) is defined by the difference in state proportion between pre- and post-temperature warming [@Dawson2011].
The return time ($\Delta_{time}$) or ecosystem sensitivity is the length in steps (each time step is equal to 5 years) of the transitory phase.
Finally, the cumulative amount of changes of the transitory phase, or ecosystem vulnerability [@Boulangeat2018], is defined as the integrated measure of all changes in the states after temperature warming, and is obtained by the integral of the states change over time ($\int S(t)dt$).


## Spatially-explicit model analysis
The spatially-explicit version of the model used a theoretical landscape (lattice) to account for environmental variability and stochastic dynamics.
The latitudinal gradient of the landscape is defined by temperature variation, whereas precipitation remains constant.
The mean annual temperature varies from TODO where temperate is dominate stand, to TODO where boreal dominates.
In the context of slow migration northward of boreal stands, our lattice focus on the southern range limit of boreal, the northern range limit of temperate, and the mixed stands ecothone.
The prevalence probability of each cell of the lattice at time $t + 1$ was calculated considering the eight neighbours cells and the environmental condition of the cell at time $t$.
The state of the current cell at time $t + 1$ is then defined in function of the multinomial distribution of the prevalence probability.
The impact of warming temperature in the landscape dynamics is included by temperature increasing of 0.09 $^{\circ}$C for each cell at each time step for the first 20 steps (100 years; RCP4.5).

We measured the southern range limit of boreal and the northern range limit of temperate stands at each time step over the simulation time.
The range limit of boreal and temperate stands was defined as the farthest line of the landscape in which composition dominates 70% of the lattice row.
We summed the distance between range limit with and without forest management at each time step for the whole simulation time to compute the cumulative changes in range limit (i.e. how much the range limit changes under temperature warming for managed and non-managed landscapes).

# Results

## Effect of forest management on transient dynamic after climate change

We described the transient dynamic after warming temperature over the latitudinal gradient of annual mean temperature for five different scenarios: natural dynamics without forest management, 0.25% of plantation, 1% of harvest, 0.25% of thinning and 0.25% of enrichment planting (Figure \@ref(fig:num-res1)). Plantation and enrichment planting were the only two practices affecting the transient dynamic after warming temperature. When the system at equilibrium was perturbed with warming temperature, forest managed increased the shift of forest states to a new equilibrium in the boreal region (figure 1a). Forest management reduced the time for the forest states reach the new equilibrium after warming temperature in the boreal/mixed transition region, but increased in the boreal region (f1c). The cumulative state changes (f1e) resumes the changes in bot exposure and sensitivity. Forest management reduced the cumulative state changes in the boreal/mixed region by reducing the time to reach the new equilibrium, and increased cumulative state changes in the boreal region by increasing the shift of forest states to a new equilibrium. Asymptotic and initial resilience had their picks in both boreal/mixed and temperate/mixed transition regions. In these regions asymptotic resilience was close to zero (weak resilience to perturbation) and initial resilience greater than zero (smooth response to perturbation). Plantation and enrichment planting altered both resiliences only in the boreal region, where these practices increased asymptotic resilience (f1b) and reduced initial resilience (f1d). Plantation and enrichment planting were effective in changing the transient dynamic after warming temperature in both the boreal and boreal/mixed transition regions.

![The transient dynamic after warming temperature over the latitudinal gradient of annual mean temperature for five different scenarios: natural dynamics without forest management, 0.25% of plantation, 1% of harvest, 0.25% of thinning and 0.25% of enrichment planting. Transient dynamic is described by (a) exposure or the shift of forests states to the new equilibrium; (b) asymptotic resilience or the rate in which the system recovery to equilibrium; (c) sensitivity or the time for the state reach equilibrium after warming temperature; (d) initial resilience or the reactivity of the system after warming temperature and (e) vulnerability or the cumulative amount of state changes after warming temperature.](img/num-result.pdf){#fig:num-res1}

We fixed the environment condition for both the boreal and the boreal/mixed transition region, and tested how increasing forest management intensity alter the transient dynamic after warming temperature (supplementary figures \@ref(fig:supp-num-res2) and \@ref(fig:supp-num-res3)). By increasing management intensity, all management practices altered the transient dynamic after warming temperature, but some metrics presented non linear response to the increase in the intensity of forest management. For example, the time to reach the new equilibrium and the cumulative state changes increased with plantation and  enrichment planting, but only for small intensities of management. When the intensity of these practices was higher than 0.5%, sensitivity and cumulative changes reduced with management intensity. Management intensity had no linear effect in the transient dynamic after warming temperature.

![Supp figure 1. Transient dynamic (metrics described in figure 1) after warming temperature along the increasing management intensity for plantation, harvest, thinning and enrichment planting. Climatic condition is fixed at the boreal/mixed transition region with mean annual temperature of 0 degrees.](img/supp-num-result_env1a_0.pdf){#fig:supp-num-res2}

![Supp figure 2. Transient dynamic (metrics described in figure 1) after warming temperature along the increasing management intensity for plantation, harvest, thinning and enrichment planting. Climatic condition is fixed at the boreal/mixed transition region with mean annual temperature of -1 degrees.](img/supp-num-result_env1a_-1.pdf){#fig:supp-num-res3}

## Effect of the interaction between forest management and climate change on range limit shift

Using the spatially-explicit model accounting for deficient migration of trees and stochastic dynamics, we tested the interacting effect of forest management and climate change in increasing the shift of the boreal trailing edge and temperate+mixed leading edge (figure \@ref(fig:sim-result)). We show how the occupancy of boreal and temperate states over the latitudinal gradient of annual mean temperature changes from the current landscape configuration ($T_0$) to: 1000 years latter without climate change neither forest management ($T_1$); with only warming temperature ($T_1 + CC$); with only forest management ($T_1 + FM$); and both warming temperature and forest management interacting ($T_1 + CC + FM$). After 1000 years with the same conditions, both the boreal trailing edge and the temperate leading edge shifted southwards (red line $T_1$). After 1000 years with temperature warming in the first 100 years (RCP 4.5), both the boreal and temperate range limit shifted northwards. However, boreal receded to a certain extent, and created a critical transition between boreal and mixed/temperate states (green line $T_1 + CC$). With forest management and no warming temperature, all practices had no effect on the range limit shift and the response was similar to no warming temperature (light blue line $T_1 + FM$). Except for enrichment planting, which reduced the southwards shift of boreal and temperate. Finally, with both warming temperature and forest management interacting, the range limit shift was stronger. Plantation and enrichment planting interacting with climate change had a stronger effect in shifting both the boreal and the temperate northwards. These two practices increased the northward shift of forest states only when interacting with climate change, creating a smooth transition between boreal and mixed states.

![Boreal (left panels) and temperate plus mixed (right panels) occupancy along the latitudinal gradient of the boreal/temperate ecotone. Each line is a different simulation to differentiate the isolated and interacting effect of climate change (CC) and forest management (FM). $T_0$ is the initial landscape, $T_1$ the last landscape after 1000 years, $T_1 + CC$ with climate change, $T_1 + FM$ with forest management and $T_1 + CC + FM$ with climate change and forest management interacting. The results are the mean and 95% confidence interval. The management intensity was 1% for plantation and 0.25% for harvest, thinning and enrichment planting. Climate change scenario was the RCP 4.5.](img/sim-result.pdf){#fig:sim-result}

# Discussion

<!-- Old stuff

With climate change and warming temperature, we expect plant species to follow their climatic optimum, which means that temperate species in North America are expected to migrate northward.
But because trees have slow migration rate and long life-cycle, it has been predicted that the expansion of temperate and boreal forests northward will lag behind climate change. This would create a transitional situation where the forests would not be spatially distributed at their climate optimum, thus affecting their prod productivity.
Here we aim to measure the potential of forest management to increase the speed of the forest migration northward.
We will use a State and Transition Model calibrated for the eastern North American forests, and we will integrate four management practices into the model to test their effect in the northward migration rate of the temperate forest (Figure \@ref(fig:model)).

- **Plantation** of temperate trees (immediatly) transforms a proportion of available stands (in regeneration state) in temperate state ($R \rightarrow T$)
- **Harvest** of boreal trees transforms a proportion of boreal stands (that are not going to be disturbed) in regeneration state ($B \rightarrow R$)
- **Thinning** of mixed forests by harvesting boreal trees reduces the probability of staying in mixed state by increasing the ability of temperate trees to exclude boreal tree by competition ($M \rightarrow T$)
- **Enrichment planting** of temperate trees in boreal stands increases the probability of invasion of temperate species in the boreal state ($B \rightarrow M$).

We used two spatial simulation approaches to test the effect of forest management practices in the response of forests states to climate change. First, using a spatially-implicit model with four forest states at equilibrium, we simulated warming temperature and measured five metrics of the transitory dynamic to the new equilibrium: (i) initial resilience or the reactivity of the system after climate change; (ii) local resilience or the rate in which the system recovery to equilibrium; (iii) exposure or the shift of forests states to the new equilibrium; (iv) sensitivity or the time for the state reach equilibrium after climate change and (v) vulnerability or the cumulative amount of state changes after climate change. We tested whether forest management changed these characteristics of the transitory dynamic after climate change. Second, using the same model but spatially-explicit in which we account for migration deficiency of trees and stochastic dynamics, we simulated warming temperature for a latitudinal gradient from temperate dominant to boreal dominant forests. We measured the effect of forest management practices in the migration rate of the north limit of temperate forest and the south limit of boreal forest. Our simulations and analyses suggested that...

-->

\newpage


# References

<div id="refs"></div>
\newpage


