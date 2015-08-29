#inventory screen charmap
#chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789, .!?'"

#standard charmap
chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ, .!?'"

for c in chars:
    print(".charmap %i, %i" % (ord(c), chars.index(c)))
