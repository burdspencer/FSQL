CREATE VIEW ssv_ListTeams
AS
	SELECT TOP(35) HomeTeam
	FROM GameData
	GROUP BY HomeTeam
	ORDER BY HomeTeam 
	ASC