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
png(file = "plot4.png", width = 480, height = 480, bg = "transparent")

#Preparing the layout
par(mfcol = c(2,2))

#Making the upper left plot
with(data,plot(timestamp,Global_active_power, type = "l",
               xlab="",ylab="Global Active Power"))

#Making the lower left plot
with(data,plot(
  timestamp,Sub_metering_1, type = "l",xlab = "",ylab = "Energy sub metering"
))
with(data,points(timestamp,Sub_metering_2,col = "red",type = "l"))
with(data,points(timestamp,Sub_metering_3,col = "blue",type = "l"))
legend(
  "topright",lty = c(1,1), col = c("black","red","blue"),
  legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
)

#Making the plot upper right plot
with(data,plot(timestamp,Voltage, type = "l",
               xlab="datetime",ylab="Voltage"))

#Making the plot lower right plot
with(data,plot(timestamp,Global_reactive_power, type = "l",
               xlab="datetime",ylab="Global_reactive_power",lwd=0.5))

#Closing the device
dev.off()
