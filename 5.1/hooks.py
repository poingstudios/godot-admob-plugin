import datetime

def on_config(config, **kwargs):
    current_year = str(datetime.date.today().year)
    if 'copyright' in config:
        config['copyright'] = config['copyright'].replace('{current_year}', current_year)
    if 'extra' not in config:
        config['extra'] = {}
    config['extra']['current_year'] = current_year
    return config

