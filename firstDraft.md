---
  title: Can forest management increases the migration rate of the eastern North American forest northward?
  author:
  date: \today
  output:
    bookdown::pdf_document2:
      fig_caption: yes
  fontsize: 12pt
  bibliography: "/Users/wvieira/Documents/Mendeley_bibtex/thesis.bib"
  header-includes:
    - \usepackage{setspace}
    - \usepackage{amsmath}
    - \linespread{1.25}
    - \usepackage{hyperref}
    - \hypersetup{
        colorlinks = true,
        allcolors=[rgb]{0,0.4,0.5},
      }
---

# Introduction
With climate change and warming temperature, we expect plant species to follow their climatic optimum, which means that temperate species in North America are expected to migrate northward.
But because trees have slow migration rate and long life-cycle, it has been predicted that the expansion of temperate and boreal forests northward will lag behind climate change. This would create a transitional situation where the forests would not be spatially distributed at their climate optimum, thus affecting their productivity.
Here we aim to measure the potential of forest management to increase the speed of the forest migration northward.
We will use a State and Transition Model calibrated for the eastern North American forests, and we will integrate four management practices into the model to test their effect in the northward migration rate of the temperate forest (figure \ref{fig:model}).

- **Plantation** of temperate trees (immediatly) transforms a proportion of available stands (in regeneration state) in temperate state ($R \rightarrow T$)
- **Harvest** of boreal trees transforms a proportion of boreal stands (that are not going to be disturbed) in regeneration state ($B \rightarrow R$)
- **Thinning** of mixed forests by harvesting boreal trees reduces the probability of staying in mixed state by increasing the ability of temperate trees to exclude boreal tree by competition ($M \rightarrow T$)
- **Enrichment planting** of temperate trees in boreal stands increases the probability of invasion of temperate species in the boreal state ($B \rightarrow M$).

\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{img/model_equation_fm.pdf}
  \caption{State and Transition Model and the integrated forest management practices in red.}
  \label{fig:model}
\end{figure}

# Methods

## Integrating forest management
Using the State and Transition Model parameterized for the eastern North American forest (Vissault et al. submitted), we integrated the four management practices presented in the introduction.
The rational of these four management options is to favour the spread of the temperate forest when the climate context allows temperate tree regeneration. 

\comment[IB] keep the same order than in the intro

### Plantation of temperate stands
Succession from regeneration stands to either boreal, mixed or temperate is a function of the capacity of boreal and temperate species to establish ($\alpha_B$ and $\alpha_T$), and the proportion of neighbouring stands.
Plantation practice increases the probability of regeneration stands to become temperate $P(T|R)$.
It gets a proportion of available regeneration stands, and convert it to temperate, reducing then the probability that regeneration stands become either boreal or mixed.
This proportion of regeneration stands is not available anymore for natural succession.
Plantation thus involves an additional parameter $p$ that modifies the following probabilities:

\begin{align}\label{eq:plantation}
  $P(T|R)$ &= $[\alpha_T (T+M) \times (1-\alpha_B (B+M))] \times (1 - p) + p$ \\
  $P(B|R)$ &= $[\alpha_B (B+M) \times (1-\alpha_T (T+M))] \times (1 - p)$ \\
  $P(M|R)$ &= $[\alpha_T (T+M) \times \alpha_B (B+M)] \times (1 - p)$
\end{align}

where $p$ is the proportion of R stands that are managed per time step.

Note that when $p=0$, the natural dynamic occurs and when $p=1$, $P(T|R)=1$,  $P(B|R)=P(M|R)=0$

### Harvest

add $h$ to the disturbance of boreal stands

$h$ is a proportion of boreal stands 

### Enrichment planting

Colonization (invasion) of temperate species on boreal stands is a function of the capacity of temperate species to colonize $\beta_T$, and the proportion of neighbouring stands of mixed and temperate. This only applies to stands that are not disturbed: $P(M|B) = \beta_T(T + M)(1 - \epsilon)$.
Enrichment planting of temperate species on boreal stands increases the probability of boreal stands to become mixed.
It gets a proportion of B stands available to colonization (not disturbed), and convert it in mixed stands by planting temperate trees.
The colonization probability of temperate species on boreal stands after enrichment planting adds a parameter $e$ to the model:

\begin{align}\label{eq:enrichment}
  $P(M|B)$ &= $(1- \epsilon) \times [\beta_T(T + M) \times (1-e) + e]$
\end{align}

Where $e$ is the proportion of available boreal stands (ie, not disturbed) that are enriched at each time step. When $e=0$, the natural dynamic occurs, when $e=1$, $P(M|B)= 1- \epsilon$.

### Thinning of boreal trees in mixed stands
The natural probability of temperate species to exclude boreal ones depends on the probability of mixed to be unstable $\theta$ and the ratio of competitive ability between temperate and boreal species, $\theta_T$.
Thinning of boreal species in mixed stands can increase the probability of mixed stands to become temperate by two different ways.

First, thinning of boreal species should decrease the stability of the mixed stand ($P(M|M) = 1-\theta$), thus increase $\theta$:

$$\theta_{m} = [\theta \times (1 - s1)] + s1$$.

Second, selective logging of boreal species in mixed stands should increase the ability of temperate species to exclude boreal ones by competition:

$$\theta_{T, m} = [\theta_{T} \times (1 - s2)] + s2$$

It is unclear if we need to distinguish between the two parameters. The rational is that the proportion $s1$ of mixed stands that are managed this way are directly converted into T. It means that $s2$ should at least be equal to $s1$. $s2$ can be greater than $s1$ if selective logging further boost the competitively (fitness) of temperate species. For a parsimonious approach, it seems reasonable to set $s1=s2$.

These modifications directly affect $P(T|M)$ and $P(B|M)$.
$s$ is the proportion of mixed stands that are available (not disturbed) and where thinning is applied, per time step. When $s=1$, $P(T|M) = 1$ and $P(B|M)=0$.

## Climate change scenarios
Three scenarios of climate change are implemented in the model, RCP 4.5, RCP 6 and RCP 8.5 which increases mean annual temperature in 1.8, 2.2 and 3.7 $^{\circ}$C, respectively.
The increase in temperature happens in four different ways: stepwise, linear, exponential, logarithmic (just stepwise and linear are implemented so far).

For the analytical analysis of the model (when the model is evaluated at equilibrium at a specific environmental condition), climate change is considered using initial state and parameters in function of a determined climate condition.
For instance, the model starts with initial state representing the equilibrium of a given environment condition $x$, but using parameters of a given environment $y$, in which the difference between $x$ and $y$ represents the increase in temperature.

For the spatially explicit version of the model, each row of the theoretical landscape has a fixed climate condition.
For each increased step of the simulation, the climate condition will also increase following one of the RCP scenarios.
For simulations that last more than 100 years, the incrase in temperature occurs up to 100 years to respect the forecast period of climate change, and then remains constant.

## Analytical analysis
To test the effect of forest management practices in increase the migration rate northward, we first solve the model analytically to equilibrium.
Using this approach under climate change scenarios, we can test the effect of forest management practices in two main outputs.
First, with the unstable condition in the model due climate change, we can numerically approximate the time to reach equilibrium (TRE), and test if this time changes with management practices.
Second, different intensities of forest management have a different state proportion at equilibrium.
With this interaction, we can test the impact of management practices in the local resilience, using the largest real part of the Jacobian matrix.

The analytical analysis of the effect of management practices can be visualized in two ways.
First, for a determined intensity of management and climate change, we can see the dynamic of the state proportion over time (figure \ref{fig:dynamic}).
In the figure \ref{fig:dynamic} example, the dynamic starts with equilibrium of environmental condition for a boreal domain.
In the left panel we see the dynamic over time without temperature change while in the right panel with temperature change.
Further information are the time to reach equilibrium (TRE), the resilience at final equilibrium (Ev) and the euclidian distance between the initial and the final state proportion ($\Delta$Eq).

\begin{figure}[h]
  \centering
  \includegraphics[width=1\textwidth]{img/dynamic}
  \caption{Temporal dynamic of the State and Transition model with management practices. The left panel represents the dynamic before climate change and right after climate change. TRE is time to reach equilibrium; Ev is the local equilibrium resilience; $\Delta$Eq is the euclidian distance between initial and final state proportion.}
  \label{fig:dynamic}
\end{figure}

The second way to visualize the effect of management practices in the model is, for a given climate change scenario and a given management practice, the interaction between management intensity and the outputs of the model.
Figure \ref{fig:summary} is an example for the plantation practice under the RCP4.5 scenario in which shows the effect of management intensity in TRE, Ev and state proportion at equilibrium.

\begin{figure}[h]
  \centering
  \includegraphics[width=1\textwidth]{img/summary}
  \caption{Effect of forest management in time to reach equilibrium (left), local resilience (centre) and state proportion at equilibrium (left).}
  \label{fig:summary}
\end{figure}

## Simulation analysis
To spatially explicit the analytical results, we used a theoretical landscape to account for environmental variability and stochastic dynamics.
The latitudinal gradient of the landscape is defined by temperature variation, whereas precipitation remains constant.
In the context of slow migration northward of boreal stands, our landscape focus on the range limit between boreal, mixed and temperate stands (figure \ref{fig:initLand}).
The prevalence probability of each cell of the landscape at time $t + 1$ was calculated considering the eight neighbours cells and the environmental condition of the cell at time $t$.
The state of the current cell at time $t + 1$ is then defined in function of the multinomial distribution of the prevalence probability.

\begin{figure}[h]
  \centering
  \includegraphics[width=1\textwidth]{img/initLand}
  \caption{Initial landscape ranging from -1 to 5.7 $^{\circ}$C. Each cell has an area of 1 km$^2$. On the left in dark blue is the boreal domain; on the right in orange the temperate domain, and in between is dark green the mixed stands. Regeneration are the black cells. For easy viewing, the landscape has cells of 5 km$^2$.}
  \label{fig:initLand}
\end{figure}

With the landscape varying in function of climate change and forest management, we can analyze two outputs.
First, for each time step we can measure the proportion of each state composition and how it varies over time.
Second, by defining a range limit of each forest composition, we can measure the migration rate over time.
The range limit of each composition was defined as the farthest line of the landscape in which composition dominates 70% of the line (I'm still analyzing the sensitivity for this value).
Dividing the different of range limit from the beginning to the end of the simulation, we get a migration rate of the composition over time.

# preliminary results

## Analytical analysis
The analytical analysis of the impact of forest management in the state and transition model have a variety of inputs and outputs.
As inputs, it is possible to test different scenarios of climate change and different practices of management, its intensity and the interaction between each practice.
As outputs, one can measure the time to reach equilibrium, the local resilience, and the probability of occupancy.
In this context, I developed an online application where you can test for all the possibilities and compare the results of the analytical analysis.
This is the [link](https://willvieira.shinyapps.io/shiny_managementstm/) for the online App, and this is the [link](https://github.com/willvieira/shiny_STM-managed) for the source code.

## Simulation analysis
Here I present some preliminary results about the effect of management practices on the migration rate under climate change, using the spatially explicit version of the model.
The results are preliminary because I show only one repetition per simulation, while the model is stochastic.
As the simulated landscape is limited in latitudinal range limits, I show only the simulations with the RCP 4.5 scenario of temperature warming.

Looking at a fixed intensity of 0.2 for the management practices, plantation and enrichment planting were effective to increase the migration rate of boreal stands northward (figure \ref{fig:res1}a and d).
Thinning was effective to increase the northward migration rate of temperate, but resulted in a reduction of mixed stands as boreal kept stable (figure \ref{fig:res1}c).
Harvest was not effect to reduce boreal stands and allow the mixed composition to migrate northward (figure \ref{fig:res1}b).
The figure \ref{fig:res2} shows the increase in management practices from 10% to 60%.

\begin{figure}[h]
  \centering
  \includegraphics[width=1\textwidth]{img/res1.pdf}
  \caption{Range limit of boreal (dark green) and temperate (orange) composition varying through time under RCP 4.5 with management intensity of 0.2. Dashed lines represent simulation not managed while continuous line the landscape was management for one of the four management practices. The range limit of each composition was defined when the farthest line had more than 70\% of the composition.}
  \label{fig:res1}
\end{figure}

\begin{figure}[h]
  \centering
  \includegraphics[width=1\textwidth]{img/res2.pdf}
  \caption{Range limit of boreal (dark green) and temperate (orange) composition varying through time under RCP 4.5. Dashed lines represent simulation not managed while continuous line the landscape was management for one of the four management practices. For the continuous lines, the width of the lines represents the intensity of forest management: 1, 10, 40, 60, 80\%. The range limit of each composition was defined when the farthest line had more than 70\% of the composition.}
  \label{fig:res2}
\end{figure}

\newpage

# Next steps

- Write the a very first draft of the paper with ideas of introduction, results and discussion
- Try and optimize the model calculating by arrays (and maybe some `RCpp` functions)
- Define the simulation plan to test for
  - Pixel size
  - Range limit
  - Increase in temperature (linear, exponential...)

in the migration rate

- Once these factors are specified, define the the simulation plan to test for the effect of management practices on the migration rate.
