# Install and load necessary packages
if (!requireNamespace("rvest", quietly = TRUE)) install.packages("rvest")
if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
if (!requireNamespace("magick", quietly = TRUE)) install.packages("magick")

library(rvest)
library(httr)
library(magick)

# Function to download images
download_image <- function(url, path) {
  download.file(url, path, mode = "wb")
}

# Function to scrape images from WikiArt
scrape_images <- function(base_url, num_images, save_dir) {
  page <- read_html(base_url)
  images <- html_nodes(page, "img")
  img_urls <- html_attr(images, "src")
  
  # Ensure URLs are absolute
  img_urls <- ifelse(grepl("^http", img_urls), img_urls, paste0("https:", img_urls))
  
  if (!dir.exists(save_dir)) {
    dir.create(save_dir)
  }
  
  for (i in seq_len(min(num_images, length(img_urls)))) {
    img_url <- img_urls[i]
    if (startsWith(img_url, "http")) {
      tryCatch({
        image_path <- paste0(save_dir, "/image_", i, ".jpg")
        download_image(img_url, image_path)
        print(paste("Downloaded image:", img_url, "to", image_path))
      }, error = function(e) {
        message(paste("Failed to download image:", img_url))
      })
    }
  }
}

# Prompt user to choose a directory
placeholder_file <- file.choose()
save_dir <- dirname(placeholder_file)

# Example usage
base_url <- "https://www.wikiart.org/en/paintings-by-genre"
scrape_images(base_url, 100, save_dir)
