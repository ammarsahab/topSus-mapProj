#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

renv::use(
  "shiny@1.7.2",      
  "leaflet@2.1.1",
  "googlesheets4@1.0.1",
  "dplyr@1.0.10"
)

library(shiny)
library(leaflet)
library(googlesheets4)
library(dplyr)

gs4_auth(cache = ".secrets", email = TRUE, use_oob = TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Masukkan Nama Ruangan"),
    fluidRow(
      column(4,textInput("ruang",NULL)),
      column(4,actionButton("search", "Search", icon = icon("search")))
    ),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(leafletOutput("drmap"))
        ,
      
      # Show a plot of the generated distribution
      mainPanel(
        textOutput("coordinate"),
        textOutput("nama"),
        textOutput("lokasi")
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    #baca sheet
    sheet <- reactive(read_sheet("https://docs.google.com/spreadsheets/d/17dUM1t6YfnPAThvwXzHfMz9I_pEUGhTzWkE3_JI80vM/edit?usp=sharing"))
    
    #buat map - dengan batasan, minimum dan maximum Bujur dan Lintang di Sheet.
    output$drmap <- renderLeaflet({
      leaflet(data = sheet()) |> 
        addTiles() |> fitBounds(~min(Longitude), ~min(Latitude), 
                                ~max(Longitude), ~max(Latitude))
    })

    #ambil room
    room <- eventReactive(input$search,{sheet() |> filter(Nama == input$ruang)})
    
    #tambah marker
    observe({
      leafletProxy("drmap", data = room()) |>
        addMarkers()
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
