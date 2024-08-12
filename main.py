import nfl_data_py as nfl
import pandas as pd
import pyarrow.feather as f
import os
from datetime import datetime
import numpy as np

pd.set_option("future.no_silent_downcasting", True)

# Record the start time
start_time = datetime.now()


def current_nfl_season():
    today = datetime.today()
    year = today.year

    # Define the start and end dates of the season
    season_start = datetime(year, 4, 1)
    season_end = datetime(year + 1, 3, 30)

    if today >= season_start and today <= datetime(year, 12, 31):
        return [year]
    else:
        return [year - 1]


def ReadDFFromFeather(filepath):
    read_df = f.read_feather(filepath)
    return read_df


def WriteFeatherFromDF(df, filepath):
    if not checkFileExists(filepath):
        # Write the DataFrame to a feather file
        f.write_feather(df, filepath)
        print(f"Data written to {filepath}")
    else:
        print(f"{filepath} already exists, aborting write attempt.")


def checkFileExists(filepath):
    return os.path.exists(filepath)


def deleteFileIfExists(filepath):
    if os.path.exists(filepath):
        os.remove(filepath)


def readFileIfExists(filepath):
    if not isinstance(filepath, tuple) and os.path.exists(filepath):
        return pd.read_feather(filepath)
    else:
        return None


past_years = range(1999, 2023)
current_year = current_nfl_season()
loaded_dataframes = {}

# Dictionary to store DataFrame names and their corresponding import and clean functions
past_dataframes_info = {
    "pbp_df_past": ("pbp_pastDF.feather", nfl.import_pbp_data, nfl.clean_nfl_data),
    "weekly_df_past": (
        "weekly_pastDF.feather",
        nfl.import_weekly_data,
        nfl.clean_nfl_data,
    ),
    "seasonal_df_past": (
        "seasonal_pastDF.feather",
        nfl.import_seasonal_data,
        nfl.clean_nfl_data,
    ),
    "seasonalroster_df_past": (
        "seasonalroster_pastDF.feather",
        nfl.import_seasonal_rosters,
        nfl.clean_nfl_data,
    ),
    "weeklyroster_df_past": (
        "weeklyroster_pastDF.feather",
        nfl.import_weekly_rosters,
        nfl.clean_nfl_data,
    ),
    "wintotals_df_past": (
        "wintotals_pastDF.feather",
        nfl.import_win_totals,
        nfl.clean_nfl_data,
    ),
    "sclines_df_past": (
        "sclines_pastDF.feather",
        nfl.import_sc_lines,
        nfl.clean_nfl_data,
    ),
    "officials_df_past": (
        "officials_pastDF.feather",
        nfl.import_officials,
        nfl.clean_nfl_data,
    ),
    "draftpicks_df_past": (
        "draftpicks_pastDF.feather",
        nfl.import_draft_picks,
        nfl.clean_nfl_data,
    ),
    "draftvalues_df_past": (
        "draftvalues_pastDF.feather",
        nfl.import_draft_values,
        nfl.clean_nfl_data,
    ),
    "teamdesc_df_past": (
        "teamdesc_pastDF.feather",
        nfl.import_team_desc,
        nfl.clean_nfl_data,
    ),
    "schedule_df_past": (
        "schedule_pastDF.feather",
        nfl.import_schedules,
        nfl.clean_nfl_data,
    ),
    "combine_df_past": (
        "combine_pastDF.feather",
        nfl.import_combine_data,
        nfl.clean_nfl_data,
    ),
    "ids_df_past": ("ids_pastDF.feather", nfl.import_ids, nfl.clean_nfl_data),
    "ngs_df_past": ("ngs_pastDF.feather", nfl.import_ngs_data, nfl.clean_nfl_data),
    "injuries_df_past": (
        "injuries_pastDF.feather",
        nfl.import_injuries,
        nfl.clean_nfl_data,
    ),
    "qbr_df_past": ("qbr_pastDF.feather", nfl.import_qbr, nfl.clean_nfl_data),
    "seasonalrushpfr_df_past": (
        "seasonalrushpfr_pastDF.feather",
        lambda years: nfl.import_seasonal_pfr("rush", years),
        nfl.clean_nfl_data,
    ),
    "seasonalpasspfr_df_past": (
        "seasonalpasspfr_pastDF.feather",
        lambda years: nfl.import_seasonal_pfr("pass", years),
        nfl.clean_nfl_data,
    ),
    "seasonalrecpfr_df_past": (
        "seasonalrecpfr_pastDF.feather",
        lambda years: nfl.import_seasonal_pfr("rec", years),
        nfl.clean_nfl_data,
    ),
    "weeklyrushpfr_df_past": (
        "weeklyrushpfr_pastDF.feather",
        lambda years: nfl.import_weekly_pfr("rush", years),
        nfl.clean_nfl_data,
    ),
    "weeklypasspfr_df_past": (
        "weeklypasspfr_pastDF.feather",
        lambda years: nfl.import_weekly_pfr("pass", years),
        nfl.clean_nfl_data,
    ),
    "weeklyrecpfr_df_past": (
        "weeklyrecpfr_pastDF.feather",
        lambda years: nfl.import_weekly_pfr("rec", years),
        nfl.clean_nfl_data,
    ),
    "snapcounts_df_past": (
        "snapcounts_pastDF.feather",
        nfl.import_snap_counts,
        nfl.clean_nfl_data,
    ),
    "ftndata_df_past": (
        "ftndata_pastDF.feather",
        nfl.import_ftn_data,
        nfl.clean_nfl_data,
    ),
}
current_dataframes_info = {
    "pbp_df_current": (
        "pbp_CurrentDF.feather",
        nfl.import_pbp_data,
        nfl.clean_nfl_data,
    ),
    "weekly_df_current": (
        "weekly_CurrentDF.feather",
        nfl.import_weekly_data,
        nfl.clean_nfl_data,
    ),
    "seasonal_df_current": (
        "seasonal_CurrentDF.feather",
        nfl.import_seasonal_data,
        nfl.clean_nfl_data,
    ),
    "seasonalroster_df_current": (
        "seasonalroster_CurrentDF.feather",
        nfl.import_seasonal_rosters,
        nfl.clean_nfl_data,
    ),
    "weeklyroster_df_current": (
        "weeklyroster_CurrentDF.feather",
        nfl.import_weekly_rosters,
        nfl.clean_nfl_data,
    ),
    "wintotals_df_current": (
        "wintotals_CurrentDF.feather",
        nfl.import_win_totals,
        nfl.clean_nfl_data,
    ),
    "sclines_df_current": (
        "sclines_CurrentDF.feather",
        nfl.import_sc_lines,
        nfl.clean_nfl_data,
    ),
    "officials_df_current": (
        "officials_CurrentDF.feather",
        nfl.import_officials,
        nfl.clean_nfl_data,
    ),
    "draftpicks_df_current": (
        "draftpicks_CurrentDF.feather",
        nfl.import_draft_picks,
        nfl.clean_nfl_data,
    ),
    "draftvalues_df_current": (
        "draftvalues_CurrentDF.feather",
        nfl.import_draft_values,
        nfl.clean_nfl_data,
    ),
    "teamdesc_df_current": (
        "teamdesc_CurrentDF.feather",
        nfl.import_team_desc,
        nfl.clean_nfl_data,
    ),
    "schedule_df_current": (
        "schedule_CurrentDF.feather",
        nfl.import_schedules,
        nfl.clean_nfl_data,
    ),
    "combine_df_current": (
        "combine_CurrentDF.feather",
        nfl.import_combine_data,
        nfl.clean_nfl_data,
    ),
    "ids_df_current": ("ids_CurrentDF.feather", nfl.import_ids, nfl.clean_nfl_data),
    "ngs_df_current": (
        "ngs_CurrentDF.feather",
        nfl.import_ngs_data,
        nfl.clean_nfl_data,
    ),
    "injuries_df_current": (
        "injuries_CurrentDF.feather",
        nfl.import_injuries,
        nfl.clean_nfl_data,
    ),
    "qbr_df_current": ("qbr_CurrentDF.feather", nfl.import_qbr, nfl.clean_nfl_data),
    "seasonalrushpfr_df_current": (
        "seasonalrushpfr_CurrentDF.feather",
        lambda year: nfl.import_seasonal_pfr("rush", year),
        nfl.clean_nfl_data,
    ),
    "seasonalpasspfr_df_current": (
        "seasonalpasspfr_CurrentDF.feather",
        lambda year: nfl.import_seasonal_pfr("pass", year),
        nfl.clean_nfl_data,
    ),
    "seasonalrecpfr_df_current": (
        "seasonalrecpfr_CurrentDF.feather",
        lambda year: nfl.import_seasonal_pfr("rec", year),
        nfl.clean_nfl_data,
    ),
    "weeklyrushpfr_df_current": (
        "weeklyrushpfr_CurrentDF.feather",
        lambda year: nfl.import_weekly_pfr("rush", year),
        nfl.clean_nfl_data,
    ),
    "weeklypasspfr_df_current": (
        "weeklypasspfr_CurrentDF.feather",
        lambda year: nfl.import_weekly_pfr("pass", year),
        nfl.clean_nfl_data,
    ),
    "weeklyrecpfr_df_current": (
        "weeklyrecpfr_CurrentDF.feather",
        lambda year: nfl.import_weekly_pfr("rec", year),
        nfl.clean_nfl_data,
    ),
    "snapcounts_df_current": (
        "snapcounts_CurrentDF.feather",
        nfl.import_snap_counts,
        nfl.clean_nfl_data,
    ),
    "ftndata_df_current": (
        "ftndata_CurrentDF.feather",
        nfl.import_ftn_data,
        nfl.clean_nfl_data,
    ),
}


def refreshCurrentData_NFL():
    written_files = []
    for df_name, (filename, import_func, clean_func) in current_dataframes_info.items():
        # Delete the file if it exists
        deleteFileIfExists(filename)

        # Import and clean the DataFrame
        try:
            df = import_func(current_year)
            df = clean_func(df)
            WriteFeatherFromDF(df, filename)
            written_files.append(filename)
            # Assign the DataFrame to the corresponding variable name
            globals()[df_name] = df
        except Exception as e:
            print(f"Error processing {df_name}: {e}")

    return written_files


def refreshPastData_NFL():
    for df_name, (filename, import_func, clean_func) in past_dataframes_info.items():
        if not checkFileExists(filename):
            # Import and clean the DataFrame
            try:
                df = import_func(past_years)
                df = clean_func(df)
                # Assign the DataFrame to the corresponding variable name
                WriteFeatherFromDF(df, filename)
                globals()[df_name] = df
            except Exception as e:
                print(f"Error processing {df_name}: {e}")


def loadPastData_NFL():
    # Load DataFrames from past_dataframes_info
    for df_name, (filepath, _, _) in past_dataframes_info.items():
        df = readFileIfExists(filepath)
        if df is not None:
            globals()[df_name] = df


def loadCurrentData_NFL():
    # Load DataFrames from current_dataframes_info
    for df_name, (filepath, _, _) in current_dataframes_info.items():
        df = readFileIfExists(filepath)
        if df is not None:
            globals()[df_name] = df


def print_dataframe_variables():
    global_variables = globals()
    dataframe_variables = [
        var_name
        for var_name in global_variables
        if isinstance(global_variables[var_name], pd.DataFrame)
    ]
    print("DataFrame variables:")
    for var in dataframe_variables:
        print(var)


def IP_threshold_test(threshold, odds):
    if threshold > odds:
        return 0
    elif threshold <= odds:
        return 1

def ConvertDecimalToAmericanOdds(odds):
    if odds > 0:
        return (odds/100) + 1
    elif odds < 0:
        return (100/abs(odds)) + 1 #for negative odds, abs must be used
    else:
        return 0
    
def ConvertImpliedProbabilityToDecimalOdds(probability): #probability decimal
    if probability > 0: 
        return (1/probability) #1 divided by the probability divided by 100
    else:
        return 0
    
if __name__ == "__main__":
    schedule_df_past = pd.DataFrame()
    # refreshPastData_NFL()
    # refreshCurrentData_NFL()
    loadPastData_NFL()
    # loadCurrentData_NFL()

    # print(schedule_df_past)

    years = schedule_df_past["season"].unique()
    years.sort()

# convert all odds to decimal
    schedule_df_past["home_moneyline_decimal"] = schedule_df_past["home_moneyline"].apply(
        ConvertDecimalToAmericanOdds
    )
    schedule_df_past["away_moneyline_decimal"] = schedule_df_past["away_moneyline"].apply(
        ConvertDecimalToAmericanOdds
    )
    schedule_df_past["home_spread_odds_decimal"] = schedule_df_past["home_spread_odds"].apply(
        ConvertDecimalToAmericanOdds
    )
    schedule_df_past["away_spread_odds_decimal"] = schedule_df_past["away_spread_odds"].apply(
        ConvertDecimalToAmericanOdds
    )

# implied probability calcs
    for season in years:

        #total games in season
        num_of_games = schedule_df_past[(schedule_df_past["season"] == season)][
            "game_id"
        ].count()

        # M1 home team wins outright when favorite
        num_of_home_ml_fav_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] < schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] > schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()


        #M2 home team wins outright when underdog
        num_of_home_ml_dog_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] > schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] > schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()

        # M3 away team wins outright when favorite
        num_of_away_ml_fav_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] > schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] < schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()


        # M4 away team wins outright when underdog
        num_of_away_ml_dog_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] < schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] < schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()

        # M5 home team wins outright when moneyline is even
        num_of_home_ml_split_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] == schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] > schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()

        # M6 away team wins outright when moneyline is even
        num_of_away_ml_split_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_moneyline_decimal"] == schedule_df_past["away_moneyline_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] < schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()

        # M7 number of ties
        num_of_ties = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_score"] == schedule_df_past["away_score"]
            )  # home team wins
            & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
        ]["game_id"].count()

        # S1 home team covers when favorite
        num_of_home_spread_fav_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_spread_odds_decimal"] < schedule_df_past["away_spread_odds_decimal"]
            )  # home team is favorite
            & (
                schedule_df_past["home_score"] + schedule_df_past['spread_line'] > schedule_df_past["away_score"]
            )  # home team covers
            & (np.isnan(schedule_df_past["home_spread_odds_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_spread_odds_decimal"]) == False)
        ]["game_id"].count()


        #S2 home team covers when underdog
        num_of_home_spread_dog_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_spread_odds_decimal"] > schedule_df_past["away_spread_odds_decimal"]
            )  # home team is underdog
            & (
                schedule_df_past["home_score"] + schedule_df_past['spread_line'] > schedule_df_past["away_score"]
            )  # home team covers
            & (np.isnan(schedule_df_past["home_spread_odds_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_spread_odds_decimal"]) == False)
        ]["game_id"].count()

        # S3 away team covers when favorite
        num_of_away_spread_fav_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_spread_odds_decimal"] > schedule_df_past["away_spread_odds_decimal"]
            )  # away team is favorite
            & (
                schedule_df_past["home_score"] < schedule_df_past["away_score"] + schedule_df_past['spread_line']
            )  # away team covers
            & (np.isnan(schedule_df_past["home_spread_odds_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_spread_odds_decimal"]) == False)
        ]["game_id"].count()


        # S4 away team covers when underdog
        num_of_away_spread_dog_wins = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                schedule_df_past["home_spread_odds_decimal"] < schedule_df_past["away_spread_odds_decimal"]
            )  # away team is favorite
            & (
                schedule_df_past["home_score"] < schedule_df_past["away_score"] + schedule_df_past['spread_line']
            )  # away team covers
            & (np.isnan(schedule_df_past["home_spread_odds_decimal"]) == False)
            & (np.isnan(schedule_df_past["away_spread_odds_decimal"]) == False)
        ]["game_id"].count()

        #moneyline thresholds
        home_ml_fav_threshold = num_of_home_ml_fav_wins / num_of_games #M1
        home_ml_fav_threshold = ConvertImpliedProbabilityToDecimalOdds(home_ml_fav_threshold)
        # print(num_of_home_ml_fav_wins, ' / ', num_of_games, ' = ', home_ml_fav_threshold)

        home_ml_dog_threshold = num_of_home_ml_dog_wins / num_of_games #M2
        home_ml_dog_threshold = ConvertImpliedProbabilityToDecimalOdds(home_ml_dog_threshold)
        # print(num_of_home_ml_dog_wins, ' / ', num_of_games, ' = ', home_ml_dog_threshold)

        away_ml_fav_threshold = num_of_away_ml_fav_wins / num_of_games #M3
        away_ml_fav_threshold = ConvertImpliedProbabilityToDecimalOdds(away_ml_fav_threshold)
        # print(num_of_away_ml_fav_wins, ' / ', num_of_games, ' = ', away_ml_fav_threshold)

        away_ml_dog_threshold = num_of_away_ml_dog_wins / num_of_games #M4
        away_ml_dog_threshold = ConvertImpliedProbabilityToDecimalOdds(away_ml_dog_threshold)
        # print(num_of_away_ml_dog_wins, ' / ', num_of_games, ' = ', away_ml_dog_threshold)

        home_ml_split_threshold = num_of_home_ml_split_wins / num_of_games #M5
        home_ml_split_threshold = ConvertImpliedProbabilityToDecimalOdds(home_ml_split_threshold)

        away_ml_split_threshold = num_of_away_ml_split_wins / num_of_games #M6
        away_ml_split_threshold = ConvertImpliedProbabilityToDecimalOdds(away_ml_split_threshold)

        tie_threshold = num_of_ties / num_of_games #M7
        tie_threshold = ConvertImpliedProbabilityToDecimalOdds(away_ml_split_threshold)

        #spread thresholds 
        home_spread_fav_threshold = ConvertImpliedProbabilityToDecimalOdds((num_of_home_spread_fav_wins / num_of_games)) # S1
        home_spread_dog_threshold = ConvertImpliedProbabilityToDecimalOdds((num_of_home_spread_dog_wins / num_of_games)) # S2
        away_spread_fav_threshold = ConvertImpliedProbabilityToDecimalOdds((num_of_away_spread_fav_wins / num_of_games)) # S3
        away_spread_dog_threshold = ConvertImpliedProbabilityToDecimalOdds((num_of_away_spread_dog_wins / num_of_games)) # S4
        
        # print('-------')
        # print(season)
        # print('-------')
        # print(home_ml_fav_threshold)
        # print(home_ml_dog_threshold)
        # print(away_ml_fav_threshold)
        # print(away_ml_dog_threshold)
        # print(home_spread_fav_threshold)
        # print(home_spread_dog_threshold)
        # print(away_spread_fav_threshold)
        # print(away_spread_dog_threshold)
        # print('-------')
        #total thresholds 
        #WIP


# make picks
        ml_pick_cases = [
            
                (
                    (schedule_df_past["season"] == season)
                    & (
                        schedule_df_past["home_moneyline_decimal"]
                        < schedule_df_past["away_moneyline_decimal"]
                    )
                    & (schedule_df_past["home_moneyline_decimal"] > home_ml_fav_threshold)
                ),
                (
                    (schedule_df_past["season"] == season)
                    & (
                        schedule_df_past["home_moneyline_decimal"]
                        > schedule_df_past["away_moneyline_decimal"]
                    )
                    & (schedule_df_past["away_moneyline"] > away_ml_fav_threshold)
                ),
                (
                    (schedule_df_past["season"] == season)
                    & (
                        schedule_df_past["home_moneyline_decimal"]
                        < schedule_df_past["away_moneyline_decimal"]
                    )
                    & (schedule_df_past["away_moneyline_decimal"] > away_ml_dog_threshold)
                ),
                (
                    (schedule_df_past["season"] == season)
                    & (
                        schedule_df_past["home_moneyline_decimal"]
                        > schedule_df_past["away_moneyline_decimal"]
                    )
                    & (schedule_df_past["home_moneyline_decimal"] > home_ml_dog_threshold)
                )
        ]
        ml_pick_picks = ["H", "A", "H", "A"]
        schedule_df_past["ml_pick"] = np.select(
            ml_pick_cases, ml_pick_picks, default="N"
        )

        # grade picks
        ml_grade_cases = [
            (schedule_df_past["ml_pick"] == "H")
            & (schedule_df_past["home_score"] > schedule_df_past["away_score"]),
            (schedule_df_past["ml_pick"] == "A")
            & (schedule_df_past["home_score"] < schedule_df_past["away_score"]),
        ]
        ml_grade_values = [1, 1]

        schedule_df_past["ml_pick_correct"] = np.select(
            ml_grade_cases, ml_grade_values, default=0
        )

        # moneyline home grading
        schedule_df_past["ml_pick_winnings"] = schedule_df_past["ml_pick"].where(
            (
                (schedule_df_past["ml_pick_correct"] == 1)
                & (schedule_df_past["home_score"] > schedule_df_past["away_score"])
                & (schedule_df_past["ml_pick"] == "H")
                & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
                & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
            ),
            schedule_df_past["away_moneyline_decimal"]
        )
        # moneyline away grading
        schedule_df_past["ml_pick_winnings"] = schedule_df_past[
            "ml_pick_winnings"
        ].where(
            (
                (schedule_df_past["ml_pick_correct"] == 1)
                & (schedule_df_past["home_score"] < schedule_df_past["away_score"])
                & (schedule_df_past["ml_pick"] == "A")
                & (np.isnan(schedule_df_past["home_moneyline_decimal"]) == False)
                & (np.isnan(schedule_df_past["away_moneyline_decimal"]) == False)
            ),
            schedule_df_past["home_moneyline_decimal"]
        )

        schedule_df_past["ml_pick_winnings"] = schedule_df_past[
            "ml_pick_winnings"
        ].where(
            (
                (schedule_df_past["ml_pick_correct"] == 1) # what?
                & (
                    (schedule_df_past["ml_pick"] == "H")
                    | (schedule_df_past["ml_pick"] == "A")
                )
            ),
            -1 #double what?
        )

        num_of_ml_picks = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (
                (schedule_df_past["ml_pick"] == "H")
                | (schedule_df_past["ml_pick"] == "A")
            )
        ]["game_id"].count()

        num_of_ml_picks_correct = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (schedule_df_past["ml_pick_correct"] == 1)
        ]["ml_pick_correct"].sum()

        sum_of_ml_picks_winnings = schedule_df_past[
            (schedule_df_past["season"] == season)
            & (schedule_df_past["ml_pick_correct"] == 1)
        ]["ml_pick_winnings"].sum()

        print(
           season,
           "--",
           round((num_of_ml_picks_correct / num_of_ml_picks) * 100, 2),
           "--",
           num_of_ml_picks_correct,
           "--",
           num_of_ml_picks,
           "--",
           round(sum_of_ml_picks_winnings,2),
        )

        #todo 
        #spread pick logic
        #spread pick grading logic
        #why is the moneyline logic suddenly only picking 10 games per season? check IP conversion logic

        
    #  print(schedule_df_past[schedule_df_past["season"] == 2022].head(3)[['home_moneyline_decimal','away_moneyline_decimal','home_score','away_score','ml_pick','ml_pick_correct','ml_pick_winnings']])
    # print(schedule_df_past[(schedule_df_past["season"] == 2022)]['spread_line'].unique())
        # home_ml_underdog_wins.head(50))