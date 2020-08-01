# The setup from scatch, this query returns null
# This username is not the same as DB_USER even if we use the same name
SELECT username 
FROM user_info 
INNER JOIN user_user_group ON user_info.id = user_user_group.user_id
INNER JOIN user_group on user_group.id = user_user_group.user_group_id 
WHERE user_group.name = 'CDB_ADMIN' AND user_info.password IS not null;
