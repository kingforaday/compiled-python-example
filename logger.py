import logging
import logging.config

logging.ALL   = 55
logging.TRACE = 5
logging.addLevelName(logging.ALL, "ALL")
logging.addLevelName(logging.TRACE, "TRACE")

def _trace(self, msg, *args, **kwargs):
    self.log(logging.TRACE, msg, *args, **kwargs)

def _all(self, msg, *args, **kwargs):
    self.log(logging.ALL, msg, *args, **kwargs)

logging.Logger.all = _all
logging.Logger.trace = _trace

logging.config.dictConfig({
                'version': 1,
                'disable_existing_loggers': False,
                'formatters': {
                    'default': {
                        'format': '%(asctime)s %(name)s [%(levelname)s]: %(message)s'
                    },
                },
                'handlers': {
                    'stream': {
                        'formatter': 'default',
                        'class': 'logging.StreamHandler',
                    },
                    'file': {
                        'filename': 'output.log',
                        'class': 'logging.handlers.RotatingFileHandler',
                        'maxBytes': 1048576,
                        'backupCount': 3,
                        'formatter': 'default'
                    }
                },
                'loggers': {
                    '': {
                        'handlers': ['stream', 'file'],
                        'level': 'INFO',
                        'propagate': True
                    }
                }
            })

