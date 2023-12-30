import math

def toBase(n, b, precision=8):
    k = math.floor(math.log(n,b)) + 1
    result = ""
    i = k - 1
    while i > -precision-1:
        if (len(result) == k):
            result += "."
        
        digit = math.floor((n / b**i) % b)
        n -= digit * b**i
        result += str(digit)
        i -= 1

    return result

print(toBase(2.5,2.5))

# function toBase(n, b) {
# 	k = floor(log(b, n)) + 1
# 	precision = 8
# 	result = ""

# 	for (i = k - 1, i > -precision-1, i--) {
# 		if (result.length == k) result += "."
		
# 		digit = floor((n / b^i) mod b)
# 		n -= digit * b^i
# 		result += digit
# 	}

# 	return result
# }