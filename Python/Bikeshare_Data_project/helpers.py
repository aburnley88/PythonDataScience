FILTERS = { 1: 'month', 2: 'day', 3: 'raw data'}
DAYS_OF_WEEK = { 1: 'Sunday', 2 : 'Monday', 3: 'Tuesday', 4: 'Wednesday', 5: 'Thursday', 6: 'Friday', 7: 'Saturday'}
MONTHS = { 1: 'January', 2: 'February', 3: 'March', 4: 'April', 5: 'May', 6: 'June' }
APP_CITIES = { 1: 'chicago', 2:'new_york_city', 3:'washington'}
  
def path_builder(arg):
    start = './'
    extension = '.csv'
    items =[ start, arg, extension]
    path = "".join(items)
    return path

def not_in_range(argument):
    print("{} is not in range!{}".format(argument, line_spacing(2)))
    print("Restarting application", line_spacing(3)) 

def run_error_msg(v_error):
    print("\nError:", v_error)
    print("Please make a valid selection")

def convert_hour_mode(hour):
    if hour == 0:
        return "12AM"
    elif hour == 12:
        return "12PM"
    elif hour >=1 and hour <12:
        return "{}AM".format(hour)
    else:
        hour = hour%12
        return "{}PM".format(hour)

def choose_city():
    """
        Returns a city based on user input
    """
    while True:
        try:
            user_choice = int(input("Please enter a number 1-3 for Chicago, New York, or D.C respectively {}".format(line_spacing())))
            if user_choice in APP_CITIES:
                return APP_CITIES[user_choice]
            else:
                not_in_range(user_choice)   
            break
        except ValueError as v_error:
            run_error_msg(v_error)

def choose_time_filter():
    while True:
        try:
            filter_choice = int(input("{}Would you like to filter by month(1), day(2), or not at all(3)?{}".format(line_spacing(2), line_spacing())))
            if filter_choice in FILTERS:
                return FILTERS[filter_choice]
            else:
                not_in_range(filter_choice)
                break
        except ValueError as v_error:
            run_error_msg(v_error)

def choose_month():
    while True:
        try:
            choice = int(input("Please enter a number in range 1-6 for Jan - Jun:{}".format(line_spacing())))
            if choice in MONTHS:
                return choice
            else:
                not_in_range(choice)
                break
        except ValueError as v_error:
            run_error_msg(v_error)

def choose_day():
    while True:
        try:
            choice = int(input("Please enter a number in range 1-7 for Sun-Sat:{}".format(line_spacing())))
            if choice in DAYS_OF_WEEK:
                return choice
            else:
                not_in_range(choice)
                break
        except ValueError as v_error:
            run_error_msg(v_error)

def line_spacing(num_spaces = 1):
    return "\n"*num_spaces

def next_stat():
    print("Calculating next statistic\n")