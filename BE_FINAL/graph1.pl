#! C:\Perl64\bin\perl.exe
use DBI;
require './perlTraitement/programmesAdministration.pl';
print("content-type : text/html\n\n"); 

my %formulaire=();
foreach my $element (split(/&/, $ENV{'QUERY_STRING'})){
	my ($variable, $valeur)=split(/=/, $element);
	#print ("<p>$valeur</p>");
	$valeur =~ s/\+/ /g;
	$valeur =~ s/%(..)/pack('c',hex($1))/eg;
	$formulaire{$variable} = $valeur;

	# print ("<p>#$formulaire{$variable}<p>");
}

 
my @termes=&RetourTermes($formulaire{requete});


my(@requete)=&Preparer($termes[0]);
 
my(%nbdoc)=();
my(%nbdoc2)=();
my $i;
my $i2;

# print("<p> @requete </p>");
foreach my $element(@requete){
		 # print ("<p>$element</p>");
		$i=&Nt($element,"./data/wiki/index/posting.txt");
		$i2=&Nt($element,"./data/JDG/index/posting.txt");
		# print ("<p>****$i</p>");
		  # print ("<p>$i2</p>");
		$nbdoc{$element}=$i+1;
		$nbdoc2{$element}=$i2+1;
}
my $nbr = keys (%nbdoc);

my $labels;
my $barres;
my $barres2;
foreach my $element (sort(keys(%nbdoc))){
		$nbr=$nbr-1;
		if ($nbr!=0){	
			$labels=$labels."\"".$element."\",";
			$barres=$barres.$nbdoc{$element}.",";
			$barres2=$barres2.$nbdoc2{$element}.",";
		}else{
			$labels=$labels."\"".$element."\"";
			$barres=$barres.$nbdoc{$element};
			$barres2=$barres2.$nbdoc2{$element};
		}
}
#print("<p>$labels</p>");


my $max=&Maximum($barres.",".$barres2);
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
print("<h1>Apparition des termes de la requ&ecircte <small>dans tous les documents de la collection</small></h1>");
print("</div>");
print("<canvas id=\"income\" width=\"600\" height=\"400\"></canvas>");

print("<script> var barData = { 
labels : [$labels],	 
datasets : [ { fillColor : \"#48A497\", 
		strokeColor : \"#48A4D1\", 
		data : [$barres]},
        {fillColor : \"#FF2345\",
        strokeColor : \"#FF2345\",
        data : [$barres2]
        }
		] }  
var baroptions = {
		scaleOverride : true,
		scaleSteps : $max+1,
		scaleStepWidth : 1,
		scaleStartValue : 1,

		} 
var income = document.getElementById(\"income\").getContext(\"2d\");	
new Chart(income).Bar(barData,baroptions); </script>");      
print("<p><font color=\"#48A497\"> BLEU : Wikinews</font></p>");
print("<p><font color=\"#FF2345\"> ROUGE : Journal du Week</font></p>");print("<form action=\"admin.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Retour\">");
print("</form>");
print("</body>\n "); 
print("</html>\n "); 


