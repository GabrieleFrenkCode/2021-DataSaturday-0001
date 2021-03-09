/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: fulltext index
*/

--1 Creazione del catalog fulltext
CREATE FULLTEXT CATALOG jsonFullTextCatalog
 
--2 Crezione del full text index nella tabella [dbo].[TEST_JSON_DATA_SCHEMALESS]
CREATE FULLTEXT INDEX ON dbo.TEST_JSON_DATA_SCHEMALESS (JSON_DATA)
KEY INDEX PK_TEST_JSON_DATA_SCHEMALESS
ON jsonFullTextCatalog


--SELECT * FROM sys.fulltext_catalogs
--SELECT * FROM sys.dm_fts_index_population where database_id = db_id()
--SELECT * FROM sys.fulltext_indexes

SELECT TOP 1000
	Nome = JSON_VALUE(JSON_DATA, '$.Nome') 
	,Cognome = JSON_VALUE(JSON_DATA, '$.Cognome')
	,DataNascita = JSON_VALUE(JSON_DATA,'$.DataNascita')
	,ComuneNascita = JSON_VALUE(JSON_DATA, '$.ComuneNascita')
	,ProvinciaNascita = JSON_VALUE(JSON_DATA, '$.ProvinciaNascita')
	,RegioneNascita = JSON_VALUE(JSON_DATA, '$.RegioneNascita')
	,CAP = JSON_VALUE(JSON_DATA, '$.CAP')
	,DescrizioneComune = JSON_VALUE(JSON_DATA, '$.DescrizioneComune')
	--,JSON_DATA --usa https://jsonformatter.org/ per formattare il JSON
FROM
	dbo.TEST_JSON_DATA_SCHEMALESS
WHERE 
	CONTAINS(JSON_DATA, 'Cerreto')
	--AND 
	--FREETEXT(JSON_DATA, 'clima rigidi')


	 