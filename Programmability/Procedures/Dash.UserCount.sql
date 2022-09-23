SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[UserCount] AS 
BEGIN 
  
  SELECT
    
    Report.PartitionKey( NULL ) AS PartitionKey,
    Report.RowKeyReverse( TimeAxis ) AS RowKey,
    'WW' AS TimeResolution,
    Dataset.*,
    DataSource.*
  
  FROM
  
    ( SELECT
        Report.StartOfWeek( createdate ) AS TimeAxis,
        MAX(Rnk) AS n
        FROM
           ( SELECT
             su.uid,su.createdate,RANK() OVER( ORDER BY createdate ) AS Rnk
           FROM sys.sysusers su WHERE su.islogin = 1 AND su.uid > 5
         ) ul
       GROUP BY Report.StartOfWeek( createdate )
    ) Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  
  ORDER BY TimeAxis DESC 

END;
GO

GRANT EXECUTE ON [Dash].[UserCount] TO [FastTrak]
GO