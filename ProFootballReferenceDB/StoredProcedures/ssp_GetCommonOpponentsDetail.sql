IF OBJECT_ID('ssp_GetCommonOpponentsDetail','P') IS NOT NULL
	DROP PROCEDURE ssp_GetCommonOpponentsDetail
	GO

CREATE PROCEDURE ssp_GetCommonOpponentsDetail @Team VARCHAR(25), @Opponent VARCHAR(25), @Season VARCHAR(4)
AS
BEGIN TRY
	IF OBJECT_ID('tempdb..#OppMatchupList','P') IS NOT NULL
		DROP TABLE #OppMatchupList
	
	CREATE TABLE #OppMatchupList (
				[HomeTeam] [varchar](35), 
				[AwayTeam] [varchar](35), 
				[Date] [date],
				[Result] [varchar](1),
				[TeamScore] [int] NOT NULL,
				[OppScore] [int] NOT NULL,
				[TeamOff1stD] [int] NULL,
				[TeamOffTotYd] [int] NULL,
				[TeamOffPassYd] [int] NULL,
				[TeamOffRushYd] [int] NULL,
				[TeamOffTO] [int] NULL,
				[TeamDef1stD] [int] NULL,
				[TeamDefTotYd] [int] NULL,
				[TeamDefPassYd] [int] NULL,
				[TeamDefRushYd] [int] NULL,
				[TeamDefTO] [int] NULL,
				[TeamExPointsOff] [decimal](5, 2) NULL,
				[TeamExPointsDef] [decimal](5, 2) NULL,
				[TeamExPointsSpecial] [decimal](5, 2) NULL,
				[OppOff1stD] [int] NULL,
				[OppOffTotYd] [int] NULL,
				[OppOffPassYd] [int] NULL,
				[OppOffRushYd] [int] NULL,
				[OppOffTO] [int] NULL,
				[OppDef1stD] [int] NULL,
				[OppDefTotYd] [int] NULL,
				[OppDefPassYd] [int] NULL,
				[OppDefRushYd] [int] NULL,
				[OppDefTO] [int] NULL,
				[OppExPointsOff] [decimal](5, 2) NULL,
				[OppExPointsDef] [decimal](5, 2) NULL,
				[OppExPointsSpecial] [decimal](5, 2) NULL)

	INSERT INTO #OppMatchupList (HomeTeam,AwayTeam,[Date],Result,TeamScore,OppScore,TeamOff1stD,TeamOffTotYd,TeamOffPassYd,TeamOffRushYd,TeamOffTO,TeamDef1stD,TeamDefTotYd,TeamDefPassYd
							,TeamDefRushYd,TeamDefTO,TeamExPointsOff,TeamExPointsDef,TeamExPointsSpecial,OppOff1stD,OppOffTotYd,OppOffPassYd,OppOffRushYd,OppOffTO,OppDef1stD,OppDefTotYd,OppDefPassYd,OppDefRushYd
							,OppDefTO,OppExPointsOff,OppExPointsDef,OppExPointsSpecial)
	EXEC ssp_GetCommonOpponents @Team, @Opponent, @Season

	SELECT AVG(TeamScore) as AvgTeamScore 
		 , AVG(OppScore) AS AvgOppScore
		 , AVG(TeamOff1stD) AS AvgTeamOff1stD
		 , AVG(TeamOffTotYd) AS AvgTeamTotYd
		 , AVG(TeamOffPassYd) AS AvgTeamOffPassYd
		 , AVG(TeamOffRushYd) AS AvgTeamOffRushYd
		 , AVG(TeamOffTO) AS AvgTeamOffTO
		 , AVG(TeamDef1stD) AS AvgTeamDef1stD
		 , AVG(TeamDefTotYd) AS AvgTeamDefTotYd
		 , AVG(TeamDefPassYd) AS AvgTeamDefPassYd
		 , AVG(TeamDefRushYd) AS AvgTeamDefRushYd
		 , AVG(TeamDefTO) AS AvgTeamDefTO
		 , AVG(TeamExPointsOff) AS AvgTeamExPointsOff
		 , AVG(TeamExPointsDef) AS AvgTeamExPointsDef
		 , AVG(TeamExPointsSpecial) AS AvgTeamExPointsSpecial
		 , AVG(OppOff1stD) AS AvgOppOff1stD
		 , AVG(OppOffTotYd) AS AvgOppOffTotYd
		 , AVG(OppOffPassYd) AS AvgOppOffPassYd
		 , AVG(OppOffRushYd) AS AvgOppOffRushYd
		 , AVG(OppOffTO) AS AvgOppOffTO
		 , AVG(OppDef1stD) AS AvgOppDef1stD
		 , AVG(OppDefTotYd) AS AvgOppDefTotYd
		 , AVG(OppDefPassYd) AS AvgOppDefPassYd
		 , AVG(OppDefRushYd) AS AvgOppDefRushYd
		 , AVG(OppDefTO) AS AvgOppDefTO
		 , AVG(OppExPointsOff) AS AvgOppExPointsOff
		 , AVG(OppExPointsDef) AS AvgOppExPointsDef
		 , AVG(OppExPointsSpecial) AS AvgOppExPointsSpecial
	FROM #OppMatchupList

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH