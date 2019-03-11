# generate distributions over time
plotdata = melt(diff_data, id.vars = c("Name", "Day"))

p = plotly_genericPlotWithOneDropdown(x = plotdata$Day, y = plotdata$value, group = plotdata$variable,
                                  dropdown = plotdata$Name)

setwd("results")
saveWidget(widget = p, "IndividualConsumption.html", selfcontained = T)
setwd("../")

# analyze top 3 per day
buildPlot = function(day) {
  subset = diff_data[Day == day]
  subset = subset[order(-Bier)]
  subset = subset[1:3]
  plotdata = subset[,.(Day, Name, Bier)]
  plotdata$Name = factor(plotdata$Name, levels = unique(plotdata$Name))
  p = ggplot(plotdata, aes(Name, Bier)) + geom_bar(stat = "identity", fill = "#028ECF") +
    scale_x_discrete("") + 
    scale_y_continuous("Liter Bier", breaks = c(0, 2, 4, 6, 8, 10), limits = c(0, 11)) + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    ggtitle(day) +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text = element_text(size = 14)) + 
    theme(axis.title.y = element_blank())
  return(p)
}

p1 = buildPlot(as.POSIXct("2019-03-02"))
p2 = buildPlot(as.POSIXct("2019-03-03"))
p3 = buildPlot(as.POSIXct("2019-03-04"))
p4 = buildPlot(as.POSIXct("2019-03-05"))
p5 = buildPlot(as.POSIXct("2019-03-06"))
p6 = buildPlot(as.POSIXct("2019-03-07"))
p7 = buildPlot(as.POSIXct("2019-03-08"))

p = plot_grid(NULL, p1, p2, p3, p4, p5, p6, p7, ncol = 8, align = "h", label_y = "Liter Bier",
              rel_widths = c(.3, rep(1, 7))) # add padding with null plot
ggsave(filename = "results/Champs.png", p, width = 16, height = 8)
