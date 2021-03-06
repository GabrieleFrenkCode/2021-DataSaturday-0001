/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: JSON_MODIFY: INSERT, UPDATE 
*/


--JSON_MODIFY ( expression , path , newValue )  
--La sintassi di path ? la seguente: [append] [ lax | strict ] $.<json path>


USE JSON_DEMO
GO

--1 Uso di JSON_VALUE e JSON_QUERY 
SELECT 
	ID_UTENTE
	,NOME = JSON_VALUE(JSON_DATA, '$.NOME')  
	,COGNOME = JSON_VALUE(JSON_DATA, '$.COGNOME')
	,USERNAME = JSON_VALUE(JSON_DATA,'$.USERNAME')
	,NUMERI = JSON_QUERY(JSON_DATA, '$.UTENTI_NUMERI')
	,NUMERO_AUTOMOBILI = JSON_QUERY(JSON_DATA, '$.NUMERO_AUTOMOBILI') --Domanda per chi segue il corso...Perch? non torna niente?
	,JSON_DATA --usa https://jsonformatter.org/ per formattare il JSON
FROM
	dbo.UTENTI_JSON
WHERE
	JSON_VALUE(JSON_DATA, 'lax $.NOME') = N'Gabriele'


--2.1 INSERT CON JSON_MODIFY: modalit? strict va in errore perch? il path non esiste
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'strict $.NUMERO_AUTOMOBILI', '50')
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'

--2.2 INSERT CON JSON_MODIFY: modalit? lax aggiunge la nuova property
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'lax $.NUMERO_AUTOMOBILI', '50')
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'

--2.3 INSERT CON JSON_MODIFY: aggiungere una property all'interno di una matrice
DECLARE @UTENTI_NUMERI varchar(100) = N'{"ID_UTENTE_NUMERO":4,"TIPO":"PERSONALE3","CELL":"3409094544"}'
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'append $.UTENTI_NUMERI', JSON_QUERY(@UTENTI_NUMERI))
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'

--3.1 UPDATE CON JSON_MODIFY PER KEY FIELD 
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, '$.NUMERO_AUTOMOBILI', '2')
WHERE
	ID_UTENTE = 1

--3.2 UPDATE CON JSON_MODIFY PER NOME
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'strict $.NUMERO_AUTOMOBILI', '1')
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'

--4.1 DELETE CON JSON_MODIFY: SET DELLA PROPERTY NUMERO_AUTOMOBILI A NULL
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'strict $.NUMERO_AUTOMOBILI', NULL)
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'

--4.2 DELETE CON JSON_MODIFY: CANCELLAZIONE DELLA PROPERTY NUMERO_AUTOMOBILI
UPDATE 
	dbo.UTENTI_JSON
SET 
	JSON_DATA = JSON_MODIFY(JSON_DATA, 'lax $.NUMERO_AUTOMOBILI', NULL)
WHERE
	JSON_VALUE(JSON_DATA, '$.NOME') = N'Gabriele'
