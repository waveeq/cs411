from numba import jit
import math

@jit(nopython=True)
def get_list_cos(recipematrix, uservector):
    listcos = []
    for recipevector in recipematrix:
        cosinesimilarity = cosine_similarity(recipevector, uservector)
        listcos.append(cosinesimilarity)
    return listcos

@jit(nopython=True)
def cosine_similarity(recipevector, uservector):
    cos = 0
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
        cos = dot / (lenu * lenr)
    return cos

