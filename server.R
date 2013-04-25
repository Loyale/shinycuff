library(shiny)
library(cummeRbund)

#myDir<-"/Volumes/Odyssey/seq/lgoff/diffs/Arlotta/HiSeq/Full_diff_custom_build_2"
myDir<-system.file("extdata",package="cummeRbund")

cuff <- readCufflinks(dir=myDir)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  descriptiveText <- reactive({
    paste(input$x_axis,"vs", input$y_axis,sep=" ")
  })
  
  #Find a specific Gene
  geneCalloutIDs <- reactive({
	  if (input$geneLookup != ""){
		  unique(annotation(genes(cuff))$gene_short_name[grepl(input$geneLookup,annotation(genes(cuff))$gene_short_name,ignore.case=TRUE)])
	  }
	  else{
	  	  input$geneLookup
	  }
		  
	  })
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    descriptiveText()
  })

  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  output$scatterPlot <- renderPlot({
	  print(csScatter(genes(cuff),x=input$x_axis,y=input$y_axis,labels=geneCalloutIDs(),smooth=input$smooth) + theme_bw() + coord_equal(1))
  })
  
  output$volcanoPlot <- renderPlot({
	  print(csVolcano(genes(cuff),x=input$x_axis,y=input$y_axis,alpha=as.numeric(input$alpha),showSignificant=TRUE) + theme_bw() )
  })
  
})
