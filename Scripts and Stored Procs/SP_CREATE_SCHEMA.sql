IF OBJECT_ID('SP_CREATE_SCHEMA', 'P') IS NOT NULL  
    DROP PROCEDURE SP_CREATE_SCHEMA;  
GO  
CREATE PROCEDURE SP_CREATE_SCHEMA
AS
BEGIN
SET NOCOUNT ON 

	-----------Dropping all the tables if they alreday exists- Start ---------

	DROP TABLE IF EXISTS FactAirlineAnalysis
	DROP TABLE IF EXISTS DimAirline
	DROP TABLE IF EXISTS DimAirport
	DROP TABLE IF EXISTS DimDate


	-----------Dropping all the tables if they alreday exists- End ---------

	-----------Creating tables- Start -----------------------------
	print 'Creating tables- Start.....'

	BEGIN TRY
		CREATE TABLE DimAirline
		(
			AirlineKey INT PRIMARY KEY IDENTITY,
			AirlineCode VARCHAR(15),
			AirlineName VARCHAR(255)
		)

		CREATE TABLE DimAirport
		(
			AirportKey INT PRIMARY KEY IDENTITY,
			AirportCode VARCHAR(10),
			AirportName VARCHAR(255),
			City VARCHAR(255),
			States VARCHAR(255)
		)

		CREATE TABLE DimDate
		(
			DateKey INT PRIMARY KEY IDENTITY,
			Year_ INT,
			Month_ INT,
			Quarter_ INT,
			MonthName_ VARCHAR(20)
		)

		CREATE TABLE FactAirlineAnalysis
		(
			AirlineKey INT NOT NULL,
			AirportKey INT NOT NULL,
			DateKey INT NOT NULL,
			TotalFlight INT,
			DelayedFlight INT,
			OnTimeFlightRate FLOAT,
			DelayedFlightRate FLOAT,
			CancelledFlightRate FLOAT,
			DivertedFlightRate FLOAT,
			PRIMARY KEY (AirlineKey, AirportKey, DateKey),
			FOREIGN KEY (AirlineKey) REFERENCES DimAirline(AirlineKey),
			FOREIGN KEY (AirportKey) REFERENCES DimAirport(AirportKey),
			FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
		)

	print 'Tables Created Successfully.....'
	-----------Creating tables- End -----------------------------
	END TRY
	BEGIN CATCH
		print 'Exception Occured................'
	END CATCH

END