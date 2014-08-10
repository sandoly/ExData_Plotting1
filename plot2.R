    ### This code reads observations from "./data/household_power_consumption.txt" between 1/2/2007 and 2/2/2007 then plots Global Active Power (kilowatts) vs. date
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
    
    ## plotting
    Sys.setlocale("LC_TIME", "English")                                         # set locale region to US
    plot(DF$Date, DF$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab ="" )
                                                                                # plotting data
    ## capturing plot to png
    dev.copy(png, file = "plot2.png", width = 480 , height = 480, res = 72)     # capture screen in png format
    dev.off()                                                                   # detach png device