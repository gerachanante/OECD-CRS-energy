1. Do not change the structure of these folders (their location or names)
2. Download the OECD datasets in a new folder with the date as a title inside "03.Historic Data Downloads" https://stats.oecd.org/DownloadFiles.aspx?DatasetCode=CRS1
3. Copy-Paste and replace the newest datasets in the "02.Data Downloads" folder. The data in this folder is the one that will be reflected in the public investments.
4. Wait for the txt files to be uploaded/synced to OneDrive. This can take several minutes.
5. Once the files are synced to OneDrive, open and run the R script in 01.Info and Codes "OECD CRS filtering.R". This will consolidate the files into a single CSV file
6. Go to the investments database and refresh the data in "Queries & Connections". If needed, double check the data to ensure it is in good order inside Power Query
