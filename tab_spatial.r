tabSpatial <- tabPanel("Spatial Data",

  #tags$head(
    includeCSS("styles.css"),
  #  ),
    
  
  div(class="banner2", 
      img(src = 'open_data.png')#, height = '372px', width = '1200px'
  ),
  
  div(class="fig-container",
      div(class="fig",
        #leafletOutput("iees_map", width="100%", height="60%")
          leafletOutput("iees_map", width = 600, height = 300)%>% withSpinner(type=6 )
      )
  ),
  br(),
  fluidRow(
    column(
      DT::dataTableOutput("DTspatial_table"), width = 12)#%>% withSpinner(type=6 )
    )
)

