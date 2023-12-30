def filter(target_str, filter_str):
    out_str_list = target_str.partition(filter_str)
    out_str = out_str_list[1]
    
    return out_str

def antiFilter(target_str, filter_str):
    out_str_list = target_str.partition(filter_str)
    out_str = out_str_list[2]
    
    return out_str

# if __name__ == "__main__":
#     print(antiFilter("bloof", "oo"))
