#! C:\Perl64\bin\perl.exe

use strict;
use CGI qw(:all);
require './perlTraitement/requete.pl';
require './perlTraitement/programmesRecherche.pl';
require './perlTraitement/config.pl';

my $idRequete;
my $titreA=param("titre");
my $dateA=param("date");
my $categorieA=param("categ");
my $terme=param("terme");

print("content-type : text/html\n\n"); 
print ("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");
print("<html xmlns=\"http://www.w3.org/1999/xhtml\">\n");
print("<head>\n");

print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-15\" />\n");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print("<link rel=\"stylesheet\" href=\"./bootstrap/css/styleRecherche.css\">\n");
print("<!-- Latest compiled and minified JavaScript -->");
print("<script src=\"bootstrap-3.1.1-dist/js/bootstrap.min.js\"></script>");
print("<script type=\"text/javascript\" src=\"./javascript/recherche.js\"></script>\n");
print("<meta name=\"description\" content=\"Wiki SID - Recherche Avancee\" />\n");
print("<meta name=\"keywords\" content=\"Wiki SID Recherche Avancee\" />\n");
print("<title>Wiki SID - Recherche Avancee</title>\n");
print("</head>\n");
print("\n");

print ("<body>\n");

print ("<div id=\"container\">\n");
print ("<div id=\"header\"><center>\n");
print ("<table><tr><td><abbr title=\"Wiki SID\"><img src=\"./bootstrap/img/logomini.jpg\" align=\"left\"></abbr></td><td>\n");
print ("<input type=\"text\" readonly=\"readonly\" class=\"form-control\"name =\"requete\" value=\"Termes : $terme - Titre : $titreA - Categorie : $categorieA - Date : $dateA\" size=\"60\" maxlength=\"30\" />\n");
print ("<a href=\"./accueilRechercheAvancee.pl?titre=$titreA&categ=$categorieA&terme=$terme&date=$dateA\"> <input type=\"submit\" class=\"btn btn-primary\" value =\"Modifier la Recherche\"></a>\n");
print ("</td></tr></table></center>\n");
print ("</div>\n");

print ("<div id=\"content\">\n");
if ($terme ne '') {

	my $date; my $heure;
	my $cheminCollection=&collectionUtilisee();
	my $nomCollection=&nomCollection();

	my $methodeCalcul=&methodeCalculScore();
	($idRequete, $date, $heure)=&insererRequetes($terme);
	my @resultatRequete=&normalisationScores(&evaluerRequeteAvancee($terme,$cheminCollection,$methodeCalcul,$dateA,$titreA,$categorieA));

	my $nbRes=@resultatRequete-1;
	my $i=0;
	if ($resultatRequete[$i][1]!=0){
		do {
			my $idDocument=$resultatRequete[$i][0];
			my $score=$resultatRequete[$i][1];
			my @tag;
						
			&insererRequeteArticle($idRequete, $idDocument, $i+1, $score, $date, $heure, $nomCollection);
			my ($titre, $dateArticle, $url)=&recupererInformations($idDocument,$nomCollection);
			my @categories=&recupererCategories($idDocument,$nomCollection);
			if ($nomCollection eq 'JDG') {
				@tag=&recupererTAG($idDocument,$nomCollection);
			}
			#Affichage des résultats
			print ("<table>\n");
			print ("<tr><th>".$titre." - Article du ".$dateArticle."</th></tr>\n");
			print ("<tr><td><div id=\'". $idDocument ."\'><script type='text/javascript'>CreateListeEtoile(\'". $idDocument . "\','5',\'".$nomCollection."\',\'".$idRequete."\')</script></div>Moyenne : ".&noteMoyenne($idDocument,$nomCollection)."/5     <a href=\"./stat.pl?idDocument=".$idDocument."&collection=".$nomCollection."\" target=\"_blank\"><abbr title=\"Graphiques & Statistiques\"><img src=\"./bootstrap/img/graphique.png\"></abbr></a></td></tr>");
			print ("<tr><td><a href=\"".$url."\">".$url."</a></td></tr>\n");
			print ("<tr><td><u>Catégories</u> : <i>");
			my $compteur=1;
			my $nbElement=@categories;
			foreach my $element (@categories){
				print $element;
				if ($compteur<$nbElement){
					print " - ";
				}
				$compteur++;
			}
			print ("</i></td></tr>\n");
			
			if ($nomCollection eq 'JDG') {
				print ("<tr><td><u>Tags</u> : <i>");
				my $compteur=1;
				my $nbElement=@tag;
				foreach my $element (@tag){
					print $element;
					if ($compteur<$nbElement){
					print " - ";
					}
					$compteur++;
				}
				print ("</i></td></tr>\n");
			}
			print ("</table><br>\n");
			
			$i++;
		}
		until ($resultatRequete[$i][1]==0);
	}
	else {
		print ("<h1>Aucun document pertinent n'a été trouvé...\n</h1><br>");
		print ("<h2>Suggestions :<ul>\n<li>Vérifiez l'orthographe des termes de recherche.</li>\n<li>Essayez d'autres mots.</li>\n<li>Spécifiez moins de mots.</li>\n</ul><\h2>");
	}
}
else {
	print ("<h1>Merci de saisir une requète valide !\n</h1>");
}
print ("</div>\n");
print ("<div id=\"footer\">\n");
print ("<a href=\"#\">Haut de page</a> |\n");
print ("<a href=\"page_accueil.pl\">Retour vers l'accueil</a> |\n");
print ("<a href=\"admin.pl?requete=".$idRequete."\">Administration</a> |\n");
print ("<a href=\"stat.pl?requete=".$idRequete."\">Statistiques</a> |\n");
print ("<a href=\"#\" onclick=\"javascript:open_infos();\">Aide</a>\n");
print ("</div>\n");
print ("</body>\n");
print ("</html>\n");
