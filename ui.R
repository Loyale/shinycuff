library(shiny)
library(cummeRbund)

#myDir<-"/Volumes/Odyssey/seq/lgoff/diffs/Arlotta/HiSeq/Full_diff_custom_build_2"
myDir<-system.file("extdata",package="cummeRbund")

cuff <- readCufflinks(dir=myDir)

shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Shiny Acoutrements..."),

  # Sidebar with a slider input for number of observations
  sidebarPanel(
	  selectInput("x_axis", "X axis:", 
	                  choices = samples(genes(cuff)),
					  selected = samples(genes(cuff))[1]
  ),
  	  selectInput("y_axis","Y axis:",
  					  choices = samples(genes(cuff)),
  					  selected = samples(genes(cuff))[2]
  ),
  checkboxInput(inputId = "smooth",
        label = "Add a smoothed fit",
        value = FALSE),
  textInput("geneLookup", "Find a gene:","")
  ),
  # Show a plot of the generated distribution
  mainPanel(
	h3(textOutput("caption")),
	tabsetPanel(
	      tabPanel("Scatter", 
			plotOutput("scatterPlot",width='800px',height='800px')), 
	      tabPanel("Volcano", 
		  	textInput("alpha", "Select an FDR (alpha):", 0.05),
			plotOutput("volcanoPlot",width='800px',height='800px'))
	    )
  )
))
