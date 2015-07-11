#Reading the file
library(sqldf)
data <- read.csv.sql("household_power_consumption.txt",sep = ";",eol = "\n",
                     sql= "select * from file where Date = '1/2/2007' or Date = '2/2/2007'")

closeAllConnections()

#Formatting the date by using a single column for Date and Time
data <- within(data, {timestamp = strptime(paste(Date, Time), 
                                           format = "%d/%m/%Y %H:%M:%S")})

dropCol <- c("Date","Time")
data<- data[,!(names(data) %in% dropCol)]

#Opening png graph device
png(file = "plot2.png", width = 480, height = 480, bg = "transparent")

#Making the plot
with(data,plot(timestamp,Global_active_power, type = "l",
               xlab="",ylab="Global Active Power (kilowatts)"))

#Closing the device
dev.off()
