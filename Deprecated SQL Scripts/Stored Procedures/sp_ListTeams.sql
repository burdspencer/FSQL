CREATE PROCEDURE sp_ListTeams
AS
BEGIN
	SELECT * FROM 
	(VALUES
	('Arizona Cardinals','ARI','https://static.www.nfl.com/image/private/f_auto/league/u9fltoslqdsyao8cpm0k'),
('Atlanta Falcons','ATL','https://static.www.nfl.com/image/private/f_auto/league/d8m7hzpsbrl6pnqht8op'),
('Baltimore Ravens','BAL','https://res.cloudinary.com/nflleague/image/private/f_auto/league/ucsdijmddsqcj1i9tddd'),
('Buffalo Bills','BUF','https://res.cloudinary.com/nflleague/image/private/f_auto/league/giphcy6ie9mxbnldntsf'),
('Carolina Panthers','CAR','https://static.www.nfl.com/image/private/f_auto/league/ervfzgrqdpnc7lh5gqwq'),
('Chicago Bears','CHI','https://static.www.nfl.com/image/private/f_auto/league/ra0poq2ivwyahbaq86d2'),
('Cinncinati Bengals','CIN','https://res.cloudinary.com/nflleague/image/private/f_auto/league/okxpteoliyayufypqalq'),
('Cleveland Browns','CLE','https://static.www.nfl.com/image/private/f_auto/league/ieid8hoygzdlmzo0tnf6'),
('Dallas Cowboys','DAL','https://static.www.nfl.com/image/private/f_auto/league/ieid8hoygzdlmzo0tnf6'),
('Denver Broncos','DEN','https://res.cloudinary.com/nflleague/image/private/f_auto/league/t0p7m5cjdjy18rnzzqbx'),
('Detroit Lions','DET','https://res.cloudinary.com/nflleague/image/private/f_auto/league/ocvxwnapdvwevupe4tpr'),
('Green Bay Packers','GB','https://res.cloudinary.com/nflleague/image/private/f_auto/league/gppfvr7n8gljgjaqux2x'),
('Houston Texans','HOU','https://static.www.nfl.com/image/private/f_auto/league/bpx88i8nw4nnabuq0oob'),
('Indianapolis Colts','IND','https://static.www.nfl.com/image/private/f_auto/league/ketwqeuschqzjsllbid5'),
('Jacksonville Jaguars','JAX','https://res.cloudinary.com/nflleague/image/private/f_auto/league/qycbib6ivrm9dqaexryk'),
('Kansas City Chiefs','KC','https://res.cloudinary.com/nflleague/image/private/f_auto/league/ujshjqvmnxce8m4obmvs'),
('Los Angeles','LA','https://static.www.nfl.com/image/private/f_auto/league/ayvwcmluj2ohkdlbiegi'),
('Los Angeles Chargers','LAC','https://static.www.nfl.com/image/private/f_auto/league/dhfidtn8jrumakbogeu4'),
('Las Vegas Raiders','LV','https://static.www.nfl.com/image/private/f_auto/league/gzcojbzcyjgubgyb6xf2'),
('Miami Dolphins','MIA','https://res.cloudinary.com/nflleague/image/private/f_auto/league/lits6p8ycthy9to70bnt'),
('Minnesota Vikings','MIN','https://res.cloudinary.com/nflleague/image/private/f_auto/league/teguylrnqqmfcwxvcmmz'),
('New England Patriots','NE','https://res.cloudinary.com/nflleague/image/private/f_auto/league/moyfxx3dq5pio4aiftnc'),
('New Orleans Saints','NO','https://static.www.nfl.com/image/private/f_auto/league/grhjkahghjkk17v43hdx'),
('New York Giants','NYG','https://res.cloudinary.com/nflleague/image/private/f_auto/league/t6mhdmgizi6qhndh8b9p'),
('New York Jets','NYJ','https://static.www.nfl.com/image/private/f_auto/league/ekijosiae96gektbo4iw'),
('Oakland Raiders','OAK','https://static.www.nfl.com/image/private/f_auto/league/gzcojbzcyjgubgyb6xf2'),
('Philadelphia Eagles','PHI','https://res.cloudinary.com/nflleague/image/private/f_auto/league/puhrqgj71gobgdkdo6uq'),
('Pittsburgh Steelers','PIT','https://res.cloudinary.com/nflleague/image/private/f_auto/league/xujg9t3t4u5nmjgr54wx'),
('San Diego Chargers','SD','https://static.www.nfl.com/image/private/f_auto/league/dhfidtn8jrumakbogeu4'),
('Seattle Seahawks','SEA','https://res.cloudinary.com/nflleague/image/private/f_auto/league/gcytzwpjdzbpwnwxincg'),
('San Francisco 49ers','SF','https://res.cloudinary.com/nflleague/image/private/f_auto/league/dxibuyxbk0b9ua5ih9hn'),
('St. Louis Rams','STL','https://static.www.nfl.com/image/private/f_auto/league/ayvwcmluj2ohkdlbiegi'),
('Tampa Bay Buccaneers','TB','https://static.www.nfl.com/image/private/f_auto/league/v8uqiualryypwqgvwcih'),
('Tennessee Titans','TEN','https://static.www.nfl.com/image/private/f_auto/league/pln44vuzugjgipyidsre'),
('Washington Commanders','WAS','https://static.www.nfl.com/image/private/f_auto/league/xymxwrxtyj9fhaemhdyd')) as a (FullName,TeamCode,LogoURL)

END

