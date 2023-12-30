import math, calc, init

# This is for inputting second-order linear homogenous differential equations and outputting answers to them

# Inputting Diff Equation
def inputVariables():
    print("\nFor some 2nd Order Linear Homogenous Diff Eq: \n\ny`` + py` + q = 0,"
     + " There exists some solution \n\ny1 = e^(r1*t),\ty2 = e^(r2*t)\n", sep="")
    
    # Inputs
    pVar = input("p = ")
    qVar = input("q = "); print()

    print("With this, the solution y = c1*y1 + c2*y2 also exists.")

    initConditions = input("Are there initial conditions? ").lower()
    if initConditions == "y" or initConditions == "yes" or initConditions == "true" or initConditions == "1":
        initCond = True
        return pVar, qVar, initCond
    else:
        initCond = False
        return pVar, qVar, initCond

def charEqInit(y1func, y2func, y_t0Func, dy_t0Func, y_t0Eval, dy_t0Eval):
    print("\nSolutions:\n")
    print("y1 =" + y1func)
    print("y2 =" + y2func + "\n")

    print("\nTherefore:\n")
    print(y_t0Func)
    print(dy_t0Func + "\n")

    print("\nOr:\n")
    print(y_t0Eval)
    print(dy_t0Eval + "\n")

# def charEqNoInit(y1func, y2func):
#     print("\nSolutions:\n")
#     print("y1 = " + y1func)
#     print("y2 = " + y2func + "\n")
#     print("\nTherefore:\n")
#     print("y = " + y1func + " + " + y2func)

def main():
    pVar, qVar, initCond = inputVariables()
    if initCond:    
        # If the initial condition is irrational, 
        # it's better to put it into calc.py on its own.
        # I haven't created a way to sort irrational numbers yet
        y_t, dy_dt, y_t0, dy_t0_dt = calc.charEqCalc(pVar, qVar, initCond)
        # charEqInit(y1func, y2func, y_t0Func, dy_t0Func, y_t0Eval, dy_t0Eval)
        print("",
            y_t, "",
            dy_dt,
            "\n",
            y_t0,
            dy_t0_dt,
            "",
            sep = "\n"
        )
    else:
        y_t, dy_dt = calc.charEqCalc(pVar, qVar, initCond)
        # charEqNoInit(y1func, y2func)
        print(
            y_t,
            dy_dt,
            "\n",
            sep = "\n"
        )
    
main()