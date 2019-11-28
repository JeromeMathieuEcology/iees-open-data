tabMolecular <- tabPanel("Molecular Data",

                           
                           div(class="banner", 
                            img(src = 'open_data.png')#, height = '372px', width = '1200px'
                           ),
                         
                           dropdownButton(
                             
                             checkboxGroupButtons(inputId = "check_org_mol",
                                                  label = "Organism",
                                                  choices = c("Earthworm"),#,"Microorganism","Plant","Fungi"
                                                  selected = c("Earthworm"),#,"Microorganism","Plant","Fungi"
                                                  direction = "vertical", status = "primary",
                                                  checkIcon = list(yes = icon("ok",lib = "glyphicon"),
                                                                   no = icon("remove",lib = "glyphicon"))
                             ),
                             
                             checkboxGroupButtons(inputId = "check_data_type_mol", 
                                                  label = "Type of Data",
                                                  choices =  c("CO1","microsatellites","CO1, 16S, ITS2, 28S","multilocus"),
                                                  selected = c("CO1","microsatellites","CO1, 16S, ITS2, 28S","multilocus"),
                                                  direction = "vertical", status = "primary",
                                                  checkIcon = list(yes = icon("ok",lib = "glyphicon"),
                                                                   no = icon("remove",lib = "glyphicon"))
                             ),
                             
                             sliderInput("year_mol",
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
                               DT::dataTableOutput("DTtable_Mol")%>% withSpinner(type=6 ), width = 12)
                           )
)
