# CDB Web CLI

## Commands

### User / Group

* `add-group.bash`       :
* `get-groups.bash`      :

* `add-user.bash`        : Add a new user into `user_info` table in MariaDB `$(DB_NAME)`. This command goes directly to the MairaDB with `$(DB_USER)` permission. Users in $(GROUPID) can do this job.
* `get-users.bash`       : Show all users
* `get-user.bash`        : Get an user information (id, username, its name, email, description)
* `get-user-groups.bash` : Show all user groups.

### Item / Log

* `add-item-project.bash`  :
* `get-item-projects.bash` :

* `add-item-log-entry.bash` :
* `add-item-property.bash`  :

* `get-item.bash`      : Get an Item information
* `get-item-logs.bash` :  Get the log entries for an item with a qrId

* `delete-item-properties.bash` : Delete property values from an item with an id.

* `update-log.bash` : Update attributes of a log entry.
* `delete-log.bash` : Remove a log entry.

## Trouble Shooting

* Please check the systemd status `systemctl status cdbweb`

```bash
<urlopen error [Errno 111] Connection refused>
```
