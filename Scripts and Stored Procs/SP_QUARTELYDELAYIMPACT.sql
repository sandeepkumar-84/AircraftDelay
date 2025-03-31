
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