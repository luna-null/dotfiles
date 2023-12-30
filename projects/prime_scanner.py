def scanPrimes(n):  # n - number of primes to go up to. n > 2.
    primeSet = set()
    c = 2    # accumulator
    isPrime = True
    while len(primeSet) <= int(n):
        for i in range(1,c):
            if c % i == 0 & i == c & i == 1:
                isPrime = False
                break
        if isPrime == True:
            primeSet.add(c)
        c += 1
        isPrime = True
    return primeSet

def main():
    n = input("How many primes do you want to go up to? ")
    R = scanPrimes(n)
    print(R)
    

if __name__ == "__main__":
    main()
