/* table sans clé primaire */

select distinct t.name, t.object_id from sys.tables t inner join sys.columns c on
t.object_id = c.object_id
where c.object_id not in (select ck.parent_object_id from sys.key_constraints ck );

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */

