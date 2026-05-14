p_needed <- c(
  "readxl",
  "dplyr",
  "leaflet",
  "leaflet.extras",
  "htmltools",
  "htmlwidgets",
  "widgetframe",
  "sf"
)

installed <- rownames(installed.packages())
to_install <- p_needed[!(p_needed %in% installed)]

if (length(to_install) > 0) install.packages(to_install)

invisible(lapply(p_needed, library, character.only = TRUE))


# DATA (GitHub-safe path)
data <- readxl::read_xlsx("data/Angemeldete Veranstaltungen.xlsx")

data$Longitude <- data$Longitude / 1000000
data$Latitude  <- data$Latitude / 1000000


# ICON
pup_logo <- makeIcon(
  iconUrl = "Logo_PuP.png",
  iconWidth = 40,
  iconHeight = 40
)


# POPUPS
mytext <- paste(
  "<b>Herzliche Einladung!</b><br/>",
  "<b>Wer? </b>", data$`Wer?`, "<br/>",
  "<b>Wann? </b>", data$`Wann?`, "<br/>",
  "<b>Wo? </b>", data$`Wo?`, "<br/>",
  data$`Weitere Infos`
) |> lapply(htmltools::HTML)


# MAP
final_map <- leaflet() %>%
  addTiles() %>%
  addMarkers(
    lng = data$Longitude,
    lat = data$Latitude,
    icon = pup_logo,
    popup = mytext
  ) %>%
  leaflet.extras::addSearchOSM(
    options = searchOptions(collapsed = TRUE)
  )


# OUTPUT
dir.create("output", showWarnings = FALSE)

htmlwidgets::saveWidget(
  final_map,
  "output/karte_marker.html",
  selfcontained = FALSE
)