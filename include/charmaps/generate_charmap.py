chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ, .!?'"

for c in chars:
    print(".charmap %i, %i" % (ord(c), chars.index(c)))
