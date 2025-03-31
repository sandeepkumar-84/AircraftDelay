
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