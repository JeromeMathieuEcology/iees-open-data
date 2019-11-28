# shiny app to show the open data produced by the iEES Paris lab (UMR 7618)
# created by Jerome Mathieu
# August 2019

library(shiny)
library(formattable)
library(DT)
library(dplyr)
library(shinyWidgets)
library(shinythemes)
library(leaflet)
library(htmltools)
library(shinycssloaders)


source("tab_other.r", local = TRUE)
source("tab_molecular.r", local = TRUE)
source("tab_spatial.r", local = TRUE)


ui <- fluidPage(
  theme = shinytheme("flatly"), 

  titlePanel(
    "Open Data produced by iEES Paris"
   ),
  #h4("Sorbonne Université, CNRS, INRA, IRD, Univ.Par is Diderot, U-PEC"),
  
  #tabsetPanel(
    navbarPage("iEES Open data", id="nav",
    tabMolecular,  	
    tabSpatial,
    tabOther
  )


)






server <- function(input, output) {

  # data tables ------------------
  
  
      # molecular data table 
          iees_mol <- read.csv2("iees_molecular.csv",sep=",",dec=".",encoding = "latin1")
      
          # create hyperlinks
              iees_mol$Publication <- ifelse(iees_mol$Publication == "", "-", paste0('<a href="',iees_mol$Publication,'"target="_blank">Link</a>') ) 
  
              # create hyperlinks
              iees_mol$Data<- ifelse(iees_mol$Data == "", "-", paste0('<a href="',iees_mol$Data,'"target="_blank">Link</a>') ) 
              
                      
          # remove "_" in column names
              names(iees_mol) <- gsub("_", " ", names(iees_mol))
            
          # capitalize first letter
            iees_mol[,"Type of Data"] <- as.character(iees_mol[,"Type of Data"])
            substr(iees_mol[,"Type of Data"], 1, 1) <- toupper(substr(iees_mol[,"Type of Data"], 1, 1))

            iees_mol[,"Organism"] <- as.character(iees_mol[,"Organism"])
            substr(iees_mol[,"Organism"], 1, 1) <- toupper(substr(iees_mol[,"Organism"], 1, 1))
            
      
      # other data table
      
        iees_other <- read.csv2("iees_other.csv",sep=",",dec=".",encoding = "latin1")
    
        # create hyperlinks
          iees_other$Data <- ifelse(iees_other$Data == "", "-", paste0('<a href="',iees_other$Data,'"target="_blank">Link</a>') ) 
          iees_other$Publication <- ifelse(iees_other$Publication == "", "-", paste0('<a href="',iees_other$Publication,'"target="_blank">Link</a>') ) 
          
        # remove "_" in column names
          names(iees_other) <- gsub("_", " ", names(iees_other))
      
        # capitalize first letter
          iees_other[,"Type of Data"] <- as.character(iees_other[,"Type of Data"])
          substr(iees_other[,"Type of Data"], 1, 1) <- toupper(substr(iees_other[,"Type of Data"], 1, 1))
          
          iees_other[,"Research Field"] <- as.character(iees_other[,"Research Field"])
          substr(iees_other[,"Research Field"], 1, 1) <- toupper(substr(iees_other[,"Research Field"], 1, 1))
      
          iees_other[,"Content"] <- as.character(iees_other[,"Content"])
          substr(iees_other[,"Content"], 1, 1) <- toupper(substr(iees_other[,"Content"], 1, 1))
          

      
      
    # dynamic tables ----------------

      # molecular data table
        iees_mol_ <- reactive({
          
          req(input$check_data_type_mol)
          req(input$check_org_mol)   
          
          iees_mol_ <- iees_mol %>%
            filter(
              `Year` >= input$year_mol[1],
              `Year` <= input$year_mol[2],
              input$check_data_type_mol !="",
              `Type of Data` %in% input$check_data_type_mol,                 
              input$check_org_mol !="",
              `Organism` %in% input$check_org_mol           
            )
          
        })
      
      
      # other data table
        iees_other_ <- reactive({
          
            req(input$check_data_type_other)
          req(input$check_field)   
          
          iees_other_ <- iees_other %>%
            filter(
              `Year` >= input$year_other[1],
              `Year` <= input$year_other[2],
              input$check_data_type_other !="", `Type of Data` %in% input$check_data_type_other,                 
              input$check_field !="", `Research Field` %in% input$check_field            
            )
          
        })
      

    # # dynamic output tables --------------

      # molecular data table
          output$DTtable_Mol = DT::renderDataTable({
            iees_mol_()
          }, escape = FALSE,
          extensions = 'FixedColumns',
          options = list(
            search = list(regex = TRUE, caseInsensitive = TRUE, search = ''),
            pageLength = 10,
            scrollX = TRUE,
            initComplete = JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#1A487799', 'color': '#fff'});",
              "}")#,
            #fixedColumns = list(leftColumns = 2, rightColumns = 2)
          )#, filter = 'top'
          )
      
      
      
    # other data table
        output$DTtable_Other = DT::renderDataTable({
          iees_other_()
        }, escape = FALSE,
          extensions = 'FixedColumns',
           options = list(
               search = list(regex = TRUE, caseInsensitive = TRUE, search = ''),
               pageLength = 10,
               scrollX = TRUE,
               initComplete = JS(
                 "function(settings, json) {",
                 "$(this.api().table().header()).css({'background-color': '#1A487799', 'color': '#fff'});",
                 "}")#,
               #fixedColumns = list(leftColumns = 2, rightColumns = 2)
            )#, filter = 'top'
          )
        
    
    # MAP
        
        #sites <- read.csv2("sites.csv",h=T,sep=",",dec='.')
        sites <- read.csv2("iees_spatial.csv",h=T,sep=",",dec='.',encoding = "latin1")
        
        # create hyperlinks
          sites$Publication <- ifelse(sites$Publication == "", "-", paste0('<a href="',sites$Publication,'"target="_blank">Link</a>') ) 
          sites$Data <- ifelse(sites$Data == "", "-", paste0('<a href="',sites$Data,'"target="_blank">Link</a>') ) 
        
          
        output$iees_map <- renderLeaflet({
          leaflet(sites) %>%
            #addProviderTiles(providers$Stamen.TonerLite,
            #                 options = providerTileOptions(noWrap = TRUE)
            #) 
            addTiles() %>%
            setView(5,25, zoom = 1.7)%>%
            addRectangles(lng1=sites$long_min, lat1=sites$lat_min,
                          lng2=sites$long_max, lat2=sites$lat_max,
                          popup = ~htmlEscape(Title),
                          fillColor = "transparent"
            )
        })  
    
        
        
        filtered_sites <- reactive({
          if (is.null(input$iees_map_bounds))
            return(sites[FALSE,])
          bounds <- input$iees_map_bounds
          latRng <- range(bounds$north, bounds$south)
          lngRng <- range(bounds$east, bounds$west)
          
          # subset(sites,
          #        latitude >= latRng[1] & latitude <= latRng[2] &
          #          longitude >= lngRng[1] & longitude <= lngRng[2])
          # 
          subset(sites,
                 lat_max <= latRng[2] & lat_min >= latRng[1] &
                   long_max <= lngRng[2] & long_min >= lngRng[1]
               )
        })
        
        
        
        # other data table
        output$DTspatial_table = DT::renderDataTable({
          filtered_sites()
        }, 
          escape = FALSE,
          extensions = 'FixedColumns',
          options = list(
            search = list(regex = TRUE, caseInsensitive = TRUE, search = ''),
            pageLength = 10,
            scrollX = TRUE,
            #fixedColumns = list(leftColumns = 2, rightColumns = 8),
            columnDefs = list(list(visible=FALSE, targets=c(12:17))),
            initComplete = JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#1A487799', 'color': '#fff'});",
              "}")
            )#, filter = 'top'
        )
}


# Run the application 
shinyApp(ui = ui, server = server)

