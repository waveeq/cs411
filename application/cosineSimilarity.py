
import math

def get_list_cos(recipematrix, uservector):
    listcos = []
    loc = 0
    for recipevector in recipematrix:
        cos = cosine_similarity(recipevector, uservector, loc)
        listcos.append(cos)
        loc += 1
    return listcos


def cosine_similarity(recipevector, uservector, loc):
    cos = {}
    dot = 0
    lenr = 0
    lenu = 0
    i = 0
    j = len(recipevector) - 1
    while i <= j:
        dot += recipevector[i] * uservector[i]
        lenu += uservector[i] * uservector[i]
        lenr += recipevector[i] * recipevector[i]
        i += 1
    lenu = math.sqrt(lenu)
    lenr = math.sqrt(lenr)
    if lenu != 0 and lenr != 0:
        score = dot / (lenu * lenr)
    cos['recipeindex'] = loc
    cos['cosscore'] = score
    return cos


