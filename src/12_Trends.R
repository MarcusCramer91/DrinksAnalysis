# analyze drinkers with the highest negative/positive trends
getAlpha = function(Bier, Day) {
  dt = data.table(Bier = Bier, Day = Day)
  dt = dt[order(Day)]
  dt$Day = 1:nrow(dt)
  return(lm(dt$Bier~dt$Day)$coefficients[2])
}

trends = diff_data[, .(alpha = getAlpha(Bier, Day)), Name]

# plot biggest gainers
trends = trends[order(-alpha)]
plotdata = trends[1:10]
plotdata$Name = factor(plotdata$Name, levels = unique(plotdata$Name))

plotObj = ggplot(plotdata, aes(x = Name, y = alpha)) + geom_bar(stat = "identity", fill = "#028ECF") +
  scale_x_discrete("") + 
  scale_y_continuous("Steigung (Regressionskoeffizient)") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "BiggestGainers")

# plot biggest losers
trends = trends[order(alpha)]
plotdata = trends[1:10]
plotdata$Name = factor(plotdata$Name, levels = unique(plotdata$Name))

plotObj = ggplot(plotdata, aes(x = Name, y = alpha)) + geom_bar(stat = "identity", fill = "#028ECF") +
  scale_x_discrete("") + 
  scale_y_continuous("Steigung (Regressionskoeffizient)") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "BiggestLosers")
