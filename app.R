library(shiny)
library(dplyr)
library(DT)
library(bslib)

# ---- Load Data ----
data <- read.csv(
  "data/raw/non-market-housing.csv",
  sep=";",
  check.names=FALSE,
  stringsAsFactors=FALSE
)

if("Clientele- Families" %in% colnames(data)){
  colnames(data)[colnames(data)=="Clientele- Families"] <- "Clientele - Families"
}

data <- data |> 
  filter(`Project Status` == "Completed")

numeric_cols <- c("Clientele - Families","Clientele - Seniors","Clientele - Other")

for(col in numeric_cols){
  data[[col]] <- as.numeric(data[[col]])
  data[[col]][is.na(data[[col]])] <- 0
}

data$Clientele <- "Mixed"
data$Clientele[data$`Clientele - Seniors`==0 & data$`Clientele - Other`==0] <- "Families"
data$Clientele[data$`Clientele - Families`==0 & data$`Clientele - Other`==0] <- "Seniors"

data$`Total Units` <- data$`Clientele - Families` +
  data$`Clientele - Seniors` +
  data$`Clientele - Other`

# ---- UI ----
ui <- page_sidebar(
  
  title = "Non-market Housing Dashboard for the City of Vancouver",
  
  theme = bs_theme(version = 5),
  
  sidebar = sidebar(
    
    width = 280,
    
    h3("Filters"),
    
    checkboxGroupInput(
      "clientele",
      "Clientele",
      choices=c("Families","Seniors","Mixed")
    ),
    
    selectizeInput(
      "br",
      "Bedrooms",
      choices=c("1BR","2BR","3BR","4BR"),
      multiple=TRUE
    ),
    
    sliderInput(
      "year",
      "Year",
      min=1971,
      max=2025,
      value=c(1971,2025),
      sep=""
    ),
    
    actionButton(
      "reset",
      "Reset Filters",
      class="btn-dark",
      style="width:100%; margin-top:10px;"
    )
  ),
  
  layout_columns(
    
    col_widths = c(12),
    
    # ---- CARD ----
    card(
      class="shadow-sm",
      style="background: linear-gradient(135deg,#5b4dd6,#8f88e6); color:white;",
      card_header("Total Buildings Count"),
      
      div(
        textOutput("total_units_card"),
        style="font-size:48px;font-weight:bold;text-align:center;padding:20px;"
      )
    ),
    
    # ---- TABLE ----
    card(
      class="shadow-sm",
      style="background:#6c6c72; color:white;",
      card_header("Buildings Summary"),
      
      DTOutput("building_table")
    )
  )
)

# ---- SERVER ----
server <- function(input, output, session){
  
  filtered_data <- reactive({
    
    df <- data
    
    if(!is.null(input$clientele)){
      df <- df |> 
        filter(Clientele %in% input$clientele)
    }
    
    df <- df |>
      filter(`Occupancy Year` >= input$year[1],
             `Occupancy Year` <= input$year[2])
    
    df
  })
  
  output$total_units_card <- renderText({
    sum(filtered_data()$`Total Units`, na.rm = TRUE)
  })
  
  output$building_table <- renderDT({
    
    filtered_data() |>
      select(`Index Number`, Name, `Occupancy Year`)
    
  },
  options = list(
    dom = "t",
    pageLength = 10
  ),
  rownames = FALSE)
  
  observeEvent(input$reset,{
    updateCheckboxGroupInput(session,"clientele",selected=character(0))
    updateSliderInput(session,"year",value=c(1971,2025))
  })
}

shinyApp(ui, server)