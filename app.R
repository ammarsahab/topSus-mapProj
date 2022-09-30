library(shiny)
library(leaflet)
library(googlesheets4)
library(dplyr)
library(shinydashboard)

gs4_auth(cache = ".secrets", email = TRUE, use_oob = TRUE)

#baca sheet
vals <- reactiveValues(sheet = read_sheet("https://docs.google.com/spreadsheets/d/17dUM1t6YfnPAThvwXzHfMz9I_pEUGhTzWkE3_JI80vM/edit?usp=sharing"))
ss <- gs4_get("https://docs.google.com/spreadsheets/d/1p9h3z9gcC5Y7zioNwG-XGJs-58bOAuRa5Kh8e1iR278/edit?usp=sharing")

ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "Explore IPB Dramaga"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Cari Ruangan", tabName = "searchroom", icon = icon("building")),
                        menuItem("FAQ", tabName = "faq", icon = icon("question")),
                        menuItem("Tambah Ruangan", tabName = "addroom", icon = icon("add"))
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "searchroom",
                                tags$script('
                                $(document).ready(function () {
                                                function getLocation(callback){
                                var options = {
                                  timeout: 5000,
                                };

                                
                                navigator.geolocation.getCurrentPosition(onSuccess, onError);
                                function onError (err) {
                                Shiny.onInputChange("geolocation", false);
                                }
                                
                                function onSuccess (position) {
                                setTimeout(function () {
                                var coords = position.coords;
                                var timestamp = new Date();

                                console.log(coords.latitude + ", " + coords.longitude);
                                Shiny.onInputChange("geolocation", true);
                                Shiny.onInputChange("lat", coords.latitude);
                                Shiny.onInputChange("long", coords.longitude);
                                Shiny.onInputChange("time", timestamp)
                    console.log(timestamp);
                
                    if (callback) {
                      callback();
                    }
                  }, 1100)
                }
              }
              
              var TIMEOUT = 1000; //SPECIFY
              var started = false;
              function getLocationRepeat(){
                //first time only - no delay needed
                if (!started) {
                  started = true;
                  getLocation(getLocationRepeat);
                  return;
                }
              
                setTimeout(function () {
                  getLocation(getLocationRepeat);
                }, TIMEOUT);
                
              };
                
              getLocationRepeat();
                
            });
            '),
                                
                                
                                fluidRow(
                                  column(4,selectizeInput("ruang", label = NULL, choices = NULL)),
                                  column(4,actionButton("search", "Search", icon = icon("search")))
                                ),
                                sidebarLayout(
                                  sidebarPanel(leafletOutput("drmap")),
                                  mainPanel(
                                    tags$head(tags$style("#coordinate{color: black;
                                      font-size: 18px;
                                      font-style: italic;}"),
                                    ),
                                    tags$head(tags$style("#nama{color: black;
                                    font-size: 36px;
                                    font-style: bold;}")
                                    ),
                                    tags$head(tags$style("#lokasi{color: black;
                                    font-size: 24px;}")
                                    ),
                                    textOutput("nama"),
                                    textOutput("lokasi"),
                                    textOutput("coordinate"),
                                  )
                                )      
                        ),
                        tabItem(tabName = "faq",
                                h2("This is a test")
                        ),
                        tabItem(tabName = "addroom",
                                
                                h1("Anda di sini. Tambah Lokasi?"),
                                
                                sidebarLayout(
                                  sidebarPanel(leafletOutput("searchmap")),
                                  mainPanel(
                                    textInput("namaruangbaru", "Nama"),
                                    textInput("lokruangbaru", "Lokasi"),
                                    radioButtons("fakruangbaru", "Fakultas",
                                                 choiceNames = list(
                                                   "Fakultas Pertanian",
                                                   "Sekolah Kedokteran Hewan dan Biomedis",
                                                   "Fakultas Perikanan dan Kelautan",
                                                   "Fakultas Peternakan",
                                                   "Fakultas Kehutanan dan Lingkungan",
                                                   "Fakultas Teknologi Pertanian",
                                                   "Fakultas Matematika dan Ilmu Pengetahuan Alam",
                                                   "Fakultas Ekonomi dan Manajemen",
                                                   "Fakultas Ekologi Manusia"
                                                 ),
                                                 choiceValues = list("a","b","c",
                                                                     "d","e","f",
                                                                     "g","h","i")
                                    ),
                                actionButton("addlok", "Tambah Lokasi Ini", class = "btn-warning")
                                  )
                                )
                        )
                      )
                    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  #buat map - dengan batasan, minimum dan maximum Bujur dan Lintang di Sheet.
  output$drmap <- renderLeaflet({
    leaflet(data = vals$sheet) |> 
      addTiles() |> fitBounds(~min(Longitude), ~min(Latitude), 
                   ~max(Longitude), ~max(Latitude))
  })
  output$searchmap <- renderLeaflet({
    leaflet() |> addTiles() |>
      fitBounds(106.7,-6.6,
                106.9,-6.4)
  })
  
  observe({
    if(!is.null(input$lat)){
      lat = input$lat
      lng = input$long
      dist = 0.001
      
      leafletProxy("searchmap", 
                   data = data.frame(lat, lng)) |>
        addCircleMarkers() |>
        fitBounds(lng-dist, lat-dist,
                  lng+dist, lat+dist)
    }
  })
  
  observeEvent(input$addlok, sheet_append(ss, 
                                           data.frame(Fakultas = input$fakruangbaru,
                                                      Nama = input$namaruangbaru,
                                                      Lokasi = input$lokruangbaru,
                                                      Latitude = input$lat,
                                                      Longitude = input$long)))
  
  observe(updateSelectizeInput(session, 'ruang',  
                               choices = {vals$sheet$Nama |> unlist()}, 
                               server = TRUE))
  
  observe({
    if(!is.null(input$lat)){
      lat = input$lat
      lng = input$long
      lats = vals$sheet$Latitude
      longs = vals$sheet$Longitude
      
      leafletProxy("drmap", 
                   data = data.frame(lat, lng)) |>
        addCircleMarkers() |>
        fitBounds(min(c(lng, longs)), min(c(lat, lats)), 
                  max(c(lng,longs)), max(c(lat,lats)))
      }
  })
  #ambil room
  room <- eventReactive(input$search,{vals$sheet |> 
      filter(Nama == input$ruang)})
  
  #tambah marker
  observe({
    if(!is.null(input$lat) & !is.null(input$ruang)){
    lat = input$lat
    lng = input$long
          
    leafletProxy("drmap", 
                 data = room()) |>
      removeMarker("search") |>
      addMarkers(layerId = "search", ~Longitude, ~Latitude) |>
      fitBounds(~min(c(lng, Longitude)), ~min(c(lat, Latitude)),
                ~max(c(lng, Longitude)), ~max(c(lat, Latitude)))
    }
  })

  #masukkan nama dan lokasi ruangan
  output$nama <- renderText(room() |> select(Nama) |> unlist())
  output$lokasi <- renderText(room() |> select(Lokasi) |> unlist())
  output$coordinate <- renderText(paste(
    {room() |> select(Latitude)}, {room() |> select(Longitude)}, sep = ","
  ))
  
}

# Run the application 
shinyApp(ui = ui, server = server)