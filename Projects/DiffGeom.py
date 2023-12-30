import sympy as sp

def Christoffel_Calc(g,bases,i,j,k):
    sum = 0
    for l in range(0,len(g.col(0))-1):
        sum += (1/2)*g.inv()[k,l] * (sp.diff(g[i,l],bases[j])+sp.diff(g[j,l],bases[i])-sp.diff(g[i,j],bases[l]))
    return sum
