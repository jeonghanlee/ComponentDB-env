#!/usr/bin/env python

"""
Copyright (c) 2020 Lawrence Berkeley National Laboratory
"""

from cdb.common.exceptions.invalidRequest import InvalidRequest
from cdb.common.cli.cdbDbCli import CdbDbCli
from cdb.common.db.api.userDbApi import UserDbApi

class AddGroupCli(CdbDbCli):
    def __init__(self):
        CdbDbCli.__init__(self)
        self.addOption('', '--name', dest='name', help='Group Name.')
        self.addOption('', '--description', dest='description', help='Group description.')
 
    def checkArgs(self):
        if self.options.name is None:
            raise InvalidRequest('Group Name must be provided. Please use --name=GROUPNAME option.')

    def getName(self):
        return self.options.name

    def getDescription(self):
        return self.options.description

    def runCommand(self):
        self.parseArgs(usage="""
    add-group --name=GROUPNAME
        [--description=DESCRIPTION]
Description:
    Adds a group into CDB database. This command goes directly to the
    database and must be run from a CDB administrator account.
        """)
        self.checkArgs()
        api = UserDbApi()
        name = self.getName()
        description = self.getDescription()
        info = api.addGroup(name, description)
        print info.getDisplayString(self.getDisplayKeys(), self.getDisplayFormat())

#######################################################################
# Run command.
if __name__ == '__main__':
    cli = AddGroupCli()
    cli.run()
