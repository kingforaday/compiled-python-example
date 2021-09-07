import os
import logging

logger = logging.getLogger(__name__)

def cleanup():
    """
    Function to be executed upon program termination
    either via clean exit (e.g. SIGINT) or Exception
    """
    logger.critical("Program termination cleanup routine executing.")
    # Using os._exit() to fix a bug in subprocess.popen that causes the
    # interpreter to hang after on regular sys.exit, exit, or quit call.
    os._exit(0)
