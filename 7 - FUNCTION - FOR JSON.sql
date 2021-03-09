/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: FOR JSON AUTO E PATH
*/

--1 FOR JSON AUTO su singola tabella
SELECT *
FROM	
	dbo.UTENTI
FOR JSON AUTO

--2 FOR JSON AUTO su tabelle in JOIN
SELECT *
FROM	
	dbo.UTENTI U
	INNER JOIN UTENTI_NUMERI N ON N.ID_UTENTE = U.ID_UTENTE
FOR JSON AUTO


--3 FOR JSON PATH su singola tabella
--ROOT. Per aggiungere un unico elemento di primo livello all'output JSON
--INCLUDE_NULL_VALUES. Per includere valori Null nell'output JSON . Se non si specifica questa opzione
--                      l'output non include le proprietà JSON per i valori NULL. Per altre informazioni
--WITHOUT_ARRAY_WRAPPER. Per rimuovere le parentesi quadre che racchiudono l'output JSON della clausola FOR JSON
                         --Usare questa opzione per generare un singolo oggetto JSON come output da un risultato a riga singola.
                         --Se non si specifica questa opzione, l'output JSON viene formattato come una matrice,
						 --ovvero è racchiuso tra parentesi quadre. 
						 --Con questa opzione il JSON potrebbe non essere valido.
SELECT 
	*
FROM	
	dbo.UTENTI 
FOR JSON PATH

--3 FOR JSON PATH su tabelle in JOIN (vedi esempi con ROOT, WITHOUT_ARRAY_WRAPPER e INCLUDE_NULL_VALUES)

--3.1 ROOT
SELECT 
	U.*
	,N.TIPO
	,N.TELEFONO
FROM	
	dbo.UTENTI U
	INNER JOIN UTENTI_NUMERI N ON N.ID_UTENTE = U.ID_UTENTE
FOR JSON PATH
,ROOT('UTENTI')
--,WITHOUT_ARRAY_WRAPPER
--,INCLUDE_NULL_VALUES

--3.2 WITHOUT_ARRAY_WRAPPER
SELECT 
	U.*
	,N.TIPO
	,N.TELEFONO
FROM	
	dbo.UTENTI U
	INNER JOIN UTENTI_NUMERI N ON N.ID_UTENTE = U.ID_UTENTE
FOR JSON PATH
--,ROOT('UTENTE')
,WITHOUT_ARRAY_WRAPPER
--,INCLUDE_NULL_VALUES

--3.3 INCLUDE_NULL_VALUES
INSERT INTO dbo.UTENTI (USERNAME, NOME, COGNOME, DATA_DI_NASCITA) 
VALUES ('Simo33', 'Simone', 'Test', '1980-01-01')
SELECT * FROM dbo.UTENTI

SELECT 
	U.*
	,N.TIPO
	,N.TELEFONO
FROM	
	dbo.UTENTI U
	LEFT JOIN UTENTI_NUMERI N ON N.ID_UTENTE = U.ID_UTENTE
FOR JSON PATH
--,ROOT('UTENTE')
--,WITHOUT_ARRAY_WRAPPER
,INCLUDE_NULL_VALUES



