#! C:\Perl64\bin\perl.exe

use strict; 
use warnings;

# print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
print("content-type : text/html\n\n "); 
print("<html>"); 
print("<head>\n");
print("<meta name=\"description\" content=\"Wiki GEEK SID - Administration\" />\n");
print("<meta name=\"keywords\" content=\"Wiki GEEK SID Administration\" />\n");
print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print("<link rel=\"stylesheet\" type=\"text/css\" href=\"bootstrap/css/stat.css\" />");
print("<script src=\"bootstrap/js/jquery.min.js\"></script>");
print("<script src=\"bootstrap/js/bootstrap.min.js\"></script>");
print ("<script language=\"JavaScript\" type=\"text/javascript\">
\$('.collapse').collapse();
\$(\".alert\").alert();
\$('#myModal').modal('show');
function sendToCollection(form, dest) {
     var datas = \$(form).serialize();
     \$.ajax({
          type: 'GET',      // envoi des données en GET
		  dataType: 'html',
          url: \$(form).attr('action'),     // envoi au fichier défini dans l'attribut action
          data: datas,     // sélection des champs à envoyer
          success: function(data) {     // callback en cas de succès
               \$(dest + ' .modal-body').html(data);
               \$(dest).modal('show');
          }
     });
return false;
}
</script>");
print("<title>Wiki GEEK SID - Administration</title>\n");
print("</head>\n");
print("<body id=\"stat_logo\">");
print("<div id=\"centre\">");

 

my %formulaire=();
foreach my $element (split(/&/, $ENV{'QUERY_STRING'})){
	my ($variable, $valeur)=split(/=/, $element);
	#print ("<p>$valeur</p>");
	$valeur =~ s/\+/ /g;
	$valeur =~ s/%(..)/pack('c',hex($1))/eg;
	$formulaire{$variable} = $valeur;

	#print ("<p>$formulaire{$variable}<p>");
}



print("<div class=\"page-header\">");
print("<h1>Page Administrateur <small>Statistiques et param&eacutetrages</small></h1>");
print("</div>");

print("<h2 id=\"titre\">Statistiques</h2>\n");


print("<div class=\"panel-group\" id=\"accordion\">");
print("<div class=\"panel panel-default\">");
print("<div class=\"panel-heading\">");
print("<h4 class=\"panel-title\">");
print("<a data-toggle=\"collapse\" data-parent=\"#accordion\" data-target=\"#collapseOne\">");
print("R&eacutepartition des scores doc/req");
print("</a>");
print("</h4>");
print("</div>");
print("<div id=\"collapseOne\" class=\"panel-collapse collapse\">");
print("<div class=\"panel-body\">");
print("<form action=\"repScore.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Afficher\">");
print("</form>");
print("</div>");
print("</div>");
print("</div>");
print("<div class=\"panel panel-default\">");
print("<div class=\"panel-heading\">");
print("<h4 class=\"panel-title\">");
print("<a data-toggle=\"collapse\" data-parent=\"#accordion\" data-target=\"#collapseTwo\">");
print("Distribution des termes");
print("</a>");
print("</h4>");
print("</div>");
print("<div id=\"collapseTwo\" class=\"panel-collapse collapse\">");
print("<div class=\"panel-body\">");
print("<table class=\"table table-bordered\">");
print("<thead>");
print("<tr>");
print("<th>Graphique repr&eacutesentant l'apparition des termes de la requ&ecircte dans tous les documents de la collection</th>");
print("<th>Graphique repr&eacutesentant le nombre d'occurences des termes de la requ&ecircte dans tous les documents retourn&eacutes</th>");
print("</tr>");
print("</thead>");
print("<tbody>");
print("<tr>");
print("<td>");
print("<form action=\"graph1.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<div id=\"centrer\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Afficher\">");
print("</div>");
print("</form>");
print("</td>");
print("<td>");
print("<form action=\"graph2.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<div id=\"centrer\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Afficher\">");
print("</div>");
print("</form>");
print("</td>");
print("</tr>");
print("</tbody>");
print("</table>");
print("</div>");
print("</div>");
print("</div>");
print("<div class=\"panel panel-default\">");
print("<div class=\"panel-heading\">");
print("<h4 class=\"panel-title\">");
print("<a data-toggle=\"collapse\" data-parent=\"#accordion\" data-target=\"#collapseThree\">");
print("Pr&eacutecision / Rappel (\histogrammes)");
print("</a>");
print("</h4>");
print("</div>");
print("<div id=\"collapseThree\" class=\"panel-collapse collapse\">");
print("<div class=\"panel-body\">");
print("<form action=\"rappel_precision.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Afficher\">");
print("</form>");
print("</div>");
print("</div>");
print("</div>");
print("</div>");

# print("Tableau representant l'apparition de tous les termes dans tous les documents retournes");
# print("<form action=\"tableau1.pl\" method=\"get\">");
# print("<input type=\"submit\" value=\"Afficher\">");
# print("</form>");

print("<h2 id=\"titre\">Param&eacutetrage</h2>\n");

print("<div class=\"panel-group\" id=\"accordionDEUX\">");
print("<div class=\"panel panel-default\">");
print("<div class=\"panel-heading\">");
print("<h4 class=\"panel-title\">");
print("<a data-toggle=\"collapse\" data-parent=\"#accordionDEUX\" data-target=\"#collapseFour\">");
print("Changement de collection");
print("</a>");
print("</h4>");
print("</div>");
print("<div id=\"collapseFour\" class=\"panel-collapse collapse\">");
print("<div class=\"panel-body\">");
print("Quelle collection souhaitez-vous choisir ?");
#print("	<form role=\"form\" action=\"collection.pl\" method=\"get\">"); # afficher le fichier collection.pl dans une modal
print("<form role=\"form\" action=\"collection.pl\" method=\"get\" onSubmit=\"return sendToCollection(this, '#myModal');\">");
print("<div class=\"radio\">");
print("<label>");
print("<input type=\"radio\" name=\"Coll\" id=\"optionsRadios1\" value=\"wiki\" checked>");
print("Wikinews");
print("</label>");
print("</div>");
print("<div class=\"radio\">");
print("<label>");
print("<input type=\"radio\" name=\"Coll\" id=\"optionsRadios2\" value=\"JDG\">");
print("Journal du Geek");
print("</label>");
print("</div>");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Valider\">");

print("<input name=\"requete\" type=\"hidden\" value=\"".$formulaire{requete}."\" />");
print("</form>");
print("</div>");
print("</div>");
print("</div>");
print("<div class=\"panel panel-default\">");
print("<div class=\"panel-heading\">");
print("<h4 class=\"panel-title\">");
print("<a data-toggle=\"collapse\" data-parent=\"#accordionDEUX\" data-target=\"#collapseFive\">");
print("Changement de mod&egravele");
print("</a>");
print("</h4>");
print("</div>");
print("<div id=\"collapseFive\" class=\"panel-collapse collapse\">");
print("<div class=\"panel-body\">");
print("Quel mod&egravele souhaitez-vous choisir ?");
#print("	<form role=\"form\" action=\"modele.pl\" method=\"get\">");
print("<form role=\"form\" action=\"modele.pl\" method=\"get\" onSubmit=\"return sendToCollection(this, '#myModalColl');\">");
print("<div class=\"radio\">");
print("<label>");
print("<input type=\"radio\" name=\"Mod\" id=\"optionsRadios1\" value=\"InnerProduct\" checked>");
print("Mod&egravele 1 : InnerProduct");
print("</label>");
print("</div>");
print("<div class=\"radio\">");
print("<label>");
print("<input type=\"radio\" name=\"Mod\" id=\"optionsRadios2\" value=\"Cosinus\">");
print("Mod&egravele 2 : Cosinus");
print("</label>");
print("</div>");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Valider\">");
print("<input name=\"requete\" type=\"hidden\" value=\"".$formulaire{requete}."\" />");
print("</form>");
print("</div>");
print("</div>");
print("</div>");
print("</div>");

print("</div>");


# MODAL 1 Changement de collection
print("<!-- Modal -->");
print("<div class=\"modal fade\" id=\"myModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">");
print("<div class=\"modal-dialog\">");
print("<div class=\"modal-content\">");
print("<div class=\"modal-header\">");
print("<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>");
print("<h4 class=\"modal-title\" id=\"myModalLabel\">Changement de collection</h4>");
print("</div>");
print("<div class=\"modal-body\">");
print("ICI METTRE LE CONTENU DE LA PAGE collection.pl");
print("</div>");
print("<div class=\"modal-footer\">");
print("<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>");
print("</div>");
print("</div>");
print("</div>");
print("</div>");

# MODAL 1 Changement de modèle
print("<!-- Modal -->");
print("<div class=\"modal fade\" id=\"myModalColl\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">");
print("<div class=\"modal-dialog\">");
print("<div class=\"modal-content\">");
print("<div class=\"modal-header\">");
print("<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>");
print("<h4 class=\"modal-title\" id=\"myModalLabel\">Changement de mod&egravele</h4>");
print("</div>");
print("<div class=\"modal-body\">");
print("ICI METTRE LE CONTENU DE LA PAGE collection.pl");
print("</div>");
print("<div class=\"modal-footer\">");
print("<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>");
print("</div>");
print("</div>");
print("</div>");
print("</div>");


print("</body>\n "); 
print("</html>\n ");

