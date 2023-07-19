/*Unit Test File for ssp_GetCommonOpponents*/
/**************************************************
*	Test Case								
*	NULL Team Parameter returns no data
*	NULL Opponent Parameter returns no data
*
*
*
***************************************************/

EXEC tSQLt.NewTestClass @ClassName = 'Tests_ssp_GetCommonOpponents'
GO


CREATE PROCEDURE Tests_ssp_GetCommonOpponents.SetUp
AS
BEGIN
	IF OBJECT_ID('Tests_ssp_GetCommonOpponents.Expected','U') IS NOT NULL
		DROP TABLE Tests_ssp_GetCommonOpponents.Expected

	CREATE TABLE Tests_ssp_GetCommonOpponents.Expected
	(
	  HomeTeam VARCHAR(35)
	, AwayTeam VARCHAR(35)
	, [Date] Date
	, HomeResult VARCHAR(1)
	, AwayResult VARCHAR(1)
	, HomeScore INT
	, AwayScore INT
	)

	IF OBJECT_ID('Tests_ssp_GetCommonOpponents.Actual','U') IS NOT NULL
		DROP TABLE Tests_ssp_GetCommonOpponents.Actual

	CREATE TABLE Tests_ssp_GetCommonOpponents.Actual
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
	SELECT 'Test Team 2'
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
	UNION ALL
	SELECT
		   'Test Team 2'
		,  'Test Team 3'
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
	UNION ALL
	SELECT
		   'Test Team 3'
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
		   'Test Team 1'
		,  'Test Team 3'
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
	UNION ALL
	SELECT
		   'Test Team 3'
		,  'Test Team 1'
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

END
GO


CREATE PROCEDURE Tests_ssp_GetCommonOpponents.[Test - Blank Team parameter returns no data]
AS
BEGIN
	INSERT INTO Tests_ssp_GetCommonOpponents.Actual
	(
	  HomeTeam
	, AwayTeam
	, [Date]
	, HomeResult
	, AwayResult
	, HomeScore
	, AwayScore
	)
	EXEC ssp_GetCommonOpponents @Team = NULL, @Opponent = 'Test Team 2', @Season = 2023

	EXEC tSQLt.AssertEmptyTable @TableName = 'Tests_ssp_GetCommonOpponents.Actual'

END
GO

CREATE PROCEDURE Tests_ssp_GetCommonOpponents.[Test - Blank Opponent parameter returns no data]
AS
BEGIN
	INSERT INTO Tests_ssp_GetCommonOpponents.Actual
	(
	  HomeTeam
	, AwayTeam
	, [Date]
	, HomeResult
	, AwayResult
	, HomeScore
	, AwayScore
	)
	EXEC ssp_GetCommonOpponents @Team = 'Test Team 1', @Opponent = NULL, @Season = 2023

	EXEC tSQLt.AssertEmptyTable @TableName = 'Tests_ssp_GetCommonOpponents.Actual'

END
GO

CREATE PROCEDURE Tests_ssp_GetCommonOpponents.[Test - Two GameData records return one match]
AS
BEGIN
	INSERT INTO Tests_ssp_GetCommonOpponents.Actual
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

	INSERT INTO Tests_ssp_GetCommonOpponents.Expected
	(
	  HomeTeam
	, AwayTeam
	, [Date]
	, HomeResult
	, AwayResult
	, HomeScore
	, AwayScore
	)
	SELECT 'Test Team 1', 'Test Team 3', '09-01-2023', 'W', 'L', 21, 3


	
	EXEC ssp_GetCommonOpponents @Team = 'Test Team 1', @Opponent = 'Test Team 2', @Season = 2023

	EXEC tSQLt.AssertEmptyTable @TableName = 'Tests_ssp_GetCommonOpponents.Actual'

END
GO
--EXEC tSQLt.Run 'Tests_ssp_GetCommonOpponents'
EXEC tSQLt.Run @TestName = 'Tests_ssp_GetCommonOpponents.[Test - Two GameData records return one match]'
