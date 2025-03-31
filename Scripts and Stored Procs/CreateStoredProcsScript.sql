IF OBJECT_ID('SP_AIRPORTDELAYED', 'P') IS NOT NULL  
    DROP PROCEDURE SP_AIRPORTDELAYED;  
GO  
CREATE PROC SP_AIRPORTDELAYED
AS
	BEGIN SELECT dp.AirportName, 
		SUM(ff.DelayedFlight) AS TotalDelayedFlights, 
		SUM(ff.TotalFlight) AS TotalFlights,
		(FORMAT((CAST(SUM(ff.DelayedFlight) AS FLOAT) / NULLIF(SUM(ff.TotalFlight), 0)) * 100,'N2')+'%') AS DelayedFlightRate
	FROM 
		FactAirlineAnalysis ff
	INNER JOIN 
		DimAirport dp ON ff.AirportKey = dp.AirportKey

	GROUP BY 
		dp.AirportName
	ORDER BY 
		DelayedFlightRate DESC
END
GO

IF OBJECT_ID('SP_CITYSTATEIMPACT', 'P') IS NOT NULL  
    DROP PROCEDURE SP_CITYSTATEIMPACT;  
GO  
CREATE PROCEDURE SP_CITYSTATEIMPACT
AS
BEGIN
	SELECT 
		dp.States,
		dp.City,
		SUM(ff.DelayedFlight) AS TotalDelayedFlights,
		SUM(ff.TotalFlight) AS TotalFlights,
		SUM(ff.CancelledFlightRate) AS TotalCancelledRate,
		(CAST(SUM(ff.DelayedFlight) AS FLOAT) / NULLIF(SUM(ff.TotalFlight), 0)) * 100 AS DelayedFlightRate
	FROM 
		FactAirlineAnalysis ff
	INNER JOIN 
		DimAirport dp ON ff.AirportKey = dp.AirportKey
	GROUP BY 
		dp.States, dp.City
	ORDER BY 
		dp.States, dp.City
END
GO


IF OBJECT_ID('SP_QUARTELYDELAYIMPACT', 'P') IS NOT NULL  
    DROP PROCEDURE SP_QUARTELYDELAYIMPACT
GO  
CREATE PROCEDURE SP_QUARTELYDELAYIMPACT
AS
BEGIN
	SELECT 
		CAST(dd.Year_ AS INT) AS Year_,
		CAST(dd.Quarter_ AS INT) AS Quarter_,
		SUM(ff.TotalFlight) AS TotalFlight,
		SUM(ff.CancelledFlightRate) AS TotalCancelledRate,
		(CAST(SUM(ff.DelayedFlight) AS FLOAT) / NULLIF(SUM(ff.TotalFlight), 0)) * 100 AS DelayedFlightRate
	FROM 
		FactAirlineAnalysis ff
	INNER JOIN 
		DimDate dd ON ff.DateKey = dd.DateKey
	GROUP BY 
		dd.Year_, dd.Quarter_
	ORDER BY 
		dd.Year_, dd.Quarter_
END
GO

IF OBJECT_ID('SP_MONTHLYDELAYIMPACT', 'P') IS NOT NULL  
    DROP PROCEDURE SP_MONTHLYDELAYIMPACT;  
GO  
CREATE PROCEDURE SP_MONTHLYDELAYIMPACT
(
	@Year INT,
	@Quarter INT
)
AS
BEGIN
	SELECT 
		CAST(dd.Year_ AS INT) AS Year_,
		CAST(dd.Month_ AS INT) AS Month_,
		dd.MonthName_,
		SUM(ff.TotalFlight) AS TotalFlight,
		SUM(ff.CancelledFlightRate) AS TotalCancelledRate,
		(CAST(SUM(ff.DelayedFlight) AS FLOAT) / NULLIF(SUM(ff.TotalFlight), 0)) * 100 AS DelayedFlightRate
	FROM 
		FactAirlineAnalysis ff
	INNER JOIN 
		DimDate dd ON ff.DateKey = dd.DateKey
	WHERE 
		dd.Year_ = @Year AND dd.Quarter_ = @Quarter -- Filtered by main report parameters
	GROUP BY 
		dd.Year_, dd.Month_, dd.MonthName_
	ORDER BY 
		dd.Month_
END