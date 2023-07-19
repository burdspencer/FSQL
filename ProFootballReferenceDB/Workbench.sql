exec ssp_ScheduleDataReport_Dev 'B', 0.1,0.1,0.1

--SELECT ROUND(AVG(SeasonProfit/SeasonWager),2), SeasonProfit, SeasonWager, OneUnitThreshold, FiveUnitThreshold, TenUnitThreshold, OneUnitThreshold + FiveUnitThreshold + TenUnitThreshold as TotalThreshold
--FROM SeasonDataAggregateCache 
--GROUP BY OneUnitThreshold, FiveUnitThreshold, TenUnitThreshold,  SeasonProfit, SeasonWager
--ORDER BY AVG(SeasonProfit/SeasonWager) DESC
