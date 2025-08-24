library(imager)
library(ggplot2)
library(dplyr)

# Select an image file interactively
image_path <- file.choose()

# Load the selected image
image <- imager::load.image(image_path)

# Resize the image
resized_image <- imager::resize(image, 100, 100)  # Resize the image to a width of 100 pixels and maintain aspect ratio

# Convert the image to a data frame
image_df <- as.data.frame(resized_image, wide="c")

# Extract unique colors
unique_colors <- image_df %>% select(c.1, c.2, c.3) %>% distinct()

# Convert colors to hexadecimal
colors_hex <- rgb(unique_colors$c.1, unique_colors$c.2, unique_colors$c.3, maxColorValue = 1)

# Create a data frame with the colors
color_palette <- data.frame(cluster = factor(1:length(colors_hex)), color = colors_hex)

# Plot the color palette
plot <- ggplot(data = color_palette, aes(x = cluster, fill = color)) +
  geom_bar(stat = "count", show.legend = FALSE) +
  scale_fill_identity() +
  theme_void() +
  labs(title = "Dominant Colors in Artwork")

# Print the plot
print(plot)

# Save the plot as an image file
ggsave("color_palette_plot.png", plot, width = 6, height = 4)
