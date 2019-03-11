saveImage = function(plotObj, name, width = 1200, height = 800) {
  plotObj = plotObj + theme(text = element_text(size = 24), axis.text = element_text(size = 20)) +
    theme(plot.margin=unit(c(0.5,0.5,0.5,1),"cm"))
  png(paste0("results/", name, ".png"), width = width, height = height)
  print(plotObj)
  dev.off()
}

plotly_genericPlotWithOneDropdown = function(x, y, dropdown, group = NULL, width = 800, height = 500, type = "line") {
  p = plot_ly(width = width, height = height)
  buttons = list()
  counters = numeric(0)
  if (!is.null(group)) dt = data.table(x = x, y = y, dropdown = dropdown, group = group)
  else dt = data.table(x = x, y = y, dropdown = dropdown)
  
  colors = RColorBrewer::brewer.pal(8, "Set2")
  # build up plot
  for (var in unique(dropdown)) {
    set = dt[dropdown == var]
    if (is.null(group)) {
      if (type == "line") p = p %>% add_lines(x = set$x, y = set$y, name = var,
                                              visible = if (length(counters) == 0) T else F,
                                              color = I(colors[1]))
      else if (type == "bar") p = p %>% add_bars(x = set$x, y = set$y, name = var,
                                                 visible = if (length(counters) == 0) T else F,
                                                 color = I(colors[1]))
      counters = c(counters, 1)
    }
    else {
      index = 1
      for (gr in unique(set$group)) {
        subset = set[group == gr]
        if (type == "line") p = p %>% add_lines(x = subset$x, y = subset$y, name = gr,
                                                visible = if (length(counters) == 0) T else F,
                                                color = I(colors[index]))
        else if (type == "bar") p = p %>% add_bars(x = subset$x, y = subset$y, name = gr,
                                                   visible = if (length(counters) == 0) T else F,
                                                   color = I(colors[index]))
        index = index + 1
      }
      counters = c(counters, n_distinct(set$group))
    }
  }
  # build up dropdown
  counters = c(0, counters)
  counters = cumsum(counters)
  counter = 1
  for (i in 1:(length(counters)-1)) {
    visibility = rep(F, sum(counters))
    visibility[(counters[i]+1):counters[i+1]] = T
    buttons[[i]] = list(method = "restyle",
                        args = list("visible", visibility),
                        label = unique(dropdown)[i])
  }
  
  p %>% layout(updatemenus = list(list(y = .9, buttons = buttons)))
}