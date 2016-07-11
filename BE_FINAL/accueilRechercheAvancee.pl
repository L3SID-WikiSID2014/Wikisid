#! C:\Perl64\bin\perl.exe

require './perlTraitement/config.pl';
use DBI;
use CGI qw(:all);

my $titreA=param("titre");
my $dateA=param("date");
my $categorieA=param("categ");
my $terme=param("terme");
# HTTP HEADER
print "Content-type:text/html \n\n";

# CONNEXION
my $con = &connexionBDD();		

print("<html>");
print("<head>");
print("<title>Wiki GEEK SID - Recherche Avanc&eacute;e</title>");

print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">");
print("<meta name=\"description\" content=\"Wiki GEEK SID - Avanc&eacute;e\" />\n");
print("<meta name=\"keywords\" content=\"Wiki GEEK SID Avanc&eacute;e\" />\n");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");


print("</head>");


print("<body id=\"recherche_av\">");
print("<img id=\"logo\" src=\"bootstrap/img/logo1.png\" alt=\"\"/>");
print("<form action=\"rechercheAvancee.pl\" method=\"get\" class=\"form-horizontal\" role=\"form\">");
print("<div id=\"rech\">");
print("<div class=\"form-group\">");
print("<label class=\"col-sm-2 control-label\">Requ&ecircte</label>");
print("<div class=\"col-sm-3\">");
print("<input type=\"text\" class=\"form-control\" name=\"terme\" placeholder=\"Requete...\" value=\"$terme\">");
print("</div>");
print("</div>");
print("<div class=\"form-group\">");
print("<label class=\"col-sm-2 control-label\">Titre</label>");
print("<div class=\"col-sm-3\">");
print("<input name=\"titre\" type=\"text\" class=\"form-control\" placeholder=\"Titre...\" value=\"$titreA\" >");
print("</div>");
print("</div>");
print("<div class=\"form-group\">");
print("<label class=\"col-sm-2 control-label\">Cat&eacutegorie</label>");
print("<div class=\"col-sm-3\">");
print("<select name=\"categ\" class=\"form-control\">");
print("<option value=\"$categorieA\">Indiff&eacuterente</option>");

# Cat&eacutegories
my $categ = "SELECT titreC FROM categories";

# REQUETE
my $req = $con->prepare($categ);

# EXECUTE THE QUERY
$req->execute();

# BIND TABLE COLUMNS TO VARIABLES
$req->bind_columns(undef, \$categorie);

#LOOP THROUGH RESULTS
while($req->fetch()) {
   print "<option value=\"$categorie\">$categorie</option>";
} 
print("</select>");
print("</div>");
print("</div>");
print("<div class=\"form-group\">");
print("<label class=\"col-sm-2 control-label\">Date</label>");
print("<div class=\"col-sm-3\">");
print("<input name=\"date\" type=\"date\" class=\"form-control\" placeholder=\"AAAA-MM-JJ\" value=\"$dateA\">");
print("</div>");
print("</div>");
print("<div class=\"form-group\">");
print("<div class=\"col-sm-offset-2 col-sm-10\">");
  print("<button type=\"submit\" class=\"btn btn-primary\">Rechercher</button>");
print("</div>");
print("</div>");
print("</div>");
print("</form>");

print("</body>");

print("</html>");


# DECONNEXION
&deconnexionBDD($req,$con);