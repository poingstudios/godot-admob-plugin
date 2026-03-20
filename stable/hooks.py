import datetime

def on_config(config, **kwargs):
    if 'copyright' in config:
        current_year = str(datetime.date.today().year)
        config['copyright'] = config['copyright'].replace('{current_year}', current_year)
    return config
