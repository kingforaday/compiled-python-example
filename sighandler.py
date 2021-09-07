import os
import sys
import signal
import logging

from threading import Event


class SIGHANDLER():

    def __init__(self, iptables=None, pause=None):
        self._pause    = pause
        signal.signal(signal.SIGHUP,  self.refresh)
        signal.signal(signal.SIGINT,  self.graceful_exit)
        signal.signal(signal.SIGTERM, self.graceful_exit)
        self.logger = logging.getLogger(__name__)

    def graceful_exit(self, signal, frame):
        self.logger.critical('Caught signal, exiting')
        if type(self._pause) == type(Event()):
            # Set the thread Event flag and exit main's while loop
            self._pause.set()
        else:
            # Will run the atexit cleanup routine
            exit(0)

    def refresh(self, signal, frame):
        self.logger.info('refreshing something...')
        self.logger.info('done')
