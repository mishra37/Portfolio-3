library(shiny)
library(tidyverse)
library(ggraph)
library(tidygraph)
library(dplyr)
library(stringr)
library(ggrepel)
library(shinyWidgets)
library(shinythemes)
library(DT)
data <- read_csv('https://raw.githubusercontent.com/mishra37/Portfolio-3/main/batman_films.csv')

get_digits_sum <- function(x){
  sum(as.integer(unlist(str_extract_all(x, '(\\d+)'))))
}

processed_data <- data %>%
  separate(Director, into = c('d1','d2','d3','d4','d5','d6'), sep = ', ') %>%
  pivot_longer(cols = starts_with('d'), names_to = 'to_drop', values_to = 'Directors',  values_drop_na = T) %>%
  mutate(`Total Awards & Nomination` = sapply(Awards,get_digits_sum)) %>%
  select(-c(to_drop, Metascore))

movies <- processed_data %>%
  select(Title) %>%
  unique() %>%
  pull(Title)

edges <- processed_data %>%
  select(Directors, Title, `Total Awards & Nomination`)

G <- tbl_graph(edges = edges) %>%
  mutate(is_movie = case_when(
    name %in% movies ~ T,
    T ~ F
  )) %>%
  mutate(font = case_when(
    name %in% movies ~ "bold.italic",
    T ~ "bold"
  ))

ggraph_plot <- function() {
  ggraph(G,'kk') +
    geom_edge_link(aes(width = `Total Awards & Nomination`), edge_colour = 'red')+
    geom_node_label(aes(label = str_wrap(name, 20), fill = is_movie, size = as.factor(is_movie), fontface = font), col = "black") +
    scale_fill_manual(values = c('#999999', '#FFCC00'), guide = 'none') +
    scale_size_discrete(range = c(4,  5), guide = 'none') +
    scale_edge_width(breaks = c(1, 5, 32, 50, 90, 150, 314), name = str_wrap("Total Awards & Nomination",12)) +
    theme_minimal() +
    theme(legend.text = element_text(color = 'white'),
          legend.title = element_text(color = 'white'),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_blank(),
          panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(),
          axis.text.y = element_blank())
}

ui <- fluidPage(
  theme = shinytheme("cyborg"),
  titlePanel(title=div(img(src="https://cdn.mos.cms.futurecdn.net/SQZRGxWR9VMWkMSeYqaf4b.jpg", height = 300, width = '100%',align = "center"))),
  titlePanel(h6("Instructions:", align = "center")),
  titlePanel(h6("Brush over movies/director to see the corresponding information below!", align = "center")),
  plotOutput("graph", height = "1000px", brush = "plot_brush"),
  dataTableOutput("table")
)

server <- function(input, output) {
  
  p <- ggraph_plot()
  plot_data <- ggplot_build(p)
  coords <- plot_data$data[[2]]
  output$graph <- renderPlot({p}, bg="transparent")
  
  coords_filt <- reactive({
    if (is.null(input$plot_brush$xmin)){
      coords
    } else {
      filter(coords, x >= input$plot_brush$xmin,
             x <= input$plot_brush$xmax,
             y >= input$plot_brush$ymin,
             y <= input$plot_brush$ymax)
    }
  })
  
  
  
  output$table <- renderDataTable({
    labels <- coords_filt()$label
    labels <- str_replace_all(labels, "[\r\n]" , " ")
    
    datatable(
    processed_data %>% 
      filter(Title %in% labels | Directors %in% labels) %>% select(-`Total Awards & Nomination`), style = "bootstrap")})
}
shinyApp(ui = ui, server = server)