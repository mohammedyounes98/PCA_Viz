
# PCA Visualizer Shiny App

## Description

The PCA Visualizer is an interactive Shiny application designed to help users understand and visualize Principal Component Analysis (PCA) in a straightforward and engaging way. The app allows users to generate random data with a specified correlation, perform PCA on the data, and visualize the results interactively.

## Results
Below is a screenshot of the PCA Visualizer in action:

![image](https://github.com/user-attachments/assets/3c5d2f11-37f7-4899-bf49-c6d9f250fe6c)

You can try out the PCA Visualizer Shiny app live [here](https://mohammedyounes.shinyapps.io/pca_viz/)


## Features

-   **Interactive Data Generation**: Users can generate random datasets with a specified number of points and correlation between the variables.
-   **Dynamic PCA Visualization**: Visualize the mean point, first and second principal components (PC1 and PC2), and the transformed data in the principal component space.
-   **Customizable Display**: Options to show or hide the mean point, principal components, and transformed data.
-   **Variance Explained**: The app calculates and displays the proportion of variance explained by each principal component.

## Technologies Used

-   **Shiny**: Provides the interactive web framework for the application.
-   **ggplot2**: Utilized for creating static visualizations (though dynamically rendered via plotly).
-   **plotly**: Adds interactivity to the plots, allowing users to hover over data points and explore the visualizations more deeply.
-   **dplyr**: Used for data manipulation within the app.

## Installation and Usage

1.  **Clone the repository**:

    ```{bash}
    git clone https://github.com/mohammedyounes98/PCA_Viz
    ```

2.  **Install the required packages** in R:

    ```{r}
    install.packages(c("shiny", "ggplot2", "dplyr", "plotly"))
    ```


3.  **Run the Shiny app**:

    ```{r}
    shiny::runApp('PCA_Viz.R')
    ```

4.  **Interact with the App**:

    -   Adjust the number of points and the correlation between `X` and `Y`.

    -   Click "Regenerate Data" to create a new dataset.

    -   Use the checkboxes to toggle the display of the mean point, principal components, and transformed data.

    -   Explore how the correlation affects the orientation and length of the principal components.

## Application Walk-through

### UI Components

-   **Number of Points Slider**: Controls the number of points in the dataset.

-   **Correlation Slider**: Adjusts the correlation between `X` and `Y` variables.

-   **Regenerate Button**: Generates a new random dataset based on the selected parameters.

-   **Checkboxes**: Toggle the display of the mean point, PC1, PC2, and transformed data.

### PCA Visualization

-   **Original Data**: The scatter plot shows the original data points with optional overlays for the mean point and principal components.

-   **Principal Components**: PC1 is shown as a red line, representing the direction of maximum variance, while PC2 is shown as a green line, perpendicular to PC1.

-   **Transformed Data**: When enabled, the plot switches to display data in the new coordinate system defined by the principal components.

### Variance Explained

-   A text output displays the percentage of variance explained by PC1 and PC2, giving insights into the effectiveness of the PCA for the current dataset.

## Contribution

Contributions are welcome! Feel free to fork the repository, make improvements, and submit a pull request. If you encounter any issues or have suggestions for new features, please open an issue.

## License

This project is licensed under the  GNU General Public License (GPL v3) License. See the [LICENSE](https://github.com/mohammedyounes98/PCA_Viz/blob/main/LICENSE) file for details.

## Author

-   [Mohammed YOUNES](https://github.com/mohammedyounes98/)
