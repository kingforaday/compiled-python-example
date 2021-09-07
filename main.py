#!/usr/local/bin/python
import os
import atexit
import helpers
import logger
import logging
import threading
from sighandler import SIGHANDLER

logger = logging.getLogger("main")
atexit.register(helpers.cleanup)
pause  = threading.Event()

if __name__ == "__main__":
    try:
        logger.all("Simple Python Compiled Program Example")
        logger.all("(c) ACME Example, Inc. 2021-2022. All rights reserved, worldwide.")
        while not pause.is_set() :
            pause.wait(10)
            logger.all("relooping...")
    except Exception as e:
        logger.critical(str(e))
    except:
        logger.critical("General exception occurred.")
    finally:
        exit(0)
