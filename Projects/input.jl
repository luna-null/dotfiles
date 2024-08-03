function f(x)
    if x == "1"
        return "1"
    elseif x == "2"
        return "2"
    elseif x == "3"
        return "3"
    else
        return "wat"
    end
end
function main()
    x = readline()
    rawrXD = f(x)
    print(rawrXD)
end

main()
