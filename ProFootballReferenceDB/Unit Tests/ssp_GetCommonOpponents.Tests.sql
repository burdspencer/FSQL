/*Unit Test File for ssp_GetCommonOpponents*/
/**************************************************
*	Test Case								
*	NULL Team Parameter returns no data
*	NULL Opponent Parameter returns no data
*
*
*
***************************************************/

EXEC tSQLt.NewTestClass @ClassName = 'ssp_GetCommonOpponents'
GO


CREATE PROCEDURE ssp_GetCommonOpponents.SetUp
AS
BEGIN
	IF OBJECT_ID('ssp_GetCommonOpponents.Expected','U') IS NOT NULL
		DROP TABLE ssp_GetCommonOpponents.Expected

	CREATE TABLE ssp_GetCommonOpponents.Expected
	(
	  HomeTeam VARCHAR(35)
	, AwayTeam VARCHAR(35)
	, [Date] Date
	, HomeResult VARCHAR(1)
	, AwayResult VARCHAR(1)
	, HomeScore INT
	, AwayScore INT
	)

	IF OBJECT_ID('ssp_GetCommonOpponents.Actual','U') IS NOT NULL
		DROP TABLE ssp_GetCommonOpponents.Actual

	CREATE TABLE ssp_GetCommonOpponents.Actual
	(
	  HomeTeam VARCHAR(35)
	, AwayTeam VARCHAR(35)
	, [Date] Date
	, HomeResult VARCHAR(1)
	, AwayResult VARCHAR(1)
	, HomeScore INT
	, AwayScore INT
	)

	EXEC tsqlt.FakeTable @TableName = 'GameData'
	INSERT INTO GameData (HomeTeam
						, AwayTeam
						, Week
						, Day
						, Time
						, Date
						, Season
						, HomeResult
						, AwayResult
						, HomeRecord
						, AwayRecord
						, HomeScore
						, AwayScore
						)
	SELECT 'Test Team 1'
		,  'Test Team 2'
		,  1
		,  'Sun'
		,  CAST('4:15:00 PM' as time)
		,  '9-01-2023'
		,  2023
		,  'W'
		,  'L'
		,  '0-0'
		,  '0-0'
		,  14
		,  7
	UNION ALL
	SELECT
		   'Test Team 2'
		,  'Test Team 1'
		,  1
		,  'Sun'
		,  CAST('4:15:00 PM' as time)
		,  '9-01-2023'
		,  2023
		,  'L'
		,  'W'
		,  '0-0'
		,  '0-0'
		,  7
		,  14

END
GO


CREATE PROCEDURE ssp_GetCommonOpponents.[test - NULL Team parameter returns no data]
AS
BEGIN
	INSERT INTO ssp_GetCommonOpponents.Actual
	(
	  HomeTeam
	, AwayTeam
	, [Date]
	, HomeResult
	, AwayResult
	, HomeScore
	, AwayScore
	)
	EXEC ssp_GetCommonOpponents @Team = 'Test Team 1', @Opponent = 'Test Team 2', @Season = 2023

	EXEC tSQLt.AssertEmptyTable @TableName = 'ssp_GetCommonOpponents.Actual'

END


EXEC tSQLt.RunAll