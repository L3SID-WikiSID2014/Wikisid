#! C:\Perl64\bin\perl.exe

use DBI;
require './perlTraitement/config.pl';

# HTTP HEADER
print "Content-type: text/html \n\n";

$con=&connexionBDD;
 
# DOCUMENTS LES PLUS SOUMIS
my $docs_soumis = "SELECT		ra.idarticle, ra.collection, a.titre
					FROM		requetes_articles ra, articles a
					WHERE		ra.idarticle = a.idA
					AND			ra.collection = a.collection
					GROUP BY	ra.idarticle, ra.collection, a.titre
					ORDER BY	COUNT(*) DESC LIMIT 5;";
					
my $docs_notes = "SELECT		a.titre, n.note
				FROM		articles a, notations n
				WHERE		a.idA = n.idarticle
				AND			a.collection = n.collection
				ORDER BY	note DESC LIMIT 5;";

my $tag = "	SELECT titre
			FROM articles_tags ta, articles a
			WHERE ta.ida = a.idA
			AND ta.collection = a.collection
			GROUP BY ta.ida, ta.collection, titre
			ORDER BY COUNT(*) DESC LIMIT 5;";
			
my $recent = "	SELECT		titre, dateA
				FROM 		articles
				ORDER BY	dateA DESC LIMIT 5;";
				

# REQUETE
my $req = $con->prepare($docs_soumis);

# EXECUTE THE QUERY
$req->execute();

# BIND TABLE COLUMNS TO VARIABLES
$req->bind_columns(undef, \$idA, \$collection, \$titre);

# REQUETE
my $note = $con->prepare($docs_notes);

# EXECUTE THE QUERY
$note->execute();

# BIND TABLE COLUMNS TO VARIABLES
$note->bind_columns(undef, \$titreN, \$notation);

# REQUETE
my $doc_tag = $con->prepare($tag);

# EXECUTE THE QUERY
$doc_tag->execute();

# BIND TABLE COLUMNS TO VARIABLES
$doc_tag->bind_columns(undef, \$titreT);

# REQUETE
my $doc_recent = $con->prepare($recent);

# EXECUTE THE QUERY
$doc_recent->execute();

# BIND TABLE COLUMNS TO VARIABLES
$doc_recent->bind_columns(undef, \$titreA, \$dateRecent);

print("<html>");
print("<head>");
print("<title>WIKISID</title>");
print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print("</head>");
print("<body id=\"fond\">");
print("<div id=\"recherche\">");
print("<form role=\"form\" action=\"recherche.pl\" method=\"get\">");
print("<div class=\"row\">");
print("<div class=\"col-xs-2\" id=\"recherche\">");
print("<input type=\"text\" name=\"requete\" class=\"form-control\" placeholder=\"Recherche...\" column=\"3\">");
print("</div>");
print("</div>");
print("<div class=\"bouton\" id=\"ok\">");
print("<button type=\"submit\" class=\"btn btn-primary\">Rechercher</button>");
print("</div>");
print("<div class=\"bouton\" id=\"avancee\">");
print("<a href=\"accueilRechercheAvancee.pl\" class=\"btn btn-primary\">Recherche avanc&eacutee</a>");
print("</div>");
print("</form>");
print("</div>");
print("<div class=\"tableau\" id=\"un\">");
print("<table class=\"table table-hover table-striped table-condensed\">");
print("<thead>");
print("<tr>");
print("<th>Les plus taggu&eacutes ...</th>");
print("</tr>");
print("</thead>");
print("<tbody>");

#LOOP THROUGH RESULTS
while($doc_tag->fetch()) {
	print "<tr><td><a>".substr($titreT,0,20)."...</a></td></tr>";
}
print("</tbody>");
print("</table>");
print("</div>");

print("<div class=\"tableau\" id=\"deux\">");
print("<table class=\"table table-hover table-striped table-condensed\">");
print("<thead>");
print("<tr>");
print("<th>Les plus r&eacutecents ...</th>");
print("</tr>");
print("</thead>");
print("<tbody>");

#LOOP THROUGH RESULTS
while($doc_recent->fetch()) {
	print "<tr><td><a>".substr($titreA,0,20)."...</a></td></tr>";
}

print("</tbody>");
print("</table>");
print("</div>");

print("<div class=\"tableau\" id=\"trois\">");
print("<table class=\"table table-hover table-striped table-condensed\">");
print("<thead>");
print("<tr>");
print("<th>Les plus soumis ...</th>");
print("</tr>");
print("</thead>");
print("<tbody>");


#LOOP THROUGH RESULTS
while($req->fetch()) {
	print "<tr><td><a>".substr($titre,0,20)."...</a></td></tr>";
}
print("</tbody>");
print("</table>");
print("</div>");

print("<div class=\"tableau\" id=\"quatre\">");
print("<table class=\"table table-hover table-striped table-condensed\">");
print("<thead>");
print("<tr>");
print("<th>Les mieux not&eacutes ...</th>");
print("</tr>");
print("</thead>");
print("<tbody>");

#LOOP THROUGH RESULTS
while($note->fetch()) {
	print "<tr><td><a>".substr($titreN,0,20)."...</a></td></tr>";
}
print("</tbody>");
print("</table>");
print("</div>");

print("<!-- Latest compiled and minified JavaScript -->");
print("<script src=\"bootstrap-3.1.1-dist/js/bootstrap.min.js\"></script>");
print("</body>");
print("</html>");

# DECONNEXION
$req -> finish;
$con -> disconnect;