library(shiny)
library(ggplot2)
#library(htmlwidgets)
library(plotly)
library(shinycustomloader)
library(markdown)

library(DT)
library(tumorcomparer)

# Common code goes in global.R

shinyUI(
  navbarPage("TumorComparer",
             header = list(tags$head(includeScript("www/js/google-analytics.js"))),
             tabPanel("Pre-Computed Analysis",
                      sidebarLayout(
                        sidebarPanel(
                          width=3,
                          selectInput("preComputedType", "Cancer Type", choices=tcgaTypes)
                        ),
                        mainPanel(
                          h3("Results Plot"),
                          div(align="left", plotlyOutput("preComputedPlot", height=600, width=600)), 
                          h3("Results Table"),
                          downloadLink("preComputedDownload", "Download Table as Tab-Delimited File"),
                          DT::dataTableOutput("preComputedTable")
                        )
                      )
             ),
             tabPanel("User Data Analysis",
                      sidebarLayout(
                        sidebarPanel(
                          width=3,
                          fileInput('datasetFile', 'Choose Dataset File',
                                    accept=c('application/zip', '.zip')),
                          numericInput("default_weight", "Default (Background) Weight:", 0.01, min = 0, max = 100, step = 0.01),
                          helpText(br(), a(href="read_data_for_running_tc.zip", 
                                           target="_blank", download="read_data_for_running_tc.zip", "Sample Rectum Adenocarcinoma (READ) Dataset (.zip)"))
                        ),
                        mainPanel(
                          # Results showing in Tabs (can use navlistPanel to show on left)
                          tabsetPanel(
                            tabPanel(
                              "Ranked Results",
                              h3("Results Plot"),
                              div(align="left", 
                                  withLoader(plotlyOutput("userPlot", height=600, width=600), type="html", loader="loader3")
                              ), 
                              h3("Results Table"),
                              downloadLink("userDownload", "Download Table as Tab-Delimited File"),
                              withLoader(DT::dataTableOutput("userTable"), type="html", loader="loader3")
                            ),
                            tabPanel(
                              "MDS Plot",
                              p("Tumors: Small blue points; Cell Lines: Labeled points; See documentation for more details"),
                              textOutput("userStress"), 
                              withLoader(plotlyOutput("userMdsPlot", height=600, width=600), type="html", loader="loader3")
                            )
                          )
                        )
                      )
             ),
             tabPanel("About",
                      includeMarkdown("www/files/about.md"),
                      h1("Version"),
                      p(paste0("TumorComparer: ", packageVersion("tumorcomparer")))
             )
  )
)
