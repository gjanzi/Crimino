navbarPage("Crimino", collapsible = TRUE, inverse = TRUE, theme = "bootstrap.css",
           tabPanel("About",
                    sidebarLayout(
                      sidebarPanel = sidebarPanel(h1("Welcome to Crimino!"),
                                                  h5("Connecting the dots of Chicago's crime patterns."),
                                                  img(src = "Chicago.bean.png", height = 200, width = 200, align = "center")),
                      mainPanel = mainPanel(
                        tabsetPanel(
                           tabPanel("Platform", 
                                     br(),
                            p("Crimino is a platform which aims to shed light on patterns of crime in the city of Chicago. 
By making use of a dataset extracted from the Chicago Police department for the year 2020, this platform offers you the possibility to view and analyze criminal data in different formats."),

p("The general aim of Crimino is to expose patterns that could not previously be seen by the naked eye and help law enforcement distinguish connections between crime type, location and time."),

p("In addition to the overview provided in Data explorer and Interactive map, Crimino provides an advanced analysis via link prediction to try and predict crime cooccurrence.
Finally, Crimino provides a node similarity analysis to spot similarities across the wards of Chicago in terms of crime type and demographics.")),
                            tabPanel("Team",
                                     br(),
                                     p("Meet the team behind Crimino! A team of students of Business Information Management at RSM who aim to help you explore the crime network in Chicago."),
                                     br(),
                                     fluidRow(
                                       column(3, 
img(src = "Klea.png", height = 100, width = 100),
img(src = "Wesley.png", height = 100, width = 100),
img(src = "Maria.png", height = 100, width = 100),
img(src = "Jelle.png", height = 100, width = 100)),

column(4, 
p("Klea Gjana"),
p("BIM student"),
br(),
br(),
br(),
p("Wesley Kruijthof"),
p("BIM student"),
br(),
br(),
br(),
p("Maria Pelos Melo"),
p("BIM student"),
br(),
br(),
br(),
p("Jelle van der Grijn"),
p("BIM student"))
                          
                        ))))),
           ),
           tabPanel("Data Explorer",
                    p("Have you ever wondered what the most recurring crime type was in a specific location or specific point in time? Data Explorer allows you to check crime statistics for your ward in the desired date range."),
                    fluidPage(
                      tabsetPanel(
                        tabPanel("Explore the Dataset", 
                                 fluidPage (
                                   titlePanel("Data Explorer Descriptives"),
                                   
                                   sidebarLayout(
                                     
                                     sidebarPanel(
                                                p("Here you can find overall descriptives on the crime in Chicago in 2017. There are in total 254 different types of crimes happening accross 50 wards. 
                                                       In total, there are around 30.000 crime cases in more that 28.000 different specific locations")
                                              br(),
                                       tableOutput("tb.descriptives")
                                     ),
                                     
                                     mainPanel (
                                       tabsetPanel(
                                         tabPanel("Wards", plotOutput("hist.ward")),
                                         tabPanel("Crimes", plotOutput("hist.Primary.Type")),
                                         tabPanel("Crime Descriptions", plotOutput("hist.Description"))
                                       ),
                                       tableOutput("tb.locations")
                                     )
                                   )
                                 )
                                 ),
                        tabPanel("Explore Crime", 
                                 titlePanel('Data Explorer Crime Types'),
                                 sidebarLayout(
                                   sidebarPanel(
                                              p(" Through the "Data Explorer Crime Types" you can choose a crime type and check the frequency of this crime type per ward in the specified date range. 
                                                       You also have the possibility to check the total amount that this crime has happened in all wards in the specified date range under the column 'Total'."),
                                            br(), 
                                     selectInput(inputId = 'crime.type', label = 'Select Crime Trype', 
                                                 choices = c(as.vector(unique(dt.crimes$Primary.Type)), 'All Crimes')),
                                     dateRangeInput(inputId = 'daterange.crime', label = 'Select Date Range', 
                                                    start = '2017-01-01', end = '2017-12-31', format = 'yyyy-mm-dd')),
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel('Overview', 
                                                {DT::DTOutput('summarytable.crime')}),
                                       tabPanel('Chart',
                                                {plotOutput('hist.crime')})
                                     )))),
                        tabPanel("Explore Wards", 
                                 titlePanel('Data Explorer Wards'),
                                 sidebarLayout(
                                   sidebarPanel(
                                              p(" Through the "Data Explorer Wards" you can choose a ward and check the crime types that have happened in that ward in the specified date range.
                                                       You also have the possibility to check how many times each crime type has happened and the total amount of that type of crime for the chosen ward.")
                                            br(),
                                     selectInput(inputId = 'ward', label = 'Select Ward', choices = c(as.vector(unique(dt.crimes$Ward)), 'All Wards')),
                                     dateRangeInput(inputId = 'daterange', label = 'Select Date Range', start = '2017-01-01', end = '2017-12-31', format = 'yyyy-mm-dd')),
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel('Overview', 
                                                {DT::DTOutput('summarytable')}),
                                       tabPanel('Chart',
                                                {plotOutput('hist')})
                                     ))))
                      ))),
           tabPanel("Interactive Map",
                    fluidPage(
                      h1("Interactive Map"),
                      p("In order to get a feel of what the data looks like, feel free to use this interactive map, where crimes are plotted on the map of chicago by a simplified version of primary crime type.
                        The crimes plotted on the map are a random sample of 20,000 crimes taken from the original dataset of 264,925 crimes.
                        The top graph shows all individual crimes plotted on a raster indicating the 50 wards.
                        The bottom graph is a choropleth graph aggregating the number of crimes by ward, creating a heatmap."),
                      sidebarLayout(
                        sidebarPanel(
                          dateRangeInput("Date", label = h4("Period"), start = "2017-03-01", end = "2017-10-31", 
                                         min = "2017-01-01", max = "2017-12-31"),
                          sliderInput("Ward", label = h4("Ward"), min = 1, max = 50, value = c(1, 50)),
                          checkboxGroupInput("Arrest", label = h4("Someone was arrested"), choices = c("Yes", "No"), 
                                             selected = c("Yes", "No")),
                          checkboxGroupInput("Domestic", label = h4("Domestic incident"), choices = c("Yes", "No"), 
                                             selected = c("Yes", "No")),
                          checkboxGroupInput("Primary.Type", label = h4("Primary crime type"), choices = l.Type.Highlight, 
                                             selected = l.Type.Highlight),
                          #checkboxGroupInput("Location.Description", label = h4("Location"), choices = l.Location.Description, 
                          #                   selected = l.Location.Description, inline = TRUE),
                        ),
                        mainPanel(
                          h2("Map showing individual crimes"),
                          leafletOutput("m.crimes", height = 500),
                          br(),
                          h2("Heatmap of crimes by ward"),
                          leafletOutput("m.crimes.choropleth", height = 500),
                        )
                      )
                    )
           ),
           tabPanel("Network Exploration",
                    p("In the following tabs you can find descriptive statistics on two projections of the crime-location network. The first network focuses on the crime types that are connected through common wards. 
                      The second network depicts the wards that are connected as a consequence of having common crime types happening in them.
The statistics below show the basic nature of the network with a degree distribution and a general summary.
Descriptive statistics are shown for both the above-mentioned projections: the crime type network and the location/wards network.
"),
                    fluidPage(
                      tabsetPanel(
                        tabPanel("Network of Crimes", 
                                 titlePanel('Network Exploration'),
                                 sidebarLayout(
                                   sidebarPanel(
                                     h2("Showing bipartite projection"),
                                     selectInput(inputId = 'node', label = 'Select Location Varibale', choices = c('District', 'Ward'), selected = 'District'),
                                     selectInput(inputId = 'edge', label = 'Choose Edges', choices = c('Crime Type', 'Location'), selected = 'Crime Type'),
                                     #sliderInput(inputId = 'degree', label = 'Select Degree Range', min = 0, max = 6000, value = 10),
                                     #dateRangeInput(inputId = 'daterange', label = 'Choose a Date Range', start = '2017-01-01', end = '2017-12-31', startview = 'month', separator = ' to '),
                                     selectInput(inputId = 'centrality', label = 'Select Centrality Measure', choices = c('Degree', 'Closeness Centrality', 'Betweenness Centrality', 'Eigenvector Centrality'), selected = 'Degree')),
                                   mainPanel(   
                                     threejs::scatterplotThreeOutput('graph'),
                                     #      DT::DTOutput("networksummary"),
                                     tableOutput("centralitysummary")
                                   ))
                                 ),
                        tabPanel("Network of Wards")
                      ))), 
           tabPanel("Advanced Analytics")
)
