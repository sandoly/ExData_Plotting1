    ### This code reads observations from "./data/household_power_consumption.txt" between 1/2/2007 and 2/2/2007 then plots 4 diagrams in one screen:
        #topleft        - Global_active_power vs. Date
        #bottomleft     - Sub_metering_1 to 3 vs. Date 
        #topright       - Voltage vs. Date
        #bottomright    - Global_reactive_power vs. Date
    ### Dataset: Electric power consumption [20Mb] https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

    ## download data
    if (!file.exists("data")) {                                                 # create data folder to download data if directory does not exist
            dir.create("data") }
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                                                                                # download URL
    if(!file.exists('./data/household_power_consumption.txt')){                 # if file does not exists download it to data folder 
            download.file(fileURL, "./data/household_power_consumption.zip")
    }
    unzip("./data/household_power_consumption.zip", exdir = "./data")           # unzip file to data folder

    if (file.exists("./data/household_power_consumption.zip")) file.remove("./data/household_power_consumption.zip")
                                                                                # delete zip file
    ## reading data
    require(sqldf)                                                              # load sqlf package
    DF <- read.csv.sql(file = "./data/household_power_consumption.txt",sep=";",sql='select * from file where Date="1/2/2007" OR Date="2/2/2007"')
                                                                                # subset data before reading: data interested between 1/2/2007 and 2/2/2007
    DF$Date <- strptime(paste(DF$Date,DF$Time),format = "%d/%m/%Y %H:%M:%S")    # join Date and Time column and transform to POSIXlt format 
    
    ## plotting & capturing screen to png
    Sys.setlocale("LC_TIME", "English")                                         # set locale region to US
    png(file = "plot4.png", width = 480 , height = 480, res = 72)               # initialize png capturing device
    par(mfcol = c(2,2))                                                         # split screen to 4 parts -> plot orientation: topleft->bottomleft->topright->bottomright
    
    # topleft plot
    plot(DF$Date, DF$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab ="" )
                                                                                # plotting Global_active_power vs. Date
    # bottomleft plot
    plot(DF$Date, DF$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab ="" )
                                                                                # plotting Sub_metering_1 to 3 vs. Date 
    points(DF$Date, DF$Sub_metering_2, type="l", col = "red")                   # add 2nd line 'Sub_metering_2' in red to plot
    points(DF$Date, DF$Sub_metering_3, type="l", col = "blue")                  # add 3nd line 'Sub_metering_2' in blue to plot
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1 ,lwd = 1 )
                                                                                # add 3 legends to the "topright" corner of the plot
    # topright plot
    plot(DF$Date, DF$Voltage, type="l", ylab = "Voltage", xlab ="datetime" )    # plotting Voltage vs. Date
    
    # bottomright plot
    plot(DF$Date, DF$Global_reactive_power, type="l", ylab = "Global_reactive_power", xlab ="datetime" )
                                                                                # plotting Global_reactive_power vs. Date
    dev.off()                                                                   # detaching png device