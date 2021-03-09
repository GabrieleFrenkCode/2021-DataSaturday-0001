/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: nonclustered index
*/

--1 Get da JSON 
SELECT *
FROM
	dbo.TEST_JSON_DATA_SCHEMALESS
WHERE
	JSON_VALUE(JSON_DATA, 'lax $.Nome') = N'Sirio'

--2 Verifico la dimensione dello spazio
EXEC sp_spaceused 'dbo.TEST_JSON_DATA_SCHEMALESS' --data = 567632 KB, index = 358912 KB

--3 Aggiungo colonna calcolata
ALTER TABLE dbo.TEST_JSON_DATA_SCHEMALESS
ADD Nome AS JSON_VALUE(JSON_DATA,'$.Nome')

ALTER TABLE dbo.TEST_JSON_DATA_SCHEMALESS
ADD Cognome AS JSON_VALUE(JSON_DATA,'$.Cognome')

--4 Query di selezione senza indice
SELECT * FROM TEST_JSON_DATA_SCHEMALESS WHERE Nome = 'Sirio'

--4 Query di selezione senza indice
SELECT Nome, Cognome FROM TEST_JSON_DATA_SCHEMALESS WHERE Nome = 'Sirio'

--5 Crezione dell'indice nonclustered 
DROP INDEX IF EXISTS TEST_JSON_DATA_SCHEMALESS.IX_TEST_JSON_DATA_SCHEMALESS_Nome
GO

CREATE NONCLUSTERED INDEX IX_TEST_JSON_DATA_SCHEMALESS_Nome ON dbo.TEST_JSON_DATA_SCHEMALESS 
(
	Nome ASC
) 

--6 Query di selezione con indice senza colonne incluse (per visualizzare fa lookup)
SELECT Nome, Cognome FROM dbo.TEST_JSON_DATA_SCHEMALESS WHERE Nome = 'Sirio'

--7 Crezione dell'indice nonclustered with included columns
CREATE NONCLUSTERED INDEX IX_TEST_JSON_DATA_SCHEMALESS_Nome
ON dbo.TEST_JSON_DATA_SCHEMALESS 
(
	NOME ASC
) 
INCLUDE
(
	Cognome
)WITH (SORT_IN_TEMPDB = ON, DROP_EXISTING = ON)

--8 Query di selezione con covered index (Prestare attenzione ai campi aggiunti nell'include)
SELECT Nome, Cognome FROM dbo.TEST_JSON_DATA_SCHEMALESS WHERE Nome = 'Sirio'
