from str_filter import antiFilter
import sys
for line in sys.stdin:
    tty_str = line

print(antiFilter(tty_str, "tty"))