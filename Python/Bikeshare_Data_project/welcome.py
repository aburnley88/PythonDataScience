import sys
import helpers as h
import stats as s

APP_TITLE = 'Explore US BikeShare Data'


def welcome_message():
    """
        welcome message
    """
    print("Welcome to ", APP_TITLE)
    city = h.choose_city()
    check_value(city)
    time_filter = h.choose_time_filter()
    check_value(time_filter)
    # match time_filter:
    #     case 'month':
    #         month = h.choose_month()
    #         check_value(month)
    #         s.load_data_filtered_by_month(city, month)
    #     case 'day':
    #         day = h.choose_day()
    #         s.load_data_filtered_by_day(city, day)
    #         check_value(day)
    #     case 'raw data':
    #         s.load_unfiltered_data(city)
    if time_filter == 'month':
        month = h.choose_month()
        check_value(month)
        s.load_data_filtered_by_month(city, month)
    elif time_filter == 'day':
        day = h.choose_day()
        s.load_data_filtered_by_day(city, day)
        check_value(day)
    else:
        s.load_unfiltered_data(city)       
    run_again()


def check_value(val):
    """
        if val is none restart application
    """
    if val is None:
        welcome_message()
    else:
        return False


def run_again():
    """
        Asks user if they would like to run the application again.
   """
    do_again = input("Enter 'y' to run again\n").lower()
    if do_again == 'y':
        welcome_message()
    else:
        print("Good bye 😊")
        sys.exit()


welcome_message()
