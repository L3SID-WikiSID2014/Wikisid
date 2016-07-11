#! C:\Perl64\bin\perl.exe


use DBI;
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

my @docs=&RetourDoc($formulaire{requete});
my @termes=&RetourTermes($formulaire{requete});

# foreach my $e (@docs){
	# print("<p> $e</p>");
# }

my(@requete)=&Preparer($termes[0]);

my $requete=206;


my(%nbdoc)=();
my $i;


foreach my $element(@requete){
	# print("<p> $element</p>");
	 foreach my $document(@docs){
		 # print("<p> $element $document</p>");
		$i=&SommeOc($element,$document,"./data/wiki/index/posting.txt");
		# print("<p>$element $document $i</p>");
		if($nbdoc{$element}){
				$nbdoc{$element}=$nbdoc{$element}+$i;
		}else{
				$nbdoc{$element}=$i+1;
		 }
		 }
}
my $nbr = keys (%nbdoc);

my $labels;
my $barres;
foreach my $element (sort(keys(%nbdoc))){
		$nbr=$nbr-1;
		if ($nbr!=0){	
			$labels=$labels."\"".$element."\",";
			$barres=$barres.$nbdoc{$element}.",";
		}else{
			$labels=$labels."\"".$element."\"";
			$barres=$barres.$nbdoc{$element};
		}
}
# print("<p>$labels</p>");
 
 my $max=&Maximum($barres);
# print("<p> $max</p>");

# print("<p> $barres</p>");
# print("<p> $labels</p>");
print("<html>"); 
print("<head>");
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
print("<h1>Nombre d'occurences des termes de la requ&ecircte <small>dans tous les documents retourn&eacutes de la collection</small></h1>");
print("</div>");

print("<canvas id=\"income\" width=\"600\" height=\"400\"></canvas>");


print("<script> var barData = { 
labels : [$labels],	 
datasets : [ { fillColor : \"#48A497\", strokeColor : \"#48A4D1\", data : [$barres]	 } ] } 
var income = document.getElementById(\"income\").getContext(\"2d\"); 
var baroptions = {
		scaleOverride : true,
		scaleSteps : $max+1,
		scaleStepWidth : 1,
		scaleStartValue : 1
		}
new Chart(income).Bar(barData,baroptions); </script>"); 

print("<form action=\"admin.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" value=\"Retour\">");
print("</form>");       
print("</body>\n "); 
print("</html>\n "); 

