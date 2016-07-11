#! C:\Perl64\bin\perl.exe


require './perlTraitement/programmesAdministration.pl';

# HTTP HEADER
print "Content-type: text/html \n\n";

my %formulaire=();
foreach my $element (split(/&/, $ENV{'QUERY_STRING'})){
	my ($variable, $valeur)=split(/=/, $element);
	#print ("<p>$valeur</p>");
	$valeur =~ s/\+/ /g;
	$valeur =~ s/%(..)/pack('c',hex($1))/eg;
	$formulaire{$variable} = $valeur;

	# print ("<p>$formulaire{$variable}<p>");
}

my %score=&RetourRang($formulaire{requete});


# foreach my $e (@docs){
	# print("<p> $e</p>");
# }


my $nbr = keys (%score);

my $labels;
my $barres;
foreach my $element (sort(keys(%score))){
		$nbr=$nbr-1;
		if ($nbr!=0){	
			$labels=$labels."\"rang ".$element."\",";
			$barres=$barres.$score{$element}.",";
		}else{
			$labels=$labels."\"rang ".$element."\"";
			$barres=$barres.$score{$element};
		}
}

# print("<p> $barres</p>");
# print("<p> $labels</p>");

print("<html>"); 
print("<head>\n");
print("<meta name=\"description\" content=\"Wiki GEEK SID - Statistiques\" />\n");
print("<meta name=\"keywords\" content=\"Wiki GEEK SID Statistiques\" />\n");
print("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print("<link rel=\"stylesheet\" type=\"text/css\" href=\"bootstrap/css/stat.css\" />");
print("<script src=\"bootstrap/js/jquery.min.js\"></script>");
print("<script src=\"bootstrap/js/bootstrap.min.js\"></script>");
print("<script type=\"text/javascript\" src=\"javascript/Chart.js\" ></script>"); 
print("<title>Wiki GEEK SID - Statistiques</title>\n");
print("</head>\n");
print("<body id=\"stat_logo\">");
print("<div id=\"centre\">"); 
print("<div class=\"page-header\">");
print("<h1>Apparition des termes de la requ&ecircte <small>dans tous les documents retourn&eacutes</small></h1>");
print("</div>");
 
print("<canvas id=\"income\" width=\"600\" height=\"400\"></canvas>");


print("<script> var barData = { 
labels : [$labels],	 
datasets : [ { fillColor : \"#48A497\", strokeColor : \"#48A4D1\", data : [$barres]	 } ] } 
var income = document.getElementById(\"income\").getContext(\"2d\"); 
var baroptions = {
		scaleOverride : true,
		scaleSteps : 10,
		scaleStepWidth : 10,
		scaleStartValue : 0
		}
new Chart(income).Bar(barData,baroptions); </script>");   
print("<form action=\"admin.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Retour\">");
print("</form>");         
print("</body>\n "); 
print("</html>\n "); 

