library(shiny)
library(shinyjs)
library(DT)
library(shinyjqui)
library(ECharts2Shiny)
library(leaflet)
library(ggplot2)
library(plotly)


shinyUI(
  fluidPage(useShinyjs(),
  h3("Circuit Analysis App - MLPQ"),
  sidebarPanel(

    fileInput("inputfile","Upload PreQual Results Spreadsheet",accept=c('.xlsx')), # Reference the file using this name
    #disabled 
    #selectInput("input2","How do you want to include Fixed Wireless (2PiFi)",choices = c("Best Speed/ Max Coverage","For sites with 4G only", "Stand alone option for comparison")),
    numericInput("input3", "Duration in months", value = 36, min = 12, max = 60, step =12),
    selectInput("input4","Spectrum Analysis - New or Existing sites",choices = c("New","Existing")),
    numericInput("input6_1", "Minimum Download Speed in Mbps", value = 10, min = 0.001, step =1),
    numericInput("input6_2", "Minimum Upload Speed in Mbps", value = 5, min = 0.001, step =1),
    checkboxInput("input8","Is the traffic from stores coming to Hughes NOC?",value = FALSE),
    #either it splits to internet or goes to customer DC via Hughes NOC
    checkboxInput("input9","Add NRC charges as monthly recurring?",value = FALSE),
    orderInput(inputId = 'input10', label = 'Rearrange Technology Choices', items = c('Asym Fiber','Fiber', 'Cable','DSL')),
    br(),
    actionButton("analysis", "Start Analysis", icon("paper-plane"), 
                 style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
    downloadButton('download', "Download Results"), 
    width = 3),
  mainPanel(
    loadEChartsLibrary(),    
    tags$head(
      tags$style(
        HTML(".shiny-notification {
             height: 50px;
             width: 400px;
             position:fixed;
             top: calc(50% - 50px);;
             left: calc(60% - 400px);;
             }
             "
        )
        )
        ),

    tabsetPanel(id="tabs",
                tabPanel("Summary",br(),DT::dataTableOutput("cov_stats"),br(), leafletOutput("Map1")),
                tabPanel("Technology Summary",br(),DT::dataTableOutput("tech_summ"),br(), br(),
                         h3("Technology Distribution", align = "center"), br(),br(),
                         tags$div(id="testTechSumm",style="width:50%;height:400px;",align = "center"),
                         deliverChart(div_id = "testTechSumm"),
                         plotlyOutput("plot_BestTech", width = "70%", height = "500px")),
                tabPanel("Min Speed Summary",br(),DT::dataTableOutput("cost_summ"),br(),br(),
                         h3("Technology Distribution", align = "center"), br(), br(),
                         tags$div(id="testSpeedCostSumm", style="width:50%;height:400px;", align = "center"),
                         deliverChart(div_id = "testSpeedCostSumm"), 
                         plotlyOutput("plot_MinCost", width = "80%", height = "500px")),
                tabPanel("Coverage Summary",br(),DT::dataTableOutput("cov_summ"),br(), br(),
                         h3("Technology Distribution", align = "center"), br(), br(),
                         tags$div(id="testCovSumm", style="width:50%;height:400px;", align = "center"),
                         deliverChart(div_id = "testCovSumm"), 
                         plotlyOutput("plot_MaxCov", width = "80%", height = "500px")),
                navbarMenu("More",
                           tabPanel("Wide Format",br(), DT::dataTableOutput("WideFormat")),
                           tabPanel("Long Format",br(), DT::dataTableOutput("LongFormat")),
                           tabPanel("High Speed Options",br(),DT::dataTableOutput("high_speed_options")),
                           tabPanel("Technology Details",br(),DT::dataTableOutput("technology_details")),
                           tabPanel("Min Speed Details",br(),DT::dataTableOutput("cost_details")),
                           tabPanel("Coverage Details",br(),DT::dataTableOutput("cov_details"))
                          )
                          )
                          )
                          )
)
