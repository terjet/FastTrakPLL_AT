SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[NegateUser] (@UserId INT) AS
BEGIN
  DECLARE @TableSchema NVARCHAR(128);
  DECLARE @TableName NVARCHAR(128);
  DECLARE @ColumnName NVARCHAR(128);
  DECLARE @UserName NVARCHAR(128);
  DECLARE @NegUser INT;
  DECLARE @SqlCmd VARCHAR(512);
  SELECT @UserName = UserName
  FROM dbo.UserList
  WHERE UserId = @UserId;
  IF @UserName = USER_NAME(@UserId)
  BEGIN
    RAISERROR ('You can not negate a valid user!', 16, 1)
    RETURN -1;
  END;
  SELECT @NegUser = MIN(UserId)
  FROM dbo.UserList;
  IF @NegUser > 0
    SET @NegUser = 0;
  SET @NegUser = @NegUser - 1;
  -- Create the negated user
  INSERT INTO dbo.UserList (UserId, PersonId, CreatedAt, CreatedBy, CenterId, ProfId, UserName, OldUserId)
      SELECT @NegUser, PersonId, CreatedAt, CreatedBy, CenterId, ProfId, UserName, UserId
      FROM dbo.UserList
      WHERE UserId = @UserId;
  -- Find columns to update
  DECLARE cur_columns CURSOR FOR
  SELECT
    t.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.COLUMN_NAME
  FROM INFORMATION_SCHEMA.COLUMNS c
  JOIN INFORMATION_SCHEMA.TABLES t
    ON t.TABLE_NAME = c.TABLE_NAME
    AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
  WHERE c.COLUMN_NAME IN (
  'CreatedBy', 'SignedBy', 'PausedBy', 'PulledBy', 'StopBy', 'FormOwner', 'UpgradedBy', 'UpdatedBy', 'StartedBy', 'RestartBy', 'ChangedBy', 'LockedBy', 'UserId', 'ClosedBy', 'HandledBy', 'DeletedBy', 'DisabledBy', 'PrintedBy', 'RequestedBy', 'TakenBy', 'MemberId' )
  AND t.TABLE_NAME <> 'UserList'
  AND t.TABLE_TYPE = 'BASE TABLE';
  OPEN cur_columns;
  -- Update all columns from list
  FETCH NEXT FROM cur_columns INTO @TableSchema, @TableName, @ColumnName;
  WHILE @@fetch_status = 0
  BEGIN
    SET @SqlCmd = 'UPDATE ' + @TableSchema + '.' + @TableName + ' SET ' + @ColumnName + '=' + CONVERT(VARCHAR, @NegUser) + ' WHERE ' + @ColumnName + '=' + CONVERT(VARCHAR, @UserId);
    EXECUTE (@SqlCmd);
    FETCH NEXT FROM cur_columns INTO @TableSchema, @TableName, @ColumnName;
  END
  CLOSE cur_columns;
  DEALLOCATE cur_columns;
  DELETE FROM dbo.UserList
  WHERE UserId = @UserId;
END
GO