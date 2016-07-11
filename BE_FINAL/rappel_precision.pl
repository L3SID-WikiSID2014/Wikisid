#! C:\Perl64\bin\perl.exe

use DBI;
require './perlTraitement/programmesAdministration.pl';
require './perlTraitement/rappelprec.pl';  ;
print("content-type : text/html\n\n"); 

my %formulaire=();
foreach my $element (split(/&/, $ENV{'QUERY_STRING'})){
	my ($variable, $valeur)=split(/=/, $element);
	#print ("<p>$valeur</p>");
	$valeur =~ s/\+/ /g;
	$valeur =~ s/%(..)/pack('c',hex($1))/eg;
	$formulaire{$variable} = $valeur;

	#print ("<p>$formulaire{$variable}<p>");
}

#Récupérer les documents triés par rang
my($texte)=&ExtraireLigne("R1","./data/wiki/requetes/resultats.txt");
chomp($texte);
my(@resultats)=&Segmenter($texte);

my @pert;
my $i=0;
my $t;
 foreach $e (@resultats){
 	    # print "<p>***$e</p>";
		$t=&ExtraireLigne("R1\t".$e,"./data/wiki/requetes/pertinence.txt");
		$t=~m@R1+\t$e\s(.*)@i;
		$pertinence[$i]=$1;
	    $i++;
}

# foreach $e (@pertinence){
 	    # print "<p>***$e</p>";
# }

my(@s);
my($total)=-1;
my $nbpert=0;
foreach $e (@pertinence){
	$total++;
	if ($e==1){
		$nbpert++;
		$s[$total]=$nbpert;
		# print "<p>***@s</p>";
	} else {
		$s[$total]="-";
		# print "<p>***@s</p>";
	}
	
}
# print "<p>***@s</p>";
# print "<p>total ***$total</p>";
# print "<p>nbpert***$nbpert</p>";

my(@r);
foreach $e (@s){
	if ($e!="-"){
		my $q = $e/$nbpert;
		@r=(@r,$q);
		# print "<p>***@r</p>";
	} else {
		@r=(@r,"-");
		# print "<p>***@r</p>";
	}
}

my(@p);
my $i=0;
foreach $e (@s){
	if ($e!="-"){
		my $q = $e/($i);
		$p[$i]=$q;
		# print "<p>***@r</p>";
	} else {
		$p[$i]="-";
		# print "<p>***@r</p>";
	}
		$i++;
}

my $x;
my $y;
my $j;
for ($j=1;$j<=$total;$j++){
	if ($pertinence[$j]==1 && $j!=$total){
		$x=$x.$r[$j].",";
		$y=$y.$p[$j].",";
	} elsif ($pertinence[$j]==1 && $j==$total){
		$x=$x.$r[$j];
		$y=$y.$p[$j];
	}
}
# print "<p>***$coord</p>";
# print "<p>***@s</p>";
# print "<p>***@r</p>";
# print "<p>***@p</p>";


print("<html>"); 
print("<head>");
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
print("<script type=\"text/javascript\" src=\"javascript/Chart.js\" ></script>"); 



print("<body id=\"stat_logo\">");
print("<div id=\"centre\">"); 
print("<div class=\"page-header\">");
print("<h1>Courbe Rappel-Precision</h1>\n"); 
print("</div>");
print("<canvas id=\"income\" width=\"600\" height=\"400\"></canvas>");


print("<script> var data = {
	labels : [$x],
	datasets : [
		{
			fillColor : \"#4682B4\",
			strokeColor : \"#4169E1\",
			pointColor : \"#4169E1\",
			pointStrokeColor : \"#fff\",
			data : [$y]
		}
	]
}
var income = document.getElementById(\"income\").getContext(\"2d\"); 
new Chart(income).Line(data); </script>");

print("<form action=\"admin.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("<input type=\"submit\" class=\"btn btn-primary\" value=\"Retour\">");
print("</form>");         
print("</body>\n "); 
print("</html>\n "); 

