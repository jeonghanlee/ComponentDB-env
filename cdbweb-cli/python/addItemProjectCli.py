#!/usr/bin/env python

"""
Copyright (c) 2020 Lawrence Berkeley National Laboratory
"""

from cdb.common.exceptions.invalidRequest import InvalidRequest
from cdb.common.cli.cdbDbCli import CdbDbCli
from cdb.common.db.api.itemDbApi import ItemDbApi

class AddItemProjectCli(CdbDbCli):
    def __init__(self):
        CdbDbCli.__init__(self)
        self.addOption('', '--name', dest='name', help='Item Project Name.')
        self.addOption('', '--description', dest='description', help='Item Project description.')
 
    def checkArgs(self):
        if self.options.name is None:
            raise InvalidRequest('Item Project Name must be provided. Please use --name=PROJECT option.')

    def getName(self):
        return self.options.name

    def getDescription(self):
        return self.options.description

    def runCommand(self):
        self.parseArgs(usage="""
    add-item-project --name=PROJECTPNAME
        [--description=DESCRIPTION]
Description:
    Adds an Item Project into CDB database. This command goes directly to the
    database and must be run from a CDB administrator account.
        """)
        self.checkArgs()
        api = ItemDbApi()
        name = self.getName()
        description = self.getDescription()
        info = api.addItemProject(name, description)
        print info.getDisplayString(self.getDisplayKeys(), self.getDisplayFormat())

#######################################################################
# Run command.
if __name__ == '__main__':
    cli = AddItemProjectCli()
    cli.run()
