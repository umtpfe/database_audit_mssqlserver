/*taille de clé étrangère différente de taille de clé primaire */







/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1

PENDANT ORACLE :
basetype  = oracle
url = NULL
etat = 1
code:
SELECT c.table_name,
       c.column_name,
       c.constraint_name,
       u.data_type,
       U.DATA_LENGTH,
       U.DATA_PRECISION,
       c1.table_name,
       c1.column_name,
       a1.R_constraint_name,
       u1.data_type,
       U1.DATA_LENGTH,
       U1.DATA_PRECISION
  FROM user_cons_columns c,
       user_constraints a,
       user_cons_columns c1,
       user_constraints a1,
       USER_TAB_COLUMNS u,
       USER_TAB_COLUMNS u1
 WHERE     c.constraint_name = a.constraint_name
       AND c1.constraint_name = a1.constraint_name
       AND a.constraint_type = 'P'
       AND a1.constraint_type = 'R'
       AND c.constraint_name = a1.R_constraint_name
       AND u.table_name = c.table_name
       AND u1.table_name = c1.table_name
       AND u.column_name = c.column_name
       AND u1.column_name = c1.column_name
       AND u.data_precision <> U1.DATA_PRECISION
       AND c.constraint_name IN
              (SELECT A.R_CONSTRAINT_NAME
                 FROM user_cons_columns c, user_constraints a
                WHERE c.constraint_name = a.constraint_name
                      AND constraint_type = 'R')
UNION
SELECT c.table_name,
       c.column_name,
       c.constraint_name,
       u.data_type,
       U.DATA_LENGTH,
       U.DATA_PRECISION,
       c1.table_name,
       c1.column_name,
       a1.R_constraint_name,
       u1.data_type,
       U1.DATA_LENGTH,
       U1.DATA_PRECISION
  FROM user_cons_columns c,
       user_constraints a,
       user_cons_columns c1,
       user_constraints a1,
       USER_TAB_COLUMNS u,
       USER_TAB_COLUMNS u1
 WHERE     c.constraint_name = a.constraint_name
       AND c1.constraint_name = a1.constraint_name
       AND a.constraint_type = 'P'
       AND a1.constraint_type = 'R'
       AND c.constraint_name = a1.R_constraint_name
       AND u.table_name = c.table_name
       AND u1.table_name = c1.table_name
       AND u.column_name = c.column_name
       AND u1.column_name = c1.column_name
       AND U.DATA_LENGTH <> U1.DATA_LENGTH
       AND c.constraint_name IN
              (SELECT A.R_CONSTRAINT_NAME
                 FROM user_cons_columns c, user_constraints a
                WHERE c.constraint_name = a.constraint_name
                      AND constraint_type = 'R')
*/

