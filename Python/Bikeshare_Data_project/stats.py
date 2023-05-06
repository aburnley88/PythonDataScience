import datetime as dt
import time as t
import pandas as pd
import helpers as h

def load_data_filtered_by_month(city, month):
    """ takes in a city value and a month value and displays stats based off the values"""
    path = h.path_builder(city)
    df = pd.read_csv(path)
    load_cols(df)
    df = df.loc[df['Start Time'].dt.month == month]
    show_time_stats_month_filter(df)
    run_stats(df, city)   

def load_data_filtered_by_day(city, day):
    """takes in city and day value and displays stats based off the values"""
    path = h.path_builder(city)
    df = pd.read_csv(path)
    load_cols(df)
    df = df.loc[df['Start Time'].dt.day == day]
    show_time_stats_day_filter(df)
    run_stats(df, city)

def load_unfiltered_data(city):
    """ displays unfiltered data based on a given city"""
    path = h.path_builder(city)
    df = pd.read_csv(path)
    load_cols(df)
    show_time_stats_no_filter(df)
    run_stats(df, city)

def load_cols(df):
    """ adds calculated columns to a DataFrame that are used regardless of filter"""
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['Month'] = df['Start Time'].dt.month_name()
    df['Start Hour'] = df['Start Time'].dt.hour
    df['Weekday'] = df['Start Time'].dt.day_name()
    return df

def run_stats(df, city):
    """ displays stats in a specific order"""
    h.next_stat()
    show_stations_stats(df)
    h.next_stat()
    show_travel_time_stats(df)
    show_user_info_stats(df)
    show_raw_data(city)

def calculate_hour_mode(df):
    """ calculates and returns a mode of the hour column"""
    most_pop_hr = df['Start Hour'].mode()[0]
    converted = h.convert_hour_mode(most_pop_hr)
    return converted

def calculate_day_mode(df):
    """ calculates and returns a mode of the day column"""
    most_pop_day = df['Weekday'].mode()[0]
    return most_pop_day

def calculate_month_mode(df):
    """ calculates and returns a mode of the month column"""
    most_pop_month = df['Month'].mode()[0]
    return most_pop_month

def calculate_start_station_mode(df):
    """ calculates and returns a mode of the start station column"""
    start_station_mode = df['Start Station'].mode()[0]
    return start_station_mode

def calculate_end_station_mode(df):
    """ calculates and returns a mode of the end station column"""
    end_station_mode = df['End Station'].mode()[0]
    return end_station_mode
def calculate_route_mode(df):
    """ Creates a route column based off start and stop stations and returns a mode of
        the created station
    """
    df['Route'] = (df['Start Station'] + ' - '+ df['End Station'])
    route_mode = str(df['Route'].mode()[0])
    return route_mode

def calc_avg_travel_time(df):
    """calculates the mean for trip duration columns"""
    avg_time = df['Trip Duration'].mean()
    avg_time = (str(int(avg_time//60)) + 'minute(s) ' +
                        str(int(avg_time % 60)) + 'second(s)')
    return avg_time

def show_time_stats_month_filter(df):
    """when the filter is on month this method is called to calculate stats relative
        to popular times of travel
    """
    start_time = t.time()
    print("Displaying popular times of travel\n")
    hr_mode = calculate_hour_mode(df)
    day_mode = calculate_day_mode(df)
    print("The most popular hour is: {} ".format(hr_mode))
    print("The most popular day of the week is: {}".format(day_mode))
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_time_stats_day_filter(df):
    start_time = t.time()
    print("Displaying popular times of travel\n")
    hr_mode = calculate_hour_mode(df)
    month_mode = calculate_day_mode(df)
    print("The most popular hour is: {} ".format(hr_mode))
    print("The most popular month is: {}".format(month_mode))
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_time_stats_no_filter(df):
    start_time = t.time()
    print("Displaying popular times of travel\n")
    hr_mode = calculate_hour_mode(df)
    day_mode = calculate_day_mode(df)
    month_mode = calculate_month_mode(df)
    print("The most popular hour is: {} ".format(hr_mode))
    print("The most popular day of the week is: {}".format(day_mode))
    print("The most popular month is: {}".format(month_mode))
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_stations_stats(df):
    start_time = t.time()
    print("Displaying popular station data\n")
    pop_start_station = calculate_start_station_mode(df)
    pop_end_station = calculate_end_station_mode(df)
    most_common_route = calculate_route_mode(df)
    print("The most popular starting station is: {}".format(pop_start_station))
    print("The most popular ending station is: {}".format(pop_end_station))
    print("The most common route is: {}".format(most_common_route))
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_travel_time_stats(df):
    """show travel time stats"""
    start_time = t.time()
    print("Calculating travel time statistics...")
    total_travel_time = df['Trip Duration'].sum()
    total_travel_time = (str(int(total_travel_time//86400)) +
                         'day(s) ' +
                         str(int((total_travel_time % 86400)//3600)) +
                         'hour(s) ' +
                         str(int(((total_travel_time % 86400) % 3600)//60)) +
                         'minute(s) ' +
                         str(int(((total_travel_time % 86400) % 3600) % 60)) +
                         'second(s)')
    avg_travel_time = calc_avg_travel_time(df)
    print("The total travel time for the selected filter is: {}".format(total_travel_time))
    print("The average travel time for the selected filter is {}".format(avg_travel_time))
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_user_info_stats(df):
    """show user info stats"""
    start_time = t.time()
    print("Calculating user statistics...")
    user_types = df.groupby(['User Type'])['User Type'].count()
    print("The user type stats are: {}".format(user_types))
    try:
        genders = df.groupby(['Gender'])['Gender'].count()
        print("The count of genders is: {}".format(genders))
    except:
        print("No gender data for the selected city")
    try:
        earliest_birth_year = sorted(df.groupby(['Birth Year'])['Birth Year'])[0][0]
        latest_birth_year = sorted(df.groupby(['Birth Year'])['Birth Year'], reverse=True)[0][0]
        most_common_birth_year = df['Birth Year'].mode()[0]
        print("The earliest birth year is: {}".format(earliest_birth_year))
        print("The latest birth year is: {}".format(latest_birth_year))
        print("The most common birth year is: {}".format(most_common_birth_year))
    except:
        print("No birth year for the selected city")
    print("\nThis took {} seconds.".format((t.time() - start_time)))

def show_raw_data(city):
    """show raw data option"""
    path = h.path_builder(city)
    df = pd.read_csv(path)
    show_data = input("Enter 'y' if you would like to see raw data\n")
    x = 0
    if show_data.lower() == 'y':
        print(df[x:x+5])
        while True:
            show_more = input("Enter 'y' to see more data\n")
            if show_more.lower() == 'y':
                 print(df[x:x+5])
            else:
                break


    
    
       

            
            