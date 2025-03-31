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