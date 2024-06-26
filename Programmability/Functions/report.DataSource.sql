﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[DataSource]() 
RETURNS @PubTable TABLE ( DomName VARCHAR(128), SrvName VARCHAR(128), DbName VARCHAR(128), PubName VARCHAR(128) ) AS
BEGIN
  INSERT INTO @PubTable 
  SELECT DEFAULT_DOMAIN(), @@SERVERNAME, DB_NAME(), USER_NAME();
  RETURN;
END
GO

GRANT SELECT ON [report].[DataSource] TO [FastTrak]
GO