# Email alert

### Description:

This project is an example of how one can schedule an email alert once a certain event is detected in the database. the project was originally developed for tracking auto-generated files on RStudio Server, however, it can be further developed to be connecting to a SQL server for data. The project takes in two files and a list of emails assigned to the users, compared the numbers in the two files and if the desired event has happened  sends an email to users that are tracking specific accounts from the dataset. The code in this project is to be run as regularly as the data can change and as it is relevant by cronR or any other schedulers.

### Packages used:

The project builds upon packages like lubridate, RMarkdown, blastula and tidyverse.



