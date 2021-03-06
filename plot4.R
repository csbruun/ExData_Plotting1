
# Check if data directory exists
# If not, create it
if (!file.exists("data")) {
  dir.create("data")
}

# Check if file has been downloaded
# If not, download and unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data/exdata-data-household_power_consumption.zip")) {
  download.file(fileUrl, destfile = "./data/exdata-data-household_power_consumption.zip")
  dateDownloaded <- date()
  
  unzip("./data/exdata-data-household_power_consumption.zip",
        exdir="./data",
        list=FALSE,
        overwrite=TRUE,
        unzip="internal")
}

# Read in power consumption table as data frame
power <- read.table("./data/household_power_consumption.txt",
                    sep=";",
                    header=TRUE,
                    colClasses=c("factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
                    na.strings=c("?"),
                    nrows=69518
)

# Add column for datetime
power$Datetime <- strptime(paste(power$Date,power$Time), "%d/%m/%Y %H:%M:%S")

# Filter for dates between 2007-02-01 and 2007-02-02
power <- power[power$Datetime >= strptime("2007-02-01", "%Y-%m-%d")
               & power$Datetime < strptime("2007-02-03", "%Y-%m-%d"), ]

# Open png file for plot output
png(filename = "./plot4.png",
    width = 480, height = 480,
    units = "px",
    pointsize = 12)

# Set plot parameters for four simultaneous plots
par(mfrow = c(2,2))

# Plot 1
plot(x=power$Datetime,
     y=power$Global_active_power,
     type="l",
     main = "",
     xlab = "",
     ylab = "Global Active Power",
     col="black")


# Plot 2
plot(x=power$Datetime,
     y=power$Voltage,
     type="l",
     main = "",
     xlab = "datetime",
     ylab = "Voltage",
     col="black")


# Plot 3
plot(x=power$Datetime,
     y=power$Sub_metering_1,
     type="l",
     main = "",
     xlab = "",
     ylab = "Energy sub metering",
     col="black")
lines(x=power$Datetime,
      y=power$Sub_metering_2,
      col="red")
lines(x=power$Datetime,
      y=power$Sub_metering_3,
      col="blue")

# Add legend at top right
legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),
       lwd=c(1,1,1),
       col=c("black","red", "blue"),
       bty="n"
)


# Plot 4
plot(x=power$Datetime,
     y=power$Global_reactive_power,
     type="l",
     main = "",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     col="black")

# Close plot file
dev.off()
