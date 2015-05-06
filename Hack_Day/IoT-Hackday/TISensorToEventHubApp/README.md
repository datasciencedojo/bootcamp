# TISensorToEventHub_WindowsForm
A Windows Form code for sending TI Sensor data to an EventHub. Can be used for demo for Azure Stream Analytics & Power BI

For this demo, buy the TI Sensor that connects to windows machine via bluetooth. Here is a link to buy this sensor (I am sure you can find it at other places too)- http://www.newark.com/texas-instruments/cc2541dk-sensor/dev-board-cc2541-2-4ghz-bluetooth/dp/55W6125?mckv=stpn1QPcu|pcrid|57087234021|plid|&CMP=KNC-GUSA-GEN-SHOPPING-TEXAS_INSTRUMENTS 

This repository has 2 folders:

DeploymentFiles - For those who don't care about the source code and just want to install the app. Copy all the files from this folder and run SensorTagToEventHub.exe. It’ll be better to change the config in SensorTagToEventHub.exe.config config file for your Event Hub, Service Bus and Access keys. This way, you don’t have to type these details again and again. Before running the app, you must connect your sensor to the laptop as a Bluetooth device. To be on the safer side, please remove and re-add everytime you start a new demo.

SourceCode - entire source code for this app. Not a very well written code but a quick and dirty app to show how easy it is to send data from a sensor to eventhub for building real time analytics systems with Azure Stream Analytics. 

Steps to follow for demo setup:

- Open the app (SensorTagToEventHub.exe). It’ll be better to change the config in SensorTagToEventHub.exe.config config file for your Event Hub, Service Bus and Access keys. This way, you don’t have to type these details again and again.

- Pair the TI sensor tag to your laptop (default password for pairing is 0). To be on the safer side, please remove and re-pair everytime you start a new demo.

- In the app, click on the "Send data to eventhub" button to start sending data from your sensor to your eventhub

- In the Azure portal, create an ASA job (Azure Stream Analytics job). Choose your event hub as an input and Power BI as the output option. Choose any dataset name and table name for Power BI. (note- if you choose a dataset name that already exists in PowerBI, that'll get overwritten)

- Write a query that does the aggregation that you want to show. For my demo, I use following query:

SELECT  
    max(hmdt) as hmdt
    ,max(temp) as temp
    ,time
    ,0 as minTemp
    ,150 as maxTemp
    ,75 as targetTemp
    ,100 as maxHmdt
    ,70 as targetHmdt
FROM 
    Input
WHERE 
    (dspl = 'TISensorTagB' or dspl like 'Weather Shield 01%')
Group by 
    TUMBLINGWINDOW(ss,1)
    ,time
    ,dspl
    
  - Test all the input, output connections in the job and start the job
  
  - Go to powerbi.com and sign in using the same id that you are using for ASA job. (at this point, both Azure job and Power BI should use the same org id). As soon as ASA job starts pushing the query output to Power BI, you'll see the dataset created in Power BI.
  
  - Now, you can create your own chart (line chart/ bar chart/ table/ tile) that you want. Pin that chart to the dashboard. You'll see those charts getting updated in real time. You can try blowing into the sensor and you'll see temperature and humidity values updating in real time in the chart.
