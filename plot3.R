#Reading the file
library(sqldf)
data <-
  read.csv.sql(
    "household_power_consumption.txt",sep = ";",eol = "\n",
    sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'"
  )

closeAllConnections()

#Formatting the date by using a single column for Date and Time
data <- within(data, {
  timestamp = strptime(paste(Date, Time),
                       format = "%d/%m/%Y %H:%M:%S")
})

dropCol <- c("Date","Time")
data <- data[,!(names(data) %in% dropCol)]

#Opening png graph device
png(file = "plot3.png", width = 480, height = 480, bg = "transparent")

#Making the plot
with(data,plot(
  timestamp,Sub_metering_1, type = "l",xlab = "",ylab = "Energy sub metering",
  bg = "transparent"
))
with(data,points(timestamp,Sub_metering_2,col = "red",type = "l"))
with(data,points(timestamp,Sub_metering_3,col = "blue",type = "l"))
legend(
  "topright",lty = c(1,1), col = c("black","red","blue"),
  legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
)

#Closing the device
dev.off()
