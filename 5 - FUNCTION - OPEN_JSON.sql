/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: OPENJSON 
*/

--1 Uso basic di OPENJSON con oggetto JSON
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1

SELECT 
	[Key]
	,[value]
FROM 
	OPENJSON(@json)

--2 Uso basic di OPENJSON con matrice JSON
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1

SELECT 
	[Key]
	,[value]
FROM 
	OPENJSON(@json, '$.UTENTI_NUMERI')


--3 Uso di OPENJSON con schema esplicito
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1

SELECT *
FROM 
	OPENJSON(@json)
WITH 
(
		ID_UTENTE        int
		,USERNAME        varchar(100)
		,NOME            varchar(100)
		,COGNOME		 varchar(100)
		,DATA_DI_NASCITA date
)

--3.1 Uso di OPENJSON con schema esplicito - Analisi metadati
EXEC sp_describe_first_result_set N'
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1

SELECT *
FROM 
	OPENJSON(@json)
WITH 
(
		ID_UTENTE        int
		,USERNAME        varchar(100)
		,NOME            varchar(100)
		,COGNOME		 varchar(100)
		,DATA_DI_NASCITA date
)'

--4 Uso di OPENJSON con aggiunta di dettagli di un elemento matrice
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1
print @json

SELECT *
FROM 
	OPENJSON(@json) WITH 
	(
			ID_UTENTE        int
			,USERNAME        varchar(100)
			,NOME            varchar(100)
			,COGNOME		 varchar(100)
			,DATA_DI_NASCITA datetime2(3)
			,TIPO			 varchar(100) '$.UTENTI_NUMERI[0].TIPO'
			,NUMERO_UFFICIO	 varchar(100) '$.UTENTI_NUMERI[0].TELEFONO'
	)

--5 Uso di OPENJSON con JSON PATH
DECLARE @json varchar(4000) 
SELECT @json = JSON_DATA FROM dbo.UTENTI_JSON where ID_UTENTE = 1
print @json

SELECT *
FROM 
	OPENJSON(@json, '$.UTENTI_NUMERI') WITH 
	(
		ID_UTENTE_NUMERO int
		,TIPO            varchar(100)
		,TELEFONO        varchar(100)
	)

--6 OPENJSON e dati relazionali
SELECT *
FROM
	dbo.UTENTI_JSON
	CROSS APPLY OPENJSON(JSON_DATA) WITH 
	(
			ID_UTENTE        int
			,USERNAME        varchar(100)
			,NOME            varchar(100)
			,COGNOME		 varchar(100)
			,DATA_DI_NASCITA datetime2(3)
	)
	CROSS APPLY OPENJSON(JSON_DATA, '$.UTENTI_NUMERI') WITH 
	(
		ID_UTENTE_NUMERO int
		,TIPO            varchar(100)
		,TELEFONO        varchar(100)
	)

--6 OPENJSON con dati relazionali e aggrazioni SQL
SELECT 
	COGNOME
	,NOME
	,NUMERI_DI_TELEFONO = COUNT(*) 
FROM
	dbo.UTENTI_JSON
	CROSS APPLY OPENJSON(JSON_DATA) WITH 
	(
			ID_UTENTE        int
			,USERNAME        varchar(100)
			,NOME            varchar(100)
			,COGNOME		 varchar(100)
			,DATA_DI_NASCITA datetime2(3)
	)
	CROSS APPLY OPENJSON(JSON_DATA, '$.UTENTI_NUMERI') WITH 
	(
		ID_UTENTE_NUMERO int
		,TIPO            varchar(100)
		,TELEFONO        varchar(100)
	)
GROUP BY
	COGNOME
	,NOME