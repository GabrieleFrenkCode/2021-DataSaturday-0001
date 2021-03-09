USE [JSON_DEMO]
GO

SET NOCOUNT ON
DECLARE @SQL nvarchar(max)

DECLARE @VALUE varchar(10) = 'Gabriele_1'

SELECT @SQL = '
SELECT J.* 
FROM 
	OPENROWSET(BULK N''C:\Users\UT0T198\Desktop\Documenti\CredemTel\Pillole DB\Pillole - 3 - JSON\Script\DATI JSON\'+@VALUE+'.json'', SINGLE_CLOB) T
	CROSS APPLY OPENJSON(T.BulkColumn) WITH 
	(
			Nome	           varchar(100)
			,Cognome	       varchar(100)
			,DataNascita       varchar(100)
			,ComuneNascita     varchar(100)
			,ProvinciaNascita  varchar(100)
			,RegioneNascita    varchar(100)
			,CAP               char(5)
			,DescrizioneComune varchar(500)
	) AS J'

EXEC sp_executesql @SQL WITH RESULT SETS
( 
	(
		Nome	           varchar(100)
		,Cognome	       varchar(100)
		,DataNascita       varchar(100)
		,ComuneNascita     varchar(100)
		,ProvinciaNascita  varchar(100)
		,RegioneNascita    varchar(100)
		,CAP               char(5)
		,DescrizioneComune varchar(500)
	)
)

SET NOCOUNT ON
DECLARE @SQL nvarchar(max)

DECLARE @VALUE varchar(100) = 'Gabriele_1'

SELECT @SQL = '
SELECT J.[Value] 
FROM 
	OPENROWSET(BULK N''C:\Users\UT0T198\Desktop\Documenti\CredemTel\Pillole DB\Pillole - 3 - JSON\Script\DATI JSON\'+@VALUE+'.json'', SINGLE_CLOB) T
	CROSS APPLY OPENJSON(T.BulkColumn) J '

EXEC sp_executesql @SQL WITH RESULT SETS
( 
	(
		[JSON_DATA] varchar(4000) NOT NULL
	)
)
