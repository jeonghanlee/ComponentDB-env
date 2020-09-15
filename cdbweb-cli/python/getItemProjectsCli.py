#!/usr/bin/env python

"""
Copyright (c) 2020 Lawrence Berkeley National Laboratory
"""

from cdb.common.exceptions.invalidRequest import InvalidRequest
from cdb.common.cli.cdbDbCli import CdbDbCli
from cdb.common.db.api.itemDbApi import ItemDbApi

class GetItemProjectsCli(CdbDbCli):
    def __init__(self):
        CdbDbCli.__init__(self)

    def runCommand(self):
        self.parseArgs(usage="""
    get-item-projects

Description:
    Get all registered Item Projects.
        """)
        api = ItemDbApi()
        projects = api.getItemProjects()
        for project in projects:
            print project.getDisplayString(self.getDisplayKeys(), self.getDisplayFormat())

#######################################################################
# Run command.
if __name__ == '__main__':
    cli = GetItemProjectsCli()
    cli.run()
