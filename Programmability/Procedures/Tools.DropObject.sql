SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[DropObject]( @ObjectName NVARCHAR(128) ) AS
BEGIN
  IF EXISTS( SELECT name FROM sysobjects where name=@ObjectName AND xtype='U' )
    EXECUTE( 'DROP TABLE ' + @ObjectName )
  ELSE IF EXISTS( SELECT name FROM sysobjects WHERE name=@ObjectName AND xtype='P' )
    EXECUTE( 'DROP PROCEDURE ' + @ObjectName )
END;
GO