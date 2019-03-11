missings = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 8)

missingBeer = missings$Bier[1] - missings$Bier[2]
missingBeerPercentage = missingBeer / missings$Bier[1]
missingElse = sum(missings[1, 2:6]) - sum(missings[2, 2:6])
missingElsePercentage = missingElse / sum(missings[1, 2:6])

print(paste0("Es fehlen beim Bier ", missingBeer, "/", missings$Bier[1], 
             " Striche. Dies ergibt ", round(missingBeerPercentage, 2)*100, "%."))
print(paste0("Es fehlen bei allem anderen ", missingElse, "/", sum(missings[1, 2:6]),
             " Striche. Dies ergibt ", round(missingElsePercentage, 2)*100, "%."))
