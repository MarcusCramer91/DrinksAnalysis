groupMatching = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 9)

# check male vs female
groupdata = merge(cum_data, groupMatching, by = "Name")
groupdata = groupdata[Day == as.POSIXct("2019-03-08")]
groupdata = groupdata[!is.na(Sex)]
plotdata = melt(groupdata[,c(2:7, 9)], id.vars = "Sex")
plotdata = plotdata[, .(Average = mean(value)), .(Sex, variable)]

plotObj = ggplot(plotdata, aes(x = plotdata$variable, y = plotdata$Average, fill = plotdata$Sex)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_x_discrete("") + 
  scale_y_continuous("Durschschnittliche Liter") + 
  guides(fill=guide_legend(title = "Geschlecht")) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "MvsF")

# check teamer vs non-teamer
plotdata = melt(groupdata[,c(2:7, 10)], id.vars = "Teamer")
plotdata = plotdata[, .(Average = mean(value)), .(Teamer, variable)]
plotdata$Teamer = ifelse(is.na(plotdata$Teamer), "Kein Teamer", "Teamer")

plotObj = ggplot(plotdata, aes(x = plotdata$variable, y = plotdata$Average, fill = plotdata$Teamer)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_x_discrete("") + 
  scale_y_continuous("Durschschnittliche Liter") + 
  guides(fill=guide_legend(title = "Teamer?")) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "TeamerVsNoTeamer")
