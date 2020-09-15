#!/usr/bin/env python

"""
Copyright (c) 2020 Lawrence Berkeley National Laboratory
"""

from cdb.common.exceptions.invalidRequest import InvalidRequest
from cdb.common.cli.cdbDbCli import CdbDbCli
from cdb.common.db.api.userDbApi import UserDbApi

class GetGroupsCli(CdbDbCli):
    def __init__(self):
        CdbDbCli.__init__(self)

    def runCommand(self):
        self.parseArgs(usage="""
    get-groups

Description:
    Get all registered Groups.
        """)
        api = UserDbApi()
        groups = api.getUserGroups()
        for group in groups:
           print group.getDisplayString(self.getDisplayKeys(), self.getDisplayFormat())

#######################################################################
# Run command.
if __name__ == '__main__':
    cli = GetGroupsCli()
    cli.run()
