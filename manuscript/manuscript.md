---
  title: Can forest management increases the migration rate of the eastern North American forest northward?
  author:
  date: \today
  output:
    bookdown::pdf_document2:
      fig_caption: yes
      includes:
          in_header: conf/config_md.sty
  fontsize: 12pt
  bibliography: "conf/refs.bib"
  link-citations: true
---

# Introduction
With climate change and warming temperature, we expect plant species to follow their climatic optimum, which means that temperate species in North America are expected to migrate northward.
But because trees have slow migration rate and long life-cycle, it has been predicted that the expansion of temperate and boreal forests northward will lag behind climate change. This would create a transitional situation where the forests would not be spatially distributed at their climate optimum, thus affecting their prod 9uctivity.
Here we aim to measure the potential of forest management to increase the speed of the forest migration northward.
We will use a State and Transition Model calibrated for the eastern North American forests, and we will integrate four management practices into the model to test their effect in the northward migration rate of the temperate forest (Figure \@ref(fig:model)).

- **Plantation** of temperate trees (immediatly) transforms a proportion of available stands (in regeneration state) in temperate state ($R \rightarrow T$)
- **Harvest** of boreal trees transforms a proportion of boreal stands (that are not going to be disturbed) in regeneration state ($B \rightarrow R$)
- **Thinning** of mixed forests by harvesting boreal trees reduces the probability of staying in mixed state by increasing the ability of temperate trees to exclude boreal tree by competition ($M \rightarrow T$)
- **Enrichment planting** of temperate trees in boreal stands increases the probability of invasion of temperate species in the boreal state ($B \rightarrow M$).

We used two spatial simulation approaches to test the effect of forest management practices in the response of forests states to climate change. First, using a spatially-implicit model with four forest states at equilibrium, we simulated warming temperature and measured five metrics of the transitory dynamic to the new equilibrium: (i) initial resilience or the reactivity of the system after climate change; (ii) local resilience or the rate in which the system recovery to equilibrium; (iii) exposure or the shift of forests states to the new equilibrium; (iv) sensitivity or the time for the state reach equilibrium after climate change and (v) vulnerability or the cumulative amount of state changes after climate change. We tested whether forest management changed these characteristics of the transitory dynamic after climate change. Second, using the same model but spatially-explicit in which we account for migration deficiency of trees and stochastic dynamics, we simulated warming temperature for a latitudinal gradient from temperate dominant to boreal dominant forests. We measured the effect of forest management practices in the migration rate of the north limit of temperate forest and the south limit of boreal forest. Our simulations and analyses suggested that...

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
The return time ($\Delta_{time}$) or ecosystem sensitivity \comment{}{WV: je ne suis pas certain d'être d'accord avec ce terme sensitivity} is the length in steps (each time step is equal to 5 years) of the transitory phase.
Finally, the cumulative amount of changes of the transitory phase, or ecosystem vulnerability [@Boulangeat2018], is defined as the integrated measure of all changes in the states after temperature warming, and is obtained by the integral of the states change over time ($\int S(t)dt$).


## Spatially-explicit model analysis
The spatially-explicit version of the model used a theoretical landscape (lattice) to account for environmental variability and stochastic dynamics.
The latitudinal gradient of the landscape is defined by temperature variation, whereas precipitation remains constant.
The mean annual temperature varies from TODO where temperate is dominate stand, to TODO where boreal dominates.
In the context of slow migration northward of boreal stands, our lattice focus on the southern range limit of boreal, the northern range limit of temperate, and the mixed stands ecothone.
The prevalence probability of each cell of the lattice at time $t + 1$ was calculated considering the eight neighbours cells and the environmental condition of the cell at time $t$.
The state of the current cell at time $t + 1$ is then defined in function of the multinomial distribution of the prevalence probability.
The impact of warming temperature in the landscape dynamics is included by temperature increasing of 0.11 $^{\circ}$C for each cell at each time step for the first 20 steps (100 years; RCP6).

We measured the southern range limit of boreal and the northern range limit of temperate stands at each time step over the simulation time.
The range limit of boreal and temperate stands was defined as the farthest line of the landscape in which composition dominates 70% of the lattice row.
We summed the distance between range limit with and without forest management at each time step for the whole simulation time to compute the cumulative changes in range limit (i.e. how much the range limit changes under temperature warming for managed and non-managed landscapes).

# Results

## Spatially-implicit model

Results in Figure \@ref(fig:num-res).

![Ecosystem responses along the increasing management intensity. Climatic condition is set so that the predominant state at equilibrium is boreal before the temperature warming and mixed state after. Variation of (a) asymptotic resilience $R_{\infty}$, (b) initial resilience $-R_0$, (c) exposure $\Delta_{state}$, (d) sensitivity $\Delta_{time}$, and (e) vulnerability $\int S(t)dt$ in function of plantation, harvest, thinning and enrichment practices.](img/num-result.pdf){#fig:num-res}

## Spatially-explicit model
Here I present some preliminary results about the effect of management practices on the migration rate under climate change, using the spatially explicit version of the model (figure \ref{fig:sim-result}).
The results are the mean and variance of 30 stochastic simulations repetition with management practices intensity fixed to 0.2.
As the simulated landscape is limited in latitudinal range limits, I show only the simulations with the RCP 4.5 scenario of temperature warming.

![Boreal and temperate occupancy along the environmental gradient of Québec. The results are the mean and variance of 30 stochastic simulations. The intensity of management practices (see colors in the figure legend) were fixed to 0.2, and climate change scenario to RCP 4.5. Simulation were run up to 150 steps, representing 750 years. \label{fig:sim-result}](img/sim-result.pdf)

\newpage

# Next steps

- Write first draft of the paper
  - [ ] Introduction
  - [x] Methods
  - [ ] Results
  - [ ] Discussion

- [ ] Try and optimize the model calculating by arrays (and maybe some `RCpp` functions)

- Define the simulation plan to test for
  - [ ] Pixel size
  - [ ] Range limit
  - [ ] Increase in temperature (linear, exponential...)

in the migration rate.

- [ ] Once these factors are specified, define the the simulation plan to test for the effect of management practices on the migration rate.

# References
