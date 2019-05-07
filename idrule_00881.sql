/* Détails sur les utilisateurs */

SELECT s.host_name, a.transaction_begin_time, st.is_user_transaction
FROM sys.dm_tran_session_transactions st
INNER JOIN sys.dm_tran_active_transactions a ON st.transaction_id = a.transaction_id
INNER JOIN sys.dm_exec_sessions s ON st.session_id = s.session_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype = sqlserver
url = NULL
etat = 1 */ 