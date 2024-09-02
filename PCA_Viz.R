library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

# Writing a function to generate random data
generate_random_data <- function(n_points, correlation = 0) {
  x <- runif(n_points, 0, 100)
  y <- correlation * x + sqrt(1 - correlation^2) * runif(n_points, 0, 100)
  data.frame(x = x, y = y)
}

# Another function to calculate the PCA
calculate_pca <- function(data) {
  pca_result <- prcomp(data, center = TRUE, scale. = FALSE)
  
  # Extract mean and principal components
  mean_point <- pca_result$center
  pc1 <- pca_result$rotation[, 1] * sqrt(pca_result$sdev[1])
  pc2 <- pca_result$rotation[, 2] * sqrt(pca_result$sdev[2])
  
  list(
    mean_point = mean_point,
    pc1 = pc1,
    pc2 = pc2,
    scores = pca_result$x,
    variance_explained = pca_result$sdev^2 / sum(pca_result$sdev^2)
  )
}

# UI side
ui <- fluidPage(
  titlePanel("Interactive PCA Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("n_points", "Number of Points:", 
                  min = 10, max = 200, value = 50, step = 10),
      sliderInput("correlation", "Correlation between X and Y:", 
                  min = -1, max = 1, value = 0, step = 0.1),
      actionButton("regenerate", "Regenerate Data"),
      checkboxInput("show_mean", "Show Mean Point", value = TRUE),
      checkboxInput("show_pc1", "Show First Principal Component", value = TRUE),
      checkboxInput("show_pc2", "Show Second Principal Component", value = TRUE),
      checkboxInput("show_transformed", "Show Transformed Data", value = FALSE),
      hr(),
      htmlOutput("explanation")
    ),
    
    mainPanel(
      plotlyOutput("pca_plot"),
      verbatimTextOutput("variance_explained")
    )
  )
)

# Server side
server <- function(input, output, session) {
  # Reactive value for data
  data <- reactiveVal(generate_random_data(50))
  
  # Updating the data when regenerate button is clicked or inputs change
  observeEvent(list(input$regenerate, input$n_points, input$correlation), {
    data(generate_random_data(input$n_points, input$correlation))
  })
  
  # Rendering the interactive plot
  output$pca_plot <- renderPlotly({
    current_data <- data()
    pca_results <- calculate_pca(current_data)
    
    # Calculating endpoints for PC lines
    scale_factor <- 50 
    pc1_end <- pca_results$mean_point + scale_factor * pca_results$pc1
    pc2_end <- pca_results$mean_point + scale_factor * pca_results$pc2
    
    p <- plot_ly() %>%
      add_trace(data = current_data, x = ~x, y = ~y, type = 'scatter', mode = 'markers',
                marker = list(color = 'blue', size = 8, opacity = 0.6),
                name = 'Original Data',
                hoverinfo = 'text',
                text = ~paste('X:', round(x, 2), '<br>Y:', round(y, 2)))
    
    if (input$show_mean) {
      p <- p %>% add_trace(x = pca_results$mean_point[1], y = pca_results$mean_point[2],
                           type = 'scatter', mode = 'markers',
                           marker = list(color = 'red', size = 12, symbol = 'star'),
                           name = 'Mean Point')
    }
    
    if (input$show_pc1) {
      p <- p %>% add_trace(x = c(pca_results$mean_point[1], pc1_end[1]),
                           y = c(pca_results$mean_point[2], pc1_end[2]),
                           type = 'scatter', mode = 'lines',
                           line = list(color = 'red', width = 3),
                           name = 'PC1')
    }
    
    if (input$show_pc2) {
      p <- p %>% add_trace(x = c(pca_results$mean_point[1], pc2_end[1]),
                           y = c(pca_results$mean_point[2], pc2_end[2]),
                           type = 'scatter', mode = 'lines',
                           line = list(color = 'green', width = 3),
                           name = 'PC2')
    }
    
    if (input$show_transformed) {
      transformed_data <- as.data.frame(pca_results$scores)
      p <- plot_ly() %>%
        add_trace(data = transformed_data, x = ~PC1, y = ~PC2, type = 'scatter', mode = 'markers',
                  marker = list(color = 'purple', size = 8, opacity = 0.6),
                  name = 'Transformed Data',
                  hoverinfo = 'text',
                  text = ~paste('PC1:', round(PC1, 2), '<br>PC2:', round(PC2, 2)))
    }
    
    p %>% layout(title = ifelse(input$show_transformed, 
                                "Data in Principal Component Space",
                                "Original Data with Principal Components"),
                 xaxis = list(title = ifelse(input$show_transformed, "PC1", "X")),
                 yaxis = list(title = ifelse(input$show_transformed, "PC2", "Y")),
                 showlegend = TRUE)
  })
  
  # Displaying variance explained
  output$variance_explained <- renderText({
    pca_results <- calculate_pca(data())
    paste("Variance Explained:",
          "\nPC1:", round(pca_results$variance_explained[1] * 100, 2), "%",
          "\nPC2:", round(pca_results$variance_explained[2] * 100, 2), "%")
  })
  
  # Generating explanation based on user interactions
  output$explanation <- renderUI({
    HTML(paste(
      "<h4>PCA Explanation:</h4>",
      "<p>Principal Component Analysis (PCA) is a technique for reducing the dimensionality of data while retaining most of the variation.</p>",
      "<ul>",
      "<li><strong>Data Points:</strong> Each blue dot represents a data point in 2D space.</li>",
      if(input$show_mean) "<li><strong>Mean Point (Red Star):</strong> The average of all data points. PCA centers the data around this point.</li>" else "",
      if(input$show_pc1) "<li><strong>First Principal Component (Red Line):</strong> The direction of maximum variance in the data.</li>" else "",
      if(input$show_pc2) "<li><strong>Second Principal Component (Green Line):</strong> The direction of second most variance, perpendicular to PC1.</li>" else "",
      if(input$show_transformed) "<li><strong>Transformed Data:</strong> The data points projected onto the new coordinate system defined by the principal components.</li>" else "",
      "</ul>",
      "<p>Try adjusting the correlation slider to see how it affects the principal components!</p>"
    ))
  })
}

# Run the app
shinyApp(ui = ui, server = server)