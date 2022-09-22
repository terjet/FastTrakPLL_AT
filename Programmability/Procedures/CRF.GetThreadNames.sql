SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetThreadNames]( @FormId INT ) AS
BEGIN
    DECLARE @ThreadId INT;
    SELECT @ThreadId = mf.ThreadTypeId FROM MetaForm mf WHERE mf.FormId = @FormId;
    DECLARE @ThreadNames VARCHAR(MAX);
    SELECT @ThreadNames = mtt.ThreadNames FROM MetaThreadType mtt WHERE mtt.V = @ThreadId;
    SELECT value AS ThreadName FROM STRING_SPLIT( @ThreadNames, ';' );
END;
GO

GRANT EXECUTE ON [CRF].[GetThreadNames] TO [FastTrak]
GO