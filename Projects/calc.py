import math, init
# Calculates the equations with the 

def charEqCalc(pVar, qVar, initCond):
    # y''(t) + p*y'(t) + q*y(t) = 0
    pVar = float(pVar)
    qVar = float(qVar)
    discrim = pVar**2 - 4*qVar   # discriminant: math.sqrt(pVar**2 - 4*qVar) 
    quadFormula = "\nr = " + "(-(" + str(pVar) + ") +/- " + "sqrt((" + str(pVar) + ")^2 " + "- " + "4 * (" + str(qVar) + ")))" + " / 2"
    print(quadFormula)
    try:
        quadSol1 = float((-pVar + math.sqrt(discrim)) / 2)
        quadSol2 = float((-pVar - math.sqrt(discrim)) / 2)
    except:
        print("\n Complex Roots (Discriminant < 0):\n" +
        " r1 = " + str(-pVar/2) + " + " + str(math.sqrt(abs(discrim))) + "i" + "\t"
        "r2 = " + str(-pVar/2) + " - " + str(math.sqrt(abs(discrim))) + "i" + "\n"
        )
    else:
        if discrim == 0:
            print("\n One Real Root (Discriminant = 0):\n" +
            " r = " + str(quadSol1) + "\n"
            )
        else:
            print("\n Two Real Roots (Discriminant > 0):\n" +
            " r1 = " + str(quadSol1) + "\t" 
            "r2 = " + str(quadSol2) + "\n"
            )
    if discrim < 0:    # complex roots
        
        # y(t) = c1*e^(lambda*t)*cos(omega*t)+c2*e^(lambda*t)*sin(omega*t)  where r = lambda +/- omega*i, i = sqrt(-1)
        # y'(t) = c1*(lambda*e^(lambda*t)*cos(omega*t)-omega*e^(lambda*t)*sin(omega*t)) + c2*(lambda*e^(lambda*t)*sin(omega*t)+omega*e^(lambda*t)*cos(omega*t))
        # r = lambda +/- omega*i ( which equals sqrt(-1))
        lambdaVar = float((-pVar) / 2)
        omegaVar = float(math.sqrt(abs(pVar**2 - 4*qVar)) / 2)  # times i
        period = omegaVar * math.pi/2
        
        if lambdaVar > 0:
            print("The function is oscillating with increasing amplitude.\n")
        elif lambdaVar == 0:
            print("The function has a steady oscillation.\n")
        elif lambdaVar < 0:
            print("The function is oscillating with decreasing amplitude.\n")
        print(" Period = " + str(period) + "\n")
        
        e_lambda_t = "e^(" + str(lambdaVar) + "t)"
        d_e_lambda_t_dt = str(lambdaVar) + "e^(" + str(lambdaVar) + "t)"

        cos_omega_t = "cos(" + str(omegaVar) + "t)"
        d_cos_omega_t_dt = str(omegaVar) + "sin(" + str(omegaVar) + "t)" + " * (-1)"

        sin_omega_t = "sin(" + str(omegaVar) + "t)"
        d_sin_omega_t_dt = str(omegaVar) + "cos(" + str(omegaVar) + "t)"

        u_t = e_lambda_t + cos_omega_t
        du_dt = d_e_lambda_t_dt + cos_omega_t + e_lambda_t + d_cos_omega_t_dt
        
        v_t = e_lambda_t + sin_omega_t
        dv_dt = d_e_lambda_t_dt + " " + sin_omega_t + " " + e_lambda_t + " " + d_sin_omega_t_dt

        y_t =  "y(t) = " + "c1 * " + u_t + " + " + "c2 * " + v_t
        dy_dt = "dy(t)/dt = " + "c1 * " + du_dt + " + " + "c2 * " + dv_dt

        if initCond:    # Initial conditions
            t0Init, y_t0, dy_t0_dt = init.initialConditions()   
            # If t0 = is irrational, just plug it in here:
            # t0Init = math.pi/__; y_t0 = __; dy_t0_dt = __
            e_lambda_t = "e^(" + str(lambdaVar) + "t - " + str(t0Init) + ")"
            e_lambda_t0 = math.exp(lambdaVar * 0)
            d_e_lambda_t0_dt = lambdaVar * math.exp(lambdaVar * 0)

            cos_omega_t = "cos(" + str(omegaVar) + "t - " + str(t0Init) + ")"
            cos_omega_t0 = math.cos(omegaVar * 0)
            d_cos_omega_t0_dt = omegaVar * -math.sin(omegaVar * 0)

            sin_omega_t = "sin(" + str(omegaVar) + "t - " + str(t0Init) + ")"
            sin_omega_t0 = math.sin(omegaVar * 0)
            d_sin_omega_t0_dt = omegaVar * math.cos(omegaVar * 0)
            
            u_t0 = e_lambda_t0 * cos_omega_t0
            du_t0_dt = d_e_lambda_t0_dt * cos_omega_t0 + e_lambda_t0 * d_cos_omega_t0_dt
            
            v_t0 = e_lambda_t0 * sin_omega_t0
            dv_t0_dt = d_e_lambda_t0_dt * sin_omega_t0 + e_lambda_t0 * d_sin_omega_t0_dt

            y_t =  "y(t) = " + "c1 * " + u_t + " + " + "c2 * " + v_t
            dy_dt = "dy(t)/dt = " + "c1 " + du_dt + " + " + "c2 " + dv_dt
            
            y_t0 = "y(t0): " + str(y_t0) + " = " + str(u_t0) + " c1" + " + " + str(v_t0) + " c2"
            dy_t0_dt = "dy(t0)/dt: " + str(dy_t0_dt) + " = " + str(du_t0_dt) + " c1" + " + " + str(dv_t0_dt) + " c2"

            return y_t, dy_dt, y_t0, dy_t0_dt
        
        else:   # No initial conditions
            return y_t, dy_dt
    
    elif discrim == 0:  # one real root
        # y(t) = c1*e^(r*t) + c2*t*e^(r*t)
        # dy(t)/dt = c1*r*e^(r*t) + c2*(e^(r*t) + r*t*e^(r*t))
        
        rVar = -pVar / 2
        e_rt = "e^(" + str(rVar) + "t)"
        d_e_rt_dt = str(rVar) + "e^(" + str(rVar) + "t)"
        
        y1_t = e_rt
        dy1_dt = d_e_rt_dt

        y2_t = "t * " + e_rt
        dy2_dt = e_rt + " + " + "t * " + d_e_rt_dt + ")"

        y_t = "y(t) = " +  "c1 * " + y1_t + " + " + "c2 * " + y2_t
        dy_dt = "dy/dt = " + "c1 * " + dy1_dt + " + " + "c2 *" + dy2_dt

        if initCond:    # with initial conditions
            t0Init, y_t0, dy_t0_dt = init.initialConditions()
            e_rt = "e^(" + str(rVar) + "(t - " + str(t0Init) + ")"
            d_e_rt_dt = str(rVar) + "e^(" + str(rVar) + "(t - " + str(t0Init) + ")"

            e_rt0 = exp(rVar*0)
            d_e_rt0_dt = rVar * exp(rVar*0)

            y1_t0 = e_rt0
            dy1_t0_dt = d_e_rt0_dt

            y2_t0 = t0Init * e_rt0
            dy2_t0_dt = e_rt0 + t0Init * d_e_rt0_dt

            y_t = "y(t) = " +  "c1 * " + y1_t + " + " + "c2 * " + y2_t
            dy_dt = "dy/dt = " + "c1 * " + dy1_dt + " + " + "c2 *" + dy2_dt
           
            y_t0 = "y(t0): " + y_t0 + " = " + str(y1_t0) + "c1" + " + " + str(y2_t0) + "c2"
            dy_t0_dt = "dy(t0)/dt: " + dy_t0_dt + " = " + str(dy1_t0_dt) + "c1" + " + " + str(dy2_t0_dt) + "c2"
    
            return y_t, dy_dt, y_t0, dy_t0_dt
       
        else:   # No initial conditions
            return y_t, dy_dt

    elif discrim > 0:   # two real roots
        # y(t) = c1*e^(r1*t)+c2*e^(r2*t)
        r1Var = float((-pVar + math.sqrt(pVar**2 - 4*qVar)) / 2)
        r2Var = float((-pVar - math.sqrt(pVar**2 - 4*qVar)) / 2)
        
        y1_t = "e^(" + str(r1Var) + "t)"
        dy1_dt = str(r1Var) + "e^(" + str(r1Var) + "t)"

        y2_t = "e^(" + str(r2Var) + "t)"
        dy2_dt = str(r2Var) + "e^(" + str(r2Var) + "t)"

        y_t = "y(t) = " +  "c1 * " + y1_t + " + " + "c2 * " + y2_t
        dy_dt = "dy/dt = " + "c1 * " + dy1_dt + " + " + "c2 * " + dy2_dt

        if initCond:    # Initial conditions
            t0Init, y_t0, dy_t0 = init.initialConditions()
            
            y1_t = "e^(" + str(r1Var) + "(t - " + str(t0Init) + "))"
            dy1_dt = str(r1Var) + "e^(" + str(r1Var) + "(t - " + str(t0Init) + "))"
            y1_t0 = math.exp(r1Var * 0)
            dy1_t0_dt = r1Var * math.exp(r1Var * 0)


            y2_t = "e^(" + str(r2Var) + "(t - " + str(t0Init) + "))"
            dy2_dt = str(r2Var) + "e^(" + str(r2Var) + "(t - " + str(t0Init) + "))"
            y2_t0 = math.exp(r2Var * 0)
            dy2_t0_dt = r2Var * math.exp(r2Var * 0)

            y_t = "y(t) = " +  "c1 * " + y1_t + " + " + "c2 * " + y2_t
            dy_dt = "dy/dt = " + "c1 * " + dy1_dt + " + " + "c2 * " + dy2_dt

            y_t0 = "y(t0): " + str(y_t0) +  " = " + str(y1_t0) + " c1" + " + " +  str(y2_t0) + " c2"
            dy_t0_dt = "y'(t0): " + str(dy_t0) + " = " + str(dy1_t0_dt) + " c1" + " + " + str(dy2_t0_dt) + " c2"
            
            return y_t, dy_dt, y_t0, dy_t0_dt
    
        else:   # No initial conditions
            return y_t, dy_dt
    else:
        print("What did you do???")