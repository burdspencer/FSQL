IF OBJECT_ID('ssp_ImportOddsIntoGameData','P') IS NOT NULL
	DROP PROCEDURE ssp_ImportOddsIntoGameData
	GO

CREATE PROCEDURE ssp_ImportOddsIntoGameData

AS
BEGIN TRY
	IF OBJECT_ID('tempdb..#tempOdds','U') IS NOT NULL
		DROP TABLE #tempOdds

	CREATE TABLE #tempOdds (
		Date DATE 
	,	HomeTeam VARCHAR(50)
	,	AwayTeam VARCHAR(50)
	,	HomeScore VARCHAR(50)
	,	AwayScore VARCHAR(50)
	,	Overtime VARCHAR(50)
	,	PlayoffGame VARCHAR(50)
	,	NeutralVenue VARCHAR(50)
	,	HomeOddsOpen VARCHAR(50)
	,	HomeOddsMin VARCHAR(50)
	,	HomeOddsMax VARCHAR(50)
	,	HomeOddsClose VARCHAR(50)
	,	AwayOddsOpen VARCHAR(50)
	,	AwayOddsMin VARCHAR(50)
	,	AwayOddsMax VARCHAR(50)
	,	AwayOddsClose VARCHAR(50)
	,	HomeLineOpen VARCHAR(50)
	,	HomeLineMin VARCHAR(50)
	,	HomeLineMax VARCHAR(50)
	,	HomeLineClose VARCHAR(50)
	,	AwayLineOpen VARCHAR(50)
	,	AwayLineMin VARCHAR(50)
	,	AwayLineMax VARCHAR(50)
	,	AwayLineClose VARCHAR(50)
	,	HomeLineOddsOpen VARCHAR(50)
	,	HomeLineOddsMin VARCHAR(50)
	,	HomeLineOddsMax VARCHAR(50)
	,	HomeLineOddsClose VARCHAR(50)
	,	AwayLineOddsOpen VARCHAR(50)
	,	AwayLineOddsMin VARCHAR(50)
	,	AwayLineOddsMax VARCHAR(50)
	,	AwayLineOddsClose VARCHAR(50)
	,	TotalScoreOpen VARCHAR(50)
	,	TotalScoreMin VARCHAR(50)
	,	TotalScoreMax VARCHAR(50)
	,	TotalScoreClose VARCHAR(50)
	,	TotalScoreOverOpen VARCHAR(50)
	,	TotalScoreOverMin VARCHAR(50)
	,	TotalScoreOverMax VARCHAR(50)
	,	TotalScoreOverClose VARCHAR(50)
	,	TotalScoreUnderOpen VARCHAR(50)
	,	TotalScoreUnderMin VARCHAR(50)
	,	TotalScoreUnderMax VARCHAR(50)
	,	TotalScoreUnderClose VARCHAR(50)
		);

	IF OBJECT_ID('tempdb..#tempGameData','U') IS NOT NULL
		DROP TABLE #tempGameData

	CREATE TABLE #tempGameData (
			GameDataId			int
		,	HomeTeam			varchar(100)
		,	AwayTeam			varchar(100)
		,	Week				int
		,	Day					varchar(5)
		,	Time				varchar(25)
		,	Date				date
		,	Season				int
		,	HomeResult			varchar(100)
		,	AwayResult			varchar(100)
		,	HomeRecord			varchar(100)
		,	AwayRecord			varchar(100)
		,	HomeScore			int
		,	AwayScore			int
		,	HomeOff1stD			int
		,	HomeOffTotYd		int
		,	HomeOffPassYd		int
		,	HomeOffRushYd		int
		,	HomeOffTO			int
		,	HomeDef1stD			int
		,	HomeDefTotYd		int
		,	HomeDefPassYd		int
		,	HomeDefRushYd		int
		,	HomeDefTO			int
		,	HomeExPointsOff		decimal(5,2)
		,	HomeExPointsDef		decimal(5,2)
		,	HomeExPointsSpecial	decimal(5,2)
		,	AwayOff1stD			int
		,	AwayOffTotYd		int
		,	AwayOffPassYd		int
		,	AwayOffRushYd		int
		,	AwayOffTO			int
		,	AwayDef1stD			int
		,	AwayDefTotYd		int
		,	AwayDefPassYd		int
		,	AwayDefRushYd		int
		,	AwayDefTO			int
		,	AwayExPointsOff		decimal(5,2)
		,	AwayExPointsDef		decimal(5,2)
		,	AwayExPointsSpecial	decimal(5,2)
		,	HomeOddsOpen decimal(5,2)
		,	HomeOddsMin decimal(5,2)
		,	HomeOddsMax decimal(5,2)
		,	HomeOddsClose decimal(5,2)
		,	AwayOddsOpen decimal(5,2)
		,	AwayOddsMin decimal(5,2)
		,	AwayOddsMax decimal(5,2)
		,	AwayOddsClose decimal(5,2)
		,	HomeLineOpen decimal(5,2)
		,	HomeLineMin decimal(5,2)
		,	HomeLineMax decimal(5,2)
		,	HomeLineClose decimal(5,2)
		,	AwayLineOpen decimal(5,2)
		,	AwayLineMin decimal(5,2)
		,	AwayLineMax decimal(5,2)
		,	AwayLineClose decimal(5,2)
		,	HomeLineOddsOpen decimal(5,2)
		,	HomeLineOddsMin decimal(5,2)
		,	HomeLineOddsMax decimal(5,2)
		,	HomeLineOddsClose decimal(5,2)
		,	AwayLineOddsOpen decimal(5,2)
		,	AwayLineOddsMin decimal(5,2)
		,	AwayLineOddsMax decimal(5,2)
		,	AwayLineOddsClose decimal(5,2)
		,	TotalScoreOpen decimal(5,2)
		,	TotalScoreMin decimal(5,2)
		,	TotalScoreMax decimal(5,2)
		,	TotalScoreClose decimal(5,2)
		,	TotalScoreOverOpen decimal(5,2)
		,	TotalScoreOverMin decimal(5,2)
		,	TotalScoreOverMax decimal(5,2)
		,	TotalScoreOverClose decimal(5,2)
		,	TotalScoreUnderOpen decimal(5,2)
		,	TotalScoreUnderMin decimal(5,2)
		,	TotalScoreUnderMax decimal(5,2)
		,	TotalScoreUnderClose decimal(5,2)
		)

		INSERT INTO #tempOdds (
			Date 
		,	HomeTeam 
		,	AwayTeam 
		,	HomeScore 
		,	AwayScore 
		,	Overtime 
		,	PlayoffGame 
		,	NeutralVenue 
		,	HomeOddsOpen 
		,	HomeOddsMin 
		,	HomeOddsMax 
		,	HomeOddsClose 
		,	AwayOddsOpen 
		,	AwayOddsMin 
		,	AwayOddsMax 
		,	AwayOddsClose 
		,	HomeLineOpen 
		,	HomeLineMin 
		,	HomeLineMax 
		,	HomeLineClose 
		,	AwayLineOpen 
		,	AwayLineMin 
		,	AwayLineMax 
		,	AwayLineClose 
		,	HomeLineOddsOpen 
		,	HomeLineOddsMin 
		,	HomeLineOddsMax 
		,	HomeLineOddsClose 
		,	AwayLineOddsOpen 
		,	AwayLineOddsMin 
		,	AwayLineOddsMax 
		,	AwayLineOddsClose 
		,	TotalScoreOpen 
		,	TotalScoreMin 
		,	TotalScoreMax 
		,	TotalScoreClose 
		,	TotalScoreOverOpen 
		,	TotalScoreOverMin 
		,	TotalScoreOverMax 
		,	TotalScoreOverClose 
		,	TotalScoreUnderOpen 
		,	TotalScoreUnderMin 
		,	TotalScoreUnderMax 
		,	TotalScoreUnderClose 
		)
		SELECT
			Date 
		,	HomeTeam 
		,	AwayTeam 
		,	HomeScore 
		,	AwayScore 
		,	Overtime 
		,	PlayoffGame 
		,	NeutralVenue 
		,	HomeOddsOpen 
		,	HomeOddsMin 
		,	HomeOddsMax 
		,	HomeOddsClose 
		,	AwayOddsOpen 
		,	AwayOddsMin 
		,	AwayOddsMax 
		,	AwayOddsClose 
		,	HomeLineOpen 
		,	HomeLineMin 
		,	HomeLineMax 
		,	HomeLineClose 
		,	AwayLineOpen 
		,	AwayLineMin 
		,	AwayLineMax 
		,	AwayLineClose 
		,	HomeLineOddsOpen 
		,	HomeLineOddsMin 
		,	HomeLineOddsMax 
		,	HomeLineOddsClose 
		,	AwayLineOddsOpen 
		,	AwayLineOddsMin 
		,	AwayLineOddsMax 
		,	AwayLineOddsClose 
		,	TotalScoreOpen 
		,	TotalScoreMin 
		,	TotalScoreMax 
		,	TotalScoreClose 
		,	TotalScoreOverOpen 
		,	TotalScoreOverMin 
		,	TotalScoreOverMax 
		,	TotalScoreOverClose 
		,	TotalScoreUnderOpen 
		,	TotalScoreUnderMin 
		,	TotalScoreUnderMax 
		,	TotalScoreUnderClose 
		FROM OddsImport


		INSERT INTO #tempGameData (
			GameDataId			
		,	HomeTeam			
		,	AwayTeam			
		,	Week				
		,	Day					
		,	Time				
		,	Date				
		,	Season				
		,	HomeResult			
		,	AwayResult			
		,	HomeRecord			
		,	AwayRecord			
		,	HomeScore			
		,	AwayScore			
		,	HomeOff1stD			
		,	HomeOffTotYd		
		,	HomeOffPassYd		
		,	HomeOffRushYd		
		,	HomeOffTO			
		,	HomeDef1stD			
		,	HomeDefTotYd		
		,	HomeDefPassYd		
		,	HomeDefRushYd		
		,	HomeDefTO			
		,	HomeExPointsOff		
		,	HomeExPointsDef		
		,	HomeExPointsSpecial	
		,	AwayOff1stD			
		,	AwayOffTotYd		
		,	AwayOffPassYd		
		,	AwayOffRushYd		
		,	AwayOffTO			
		,	AwayDef1stD			
		,	AwayDefTotYd		
		,	AwayDefPassYd		
		,	AwayDefRushYd		
		,	AwayDefTO			
		,	AwayExPointsOff		
		,	AwayExPointsDef		
		,	AwayExPointsSpecial	
		)
		SELECT 
			GameDataId			
		,	HomeTeam			
		,	AwayTeam			
		,	Week				
		,	Day					
		,	Time				
		,	Date				
		,	Season				
		,	HomeResult			
		,	AwayResult			
		,	HomeRecord			
		,	AwayRecord			
		,	HomeScore			
		,	AwayScore			
		,	HomeOff1stD			
		,	HomeOffTotYd		
		,	HomeOffPassYd		
		,	HomeOffRushYd		
		,	HomeOffTO			
		,	HomeDef1stD			
		,	HomeDefTotYd		
		,	HomeDefPassYd		
		,	HomeDefRushYd		
		,	HomeDefTO			
		,	HomeExPointsOff		
		,	HomeExPointsDef		
		,	HomeExPointsSpecial	
		,	AwayOff1stD			
		,	AwayOffTotYd		
		,	AwayOffPassYd		
		,	AwayOffRushYd		
		,	AwayOffTO			
		,	AwayDef1stD			
		,	AwayDefTotYd		
		,	AwayDefPassYd		
		,	AwayDefRushYd		
		,	AwayDefTO			
		,	AwayExPointsOff		
		,	AwayExPointsDef		
		,	AwayExPointsSpecial	
		FROM GameData gd


		UPDATE tgd 
		SET tgd.HomeOddsOpen  = oi.HomeOddsOpen 
		,	tgd.HomeOddsMin  = oi.HomeOddsMin 
		,	tgd.HomeOddsMax  = oi.HomeOddsMax 
		,	tgd.HomeOddsClose  = oi.HomeOddsClose 
		,	tgd.AwayOddsOpen  = oi.AwayOddsOpen 
		,	tgd.AwayOddsMin  = oi.AwayOddsMin 
		,	tgd.AwayOddsMax  = oi.AwayOddsMax 
		,	tgd.AwayOddsClose  = oi.AwayOddsClose 
		,	tgd.HomeLineOpen  = oi.HomeLineOpen 
		,	tgd.HomeLineMin  = oi.HomeLineMin 
		,	tgd.HomeLineMax  = oi.HomeLineMax 
		,	tgd.HomeLineClose  = oi.HomeLineClose 
		,	tgd.AwayLineOpen  = oi.AwayLineOpen 
		,	tgd.AwayLineMin  = oi.AwayLineMin 
		,	tgd.AwayLineMax  = oi.AwayLineMax 
		,	tgd.AwayLineClose  = oi.AwayLineClose 
		,	tgd.HomeLineOddsOpen  = oi.HomeLineOddsOpen 
		,	tgd.HomeLineOddsMin  = oi.HomeLineOddsMin 
		,	tgd.HomeLineOddsMax  = oi.HomeLineOddsMax 
		,	tgd.HomeLineOddsClose  = oi.HomeLineOddsClose 
		,	tgd.AwayLineOddsOpen  = oi.AwayLineOddsOpen 
		,	tgd.AwayLineOddsMin  = oi.AwayLineOddsMin 
		,	tgd.AwayLineOddsMax  = oi.AwayLineOddsMax 
		,	tgd.AwayLineOddsClose  = oi.AwayLineOddsClose 
		,	tgd.TotalScoreOpen  = oi.TotalScoreOpen 
		,	tgd.TotalScoreMin  = oi.TotalScoreMin 
		,	tgd.TotalScoreMax  = oi.TotalScoreMax 
		,	tgd.TotalScoreClose  = oi.TotalScoreClose 
		,	tgd.TotalScoreOverOpen  = oi.TotalScoreOverOpen 
		,	tgd.TotalScoreOverMin  = oi.TotalScoreOverMin 
		,	tgd.TotalScoreOverMax  = oi.TotalScoreOverMax 
		,	tgd.TotalScoreOverClose  = oi.TotalScoreOverClose 
		,	tgd.TotalScoreUnderOpen  = oi.TotalScoreUnderOpen 
		,	tgd.TotalScoreUnderMin  = oi.TotalScoreUnderMin 
		,	tgd.TotalScoreUnderMax  = oi.TotalScoreUnderMax 
		,	tgd.TotalScoreUnderClose  = oi.TotalScoreUnderClose
		FROM #tempGameData tgd
		JOIN #tempOdds oi ON (tgd.HomeTeam = oi.HomeTeam OR tgd.HomeTeam = oi.AwayTeam) --some mismatches exist
						 AND (tgd.AwayTeam = oi.AwayTeam OR tgd.AwayTeam = oi.HomeTeam)
						 AND tgd.HomeScore = oi.HomeScore
						 AND tgd.AwayScore = oi.AwayScore

		UPDATE gd 
		SET gd.HomeOddsOpen  = t.HomeOddsOpen 
		,	gd.HomeOddsMin  = t.HomeOddsMin 
		,	gd.HomeOddsMax  = t.HomeOddsMax 
		,	gd.HomeOddsClose  = t.HomeOddsClose 
		,	gd.AwayOddsOpen  = t.AwayOddsOpen 
		,	gd.AwayOddsMin  = t.AwayOddsMin 
		,	gd.AwayOddsMax  = t.AwayOddsMax 
		,	gd.AwayOddsClose  = t.AwayOddsClose 
		,	gd.HomeLineOpen  = t.HomeLineOpen 
		,	gd.HomeLineMin  = t.HomeLineMin 
		,	gd.HomeLineMax  = t.HomeLineMax 
		,	gd.HomeLineClose  = t.HomeLineClose 
		,	gd.AwayLineOpen  = t.AwayLineOpen 
		,	gd.AwayLineMin  = t.AwayLineMin 
		,	gd.AwayLineMax  = t.AwayLineMax 
		,	gd.AwayLineClose  = t.AwayLineClose 
		,	gd.HomeLineOddsOpen  = t.HomeLineOddsOpen 
		,	gd.HomeLineOddsMin  = t.HomeLineOddsMin 
		,	gd.HomeLineOddsMax  = t.HomeLineOddsMax 
		,	gd.HomeLineOddsClose  = t.HomeLineOddsClose 
		,	gd.AwayLineOddsOpen  = t.AwayLineOddsOpen 
		,	gd.AwayLineOddsMin  = t.AwayLineOddsMin 
		,	gd.AwayLineOddsMax  = t.AwayLineOddsMax 
		,	gd.AwayLineOddsClose  = t.AwayLineOddsClose 
		,	gd.TotalScoreOpen  = t.TotalScoreOpen 
		,	gd.TotalScoreMin  = t.TotalScoreMin 
		,	gd.TotalScoreMax  = t.TotalScoreMax 
		,	gd.TotalScoreClose  = t.TotalScoreClose 
		,	gd.TotalScoreOverOpen  = t.TotalScoreOverOpen 
		,	gd.TotalScoreOverMin  = t.TotalScoreOverMin 
		,	gd.TotalScoreOverMax  = t.TotalScoreOverMax 
		,	gd.TotalScoreOverClose  = t.TotalScoreOverClose 
		,	gd.TotalScoreUnderOpen  = t.TotalScoreUnderOpen 
		,	gd.TotalScoreUnderMin  = t.TotalScoreUnderMin 
		,	gd.TotalScoreUnderMax  = t.TotalScoreUnderMax 
		,	gd.TotalScoreUnderClose  = t.TotalScoreUnderClose 
		FROM #tempGameData t 
		JOIN GameData gd ON gd.GameDataId = t.GameDataId

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH