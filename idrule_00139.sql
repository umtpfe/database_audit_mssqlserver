/* vérifier les statistiques sur les colonnes d''un utilisateur */

CREATE STATISTICS <nom_colonne>   
ON <table_schema> (<nom_colonne>);  
  
DBCC SHOW_STATISTICS ("<table_schema>",<nom_colonne>);


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = http://courses.cs.tau.ac.il/databases/databases2012b/slides/moreinfo/SQL%20tuning.pdf
etat = 0 */
