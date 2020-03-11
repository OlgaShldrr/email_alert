print(Sys.time())
library(dplyr)
library(readxl)
library(readr)
library(lubridate)
library(blastula)


#Read in first file
first_file <- read_csv("XXXDATAPATH.csv")

#Read in second file
second_file <- read_excel("XXXDATAPATH.xlsx", sheet="XXX")

#Read in the emails of people who are tracking their accounts
emails <- read_csv("XXXDATAPATH/emails.csv")


#Merge all files and clean up
data <- merge(second_file, first_file, all.x = TRUE)
event_alert <- data %>% 
  filter(dateCreated>=`Reviewed Date` & is.na(`Locked Date`)) %>% 
  select(UnitID, `Unit Name`, user =`Assigned To:`, dateCreated) %>% 
  arrange(user, dateCreated)

event_alert <- merge(event_alert, emails, all.x = TRUE)
unique_users <- unique(event_alert$user)

#Save the files. This helps to check the list mid-week quickly if necessary, since the emails come out once a week only.
write.csv(event_alert, "XXXDATAPATH/event_alert.csv", row.names = FALSE)




send_event_alert_email <- function(user, email) {
  #Each send function references its own Rmd file with text written for that survey.
  email_object <- blastula::render_email("XXXDATAPATH/event_alert_email.Rmd", 
                                         render_options = list(params=list(name=user)))
  
  blastula::smtp_send(
    email = email_object,
    from = "XXX@XXX.com",
    to = email,
    subject = "Event Alert",
    credentials = blastula::creds_file(".email_creds")
    )
}



send_event_alert_emails <- function(user_dataset) {
  user_dataset <- user_dataset %>% filter(user %in% unique_users)
  email_list <- as.list(user_dataset)
  
  purrr::possibly(
    purrr::walk2(
      .x = email_list$user,
      .y = email_list$email,
      .f = ~ send_event_alert_email(user = .x, email = .y)
    ), 
    otherwise = "The email message was not sent successfully"
  )
}

send_event_alert_emails(emails)

