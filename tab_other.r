tabOther <- tabPanel("Other Products",
   
    
    
    div(class="banner", 
        img(src = 'open_data.png')#, height = '372px', width = '1200px'
    ),
    
    dropdownButton(
                        checkboxGroupButtons(inputId = "check_field", 
                                             label = "Research Field",
                                             choices = c("Animal ecology","Computer science","Microbiology"),
                                             selected = c("Animal ecology","Computer science","Microbiology"),
                                             direction = "vertical", status = "primary",
                                             checkIcon = list(yes = icon("ok", 
                                                                         lib = "glyphicon"), no = icon("remove",lib = "glyphicon"))
                                             ),
                        
                        checkboxGroupButtons(inputId = "check_data_type_other", 
                                             label = "Type of Data",
                                             choices = c("Database","Tutorial","Code"),
                                             selected = c("Database","Tutorial","Code"),
                                             direction = "vertical", status = "primary",
                                             checkIcon = list(yes = icon("ok", 
                                                                         lib = "glyphicon"), no = icon("remove",lib = "glyphicon"))
                        ),
                         
                         sliderInput("year_other",
                                     "Year",
                                     min = 2000,
                                     max = 2020,
                                     value = c(2000,2019),
                                     sep=""
                         ),
                        
                        circle = TRUE, status = "primary", icon = icon("gear"), width = "300px",
                        tooltip = tooltipOptions(title = "Click to filter !")
                       
                    ),
      
      
     
  h5("Use the wheel to filter data!"),
  br(),
  br(),
  
  fluidRow(
    column(
      DT::dataTableOutput("DTtable_Other")%>% withSpinner(type=6 ), width = 12) #
  )
 
  

  
)

