library(readr)
library(dplyr)

# Define the source folder and output file path. Replace "gescamilla" with your username - you must have access to the Stats SharePoint.
sourceFolderPath <- "C:/Users/gescamilla/International Renewable Energy Agency - IRENA/Statistics - Documents/P_Data/Investment and Costs statistics/01.Investments/01.Data/01.OECD/02.Data Downloads"
outputFile <- "C:/Users/gescamilla/International Renewable Energy Agency - IRENA/Statistics - Documents/P_Data/Investment and Costs statistics/01.Investments/01.Data/01.OECD/02.Data Downloads/Combined/CRS data filtered.csv"

# Define the desired columns
desiredColumns <- c("Year", "DonorCode", "DonorName", "AgencyCode", "ProjectNumber", 
                    "RecipientName", "FlowCode", "FlowName", "Finance_t", "USD_Commitment", 
                    "USD_Disbursement", "USD_Commitment_Defl", "USD_Disbursement_Defl", 
                    "ShortDescription", "ProjectTitle", "PurposeCode", "PurposeName", 
                    "ExpectedStartDate", "CompletionDate", "LongDescription", "CommitmentDate")

# Function to read and process each file
process_file <- function(file_path) {
  # Read the file
  df <- read_delim(file_path, delim = "|", escape_double = FALSE, trim_ws = TRUE, col_names = TRUE)
  
  # Select desired columns
  df <- df %>% select(all_of(desiredColumns))
  
  # Filter out rows where USD_Commitment is 0 or NA
  df <- df %>% filter(USD_Commitment != 0 & !is.na(USD_Commitment))
  
  # Replace NA values with empty strings in all columns
  df <- df %>% mutate(across(everything(), ~ifelse(is.na(.), "", .)))
  
  # Filter out private investments
  df <- df %>% filter(FlowCode != 30)
  
  # Filter for energy technologies
  df <- df %>% filter((PurposeCode >= 23210 & PurposeCode <= 23290) | #RE generation 
                        (PurposeCode >= 23310 & PurposeCode <= 23390) | #NRE generation
                        PurposeCode == 23410 | PurposeCode == 23510 |#hybrid & nuclear,  
                        PurposeCode == 23631) #mini-grids
  
  return(df)
}

# Get the list of all .txt files in the source folder
file_list <- list.files(path = sourceFolderPath, pattern = "*.txt", full.names = TRUE)

# Apply the process_file function to each file and combine the results
combined_data <- do.call(rbind, lapply(file_list, process_file))

# Check if the output directory exists, create it if it doesn't
if (!dir.exists(dirname(outputFile))) {
  dir.create(dirname(outputFile), recursive = TRUE)
}

# Write the combined data to a CSV file
tryCatch({
  write_csv(combined_data, outputFile)
}, error = function(e) {
  cat("An error has occurred:\n")
  cat(e$message, "\n")
  cat("Please check the output file path and permissions.\n")
})