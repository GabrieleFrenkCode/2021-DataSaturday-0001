/*
	Autore: Gabriele Franco
	Descrizione: JSON in SQL SERVER 2019: Clustered columnstore index 
*/
CREATE SEQUENCE SQ_UTENTI_JSON_ID_UTENTE
AS int
	START WITH 1
	INCREMENT BY 1
	CACHE 1000
	NO CYCLE
GO

CREATE TABLE dbo.UTENTI_JSON
(
	ID_UTENTE int NOT NULL CONSTRAINT DF_UTENTI_JSON_ID_UTENTE DEFAULT NEXT VALUE FOR [dbo].[SQ_UTENTI_JSON_ID_UTENTE]
	,JSON_DATA varchar(MAX) NOT NULL CONSTRAINT [CK_JSON_DATA] CHECK(ISJSON(JSON_DATA) = 1)
	,INDEX CCIX CLUSTERED COLUMNSTORE 
) 
GO

INSERT INTO dbo.UTENTI_JSON (JSON_DATA) VALUES 
('{
    "ID_UTENTE": 1,
    "USERNAME": "Gabry",
    "NOME": "Gabriele",
    "COGNOME": "Franco",
    "DATA_DI_NASCITA": "1990-01-01T00:00:00",
    "UTENTI_NUMERI": [
      {
        "ID_UTENTE_NUMERO": 1,
        "TIPO": "UFFICIO",
        "TELEFONO": "3409094543"
      },
      {
        "ID_UTENTE_NUMERO": 2,
        "TIPO": "PERSONALE",
        "TELEFONO": "3409094544"
      }
    ]
  }')
  ,('{
    "ID_UTENTE": 2,
    "USERNAME": "Jack",
    "NOME": "Giacomo",
    "COGNOME": "Gizzi",
    "DATA_DI_NASCITA": "1980-01-01T00:00:00",
    "UTENTI_NUMERI": [
      {
        "ID_UTENTE_NUMERO": 3,
        "TIPO": "UFFICIO",
        "TELEFONO": "3499094543"
      },
      {
        "ID_UTENTE_NUMERO": 4,
        "TIPO": "PERSONALE",
        "TELEFONO": "3499094544"
      }
    ]
  }')
  ,('{
    "ID_UTENTE": 3,
    "USERNAME": "MartinPa",
    "NOME": "Martin",
    "COGNOME": "Pizzi",
    "DATA_DI_NASCITA": "1970-01-01T00:00:00",
    "UTENTI_NUMERI": [
      {
        "ID_UTENTE_NUMERO": 5,
        "TIPO": "UFFICIO",
        "TELEFONO": "3489094543"
      },
      {
        "ID_UTENTE_NUMERO": 6,
        "TIPO": "PERSONALE",
        "TELEFONO": "3489094544"
      }
    ]
  }')