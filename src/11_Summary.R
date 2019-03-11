# plot consumption by groups
plotdata = cum_data[Day == as.POSIXct("2019-03-08")]
plotdata = melt(plotdata, id.vars = c("Name", "Day"))
plotdata = plotdata[, .(total = sum(value)), variable]
plotObj = ggplot(plotdata, aes(x = "", y = total, fill = variable))+
  geom_bar(width = 1, stat = "identity") + 
  coord_polar("y", start = 0) + 
  scale_y_continuous("Liter") + 
  theme_bw() +
  guides(fill=guide_legend(title = "Getränk"))

# save image
saveImage(plotObj, "DrinkGroups")

# plot overall consumption over time
plotdata = melt(diff_data, id.vars = c("Name", "Day")) # melt into ggplot format
plotdata = plotdata[, .(value = sum(value)), .(Day, variable)] # aggregate by day
plotObj = ggplot(plotdata, aes(x = plotdata$Day, y = plotdata$value, fill = plotdata$variable)) + 
  geom_bar(stat = "identity") +
  scale_x_datetime("Datum") + 
  scale_y_continuous("Liter") + 
  guides(fill=guide_legend(title = "Getränk")) + 
  theme_bw()

# save image
saveImage(plotObj, "OverallConsumption")

# figure out top ten for alcoholics/non alcoholics
# alc
plotdata = cum_data[Day == as.POSIXct("2019-03-08")]
plotdata = melt(plotdata, id.vars = c("Name", "Day")) # melt into ggplot format
plotdata = plotdata[variable == "Bier" | variable == "Wein", .(value = sum(value)), Name] # aggregate by day
plotdata = plotdata[order(-value)]
plotdata = plotdata[1:10]
plotdata$Name = factor(plotdata$Name, levels = unique(plotdata$Name)) # guarantee sorting in plot
plotObj = ggplot(plotdata, aes(x = Name, y = value)) + geom_bar(stat = "identity", fill = "#028ECF") +
  scale_x_discrete("") + 
  scale_y_continuous("Liter") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "Top10Alc")

# non-alc
plotdata = cum_data[Day == as.POSIXct("2019-03-08")]
plotdata = melt(plotdata, id.vars = c("Name", "Day")) # melt into ggplot format
plotdata = plotdata[(variable != "Bier" & variable != "Wein"), 
                    .(value = sum(value)), Name] # aggregate by day
plotdata = plotdata[order(-value)]
plotdata = plotdata[1:10]
plotdata$Name = factor(plotdata$Name, levels = unique(plotdata$Name)) # guarantee sorting in plot
plotObj = ggplot(plotdata, aes(x = Name, y = value)) + geom_bar(stat = "identity", fill = "#028ECF") +
  scale_x_discrete("") + 
  scale_y_continuous("Liter") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveImage(plotObj, "Top10NonAlc")
