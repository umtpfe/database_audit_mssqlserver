/* Afficher les transaction en cours pour une base donnees */

SELECT d.transaction_id, d.database_id, d.database_transaction_begin_time, t.session_id, t.is_user_transaction
 FROM sys.dm_tran_database_transactions d 
 INNER JOIN sys.dm_tran_session_transactions t ON d.transaction_id = t.transaction_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 