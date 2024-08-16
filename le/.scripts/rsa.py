import math

def totient(prime1,prime2):
    totient = (prime1-1)*(prime2-1)
    return totient

def rsa(totient):
    d = 0
    for epsilon in range(1,totient):
        if epsilon*d % totient == 1:
            return d
