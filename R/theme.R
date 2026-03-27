dashboard_theme <- function() {
  bslib::bs_theme(
    version = 5,
    bg = "#F7FAFC",
    fg = "#1A202C",
    primary = "#1F4E79",
    secondary = "#C05621",
    base_font = bslib::font_google("Source Sans 3"),
    heading_font = bslib::font_google("Merriweather Sans")
  )
}
