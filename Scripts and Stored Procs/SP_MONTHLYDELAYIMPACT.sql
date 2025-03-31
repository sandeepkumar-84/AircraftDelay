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