#################################
# Define the model
#################################
model = function(t, y, params) {
	with(as.list(c(y, params)), {

		# Fraction of empty patches converted into the different states following a disturbance
		pB = alphab * (B + M)
		pT = alphat * (T + M)
		pM = pB * pT
		pB_ = pB * (1 - pT) #what is it exaclty?
		pT_ = pT * (1 - pB) #what is it exaclty?

		# Regeneration state
		R = 1 - B - T - M

		# Differential equations describing the dynamics of the state variables
		dBdt = pB_ * R + theta * (1 - thetat) * M - betat * (T + M) * B - epsB * B
		dTdt = pT_ * R + theta * thetat * M - betab * (B + M) * T - epsT * T
		dMdt = pM * R + betab * (B + M) * T + betat * (T + M) * B - theta * M - epsM * M
		list(c(dBdt, dTdt, dMdt))
		})
	}

#################################
# Local stability
#################################
get_eq = function(params, y = NULL) {

	library(rootSolve)

	# Initial conditions
	if(is.null(y)) {
		y = c(B = 0.25, T = 0.25, M = 0.25)
	}else(y = y)

	# Get the equilibrium
	eq = runsteady(y = y, func = model, parms = params, times = c(0, 1000))

	# Compute the Jacobian
	J = jacobian.full(y = eq[[1]], func = model, parms = params)

	# Stability
	ev = max(Re(eigen(J)$values)) #in case of complex eigenvalue, using Re to get the first real part

	# return equilibrium, largest eigenvalue and time to reach equilibrium
	return(list(eq = eq[[1]], ev = ev, TRE = attributes(eq)$steps))
}

#################################
# Wrapper to collect parameters for a given set of environmental conditions
#################################
logit_reverse <- function(x) exp(x) / (1 + exp(x))

get_pars = function(ENV1, ENV2, params, int) {

	logit_alphab 	= params["ab0", 1] + params["ab1", 1] * ENV1 + params["ab2", 1] * ENV2 + params["ab3", 1] * ENV1^2 + params["ab4",1]*ENV2^2 + params["ab5",1]*ENV1^3 + params["ab6",1]*ENV2^3
	logit_alphat 	= params["at0", 1] + params["at1", 1] * ENV1 + params["at2", 1] * ENV2 + params["at3", 1] * ENV1^2 + params["at4",1]*ENV2^2 + params["at5",1]*ENV1^3 + params["at6",1]*ENV2^3
	logit_betab 	= params["bb0", 1] + params["bb1", 1] * ENV1 + params["bb2", 1] * ENV2 + params["bb3", 1] * ENV1^2 + params["bb4",1]*ENV2^2 + params["bb5",1]*ENV1^3 + params["bb6",1]*ENV2^3
	logit_betat 	= params["bt0", 1] + params["bt1", 1] * ENV1 + params["bt2", 1] * ENV2 + params["bt3", 1] * ENV1^2 + params["bt4",1]*ENV2^2 + params["bt5",1]*ENV1^3 + params["bt6",1]*ENV2^3
	logit_theta		= params["th0", 1] + params["th1", 1] * ENV1 + params["th2", 1] * ENV2 + params["th3", 1] * ENV1^2 + params["th4",1]*ENV2^2 + params["th5",1]*ENV1^3 + params["th6",1]*ENV2^3
	logit_thetat	= params["tt0", 1] + params["tt1", 1] * ENV1 + params["tt2", 1] * ENV2 + params["tt3", 1] * ENV1^2 + params["tt4",1]*ENV2^2 + params["tt5",1]*ENV1^3 + params["tt6",1]*ENV2^3
	logit_epsB 		= params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3
	logit_epsT 		= params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3
	logit_epsM 		= params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3

	alphab = 1-(1-logit_reverse(logit_alphab))^int
	alphat = 1-(1-logit_reverse(logit_alphat))^int
	betab  = 1-(1-logit_reverse(logit_betab))^int
	betat  = 1-(1-logit_reverse(logit_betat))^int
	theta  = 1-(1-logit_reverse(logit_theta))^int
	thetat = 1-(1-logit_reverse(logit_thetat))^int
	epsB    = 1-(1-logit_reverse(logit_epsB))^int
	epsT    = 1-(1-logit_reverse(logit_epsT))^int
	epsM   = 1-(1-logit_reverse(logit_epsM))^int

	return(c(alphab = alphab, alphat = alphat, betab = betab, betat = betat, theta = theta, thetat = thetat, epsB = epsB, epsT = epsT, epsM = epsM))

}

#################################
# COLLECT THE TRANSITION MATRIX
#################################

	get_matrix = function(ENV1 = NULL, ENV2 = NULL, pars = NULL, eq = NULL, int = NULL) {

		if(is.null(int)) {
			int = 3
		}
		if(is.null(pars)) {
			pars = get_pars(ENV1, ENV2, params = params, int = int)
		}
		if(is.null(eq)) {
			eq = get_eq(pars)[[1]]
		}

		MAT = matrix(nr = 4, nc = 4)

		B = eq[1]
		T = eq[2]
		M = eq[3]
		R = 1 - B - M - T
		names(R) <- "R" #Renaming R because it would get "B" name instanted

		pB = pars["alphab"]*(B+M)
		pT = pars["alphat"]*(T+M)
		pM = pB*pT
		pB_ = pB*(1-pT)
		pT_ = pT*(1-pB)

		# ORDER IN THE MATRIX: R, B, M, T

		MAT[1,1] = 1-(pB_*R + pM*R + pT_*R)
		MAT[1,2] = pB_*R
		MAT[1,3] = pM*R
		MAT[1,4] = pT_*R

		MAT[2,1] = pars["epsB"]*B
		MAT[2,2] = 1 - pars["epsB"]*B - pars["betab"]*(B+M)*T
		MAT[2,3] = pars["betab"]*(B+M)*T
		MAT[2,4] = 0

		MAT[3,1] = pars["epsM"]*M
		MAT[3,2] = pars["theta"]*(1-pars["thetat"])*M
		MAT[3,3] = 1 - pars["epsM"]*M - pars["theta"]*M
		MAT[3,4] = pars["theta"]*(pars["thetat"])*M

		MAT[4,1] = pars["epsT"]*T
		MAT[4,2] = 0
		MAT[4,3] = pars["betat"]*(T+M)*B
		MAT[4,4] = 1 - pars["epsT"]*T - pars["betat"]*(T+M)*B

		# Rename Matrix col and row
		nm <- c("R", "B", "M", "T")
		rownames(MAT) <- nm
		colnames(MAT) <- nm

		return(list(eq=c(B,M,T,R),MAT=MAT))

	}
