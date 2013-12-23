chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ,.!?'"

for c in chars:
    print(".charmap %i, %i" % (ord(c), 9 + chars.index(c)))

print(".charmap %i, %i" % (ord(' '), 4))
