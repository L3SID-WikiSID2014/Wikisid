#! C:\Perl64\bin\perl.exe


use strict; 
use DBI;
require './perlTraitement/programmesAdministration.pl';

print("content-type : text/html\n\n"); 
print("<html>"); 
print("<head>\n");
print("<!-- Latest compiled and minified CSS -->");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print("<link rel=\"stylesheet\" type=\"text/css\" href=\"bootstrap/css/stat.css\" />");
print("<script src=\"bootstrap/js/jquery.min.js\"></script>");
print("<script src=\"bootstrap/js/bootstrap.min.js\"></script>");
print("<meta name=\"description\" content=\"Wiki GEEK SID - Administration\" />\n");
print("<meta name=\"keywords\" content=\"Wiki GEEK SID Administration\" />\n");
print("<title>Wiki GEEK SID - Administration</title>\n");
print("</head>\n");
print("<body>");



my %formulaire=();
foreach my $element (split(/&/, $ENV{'QUERY_STRING'})){
	my ($variable, $valeur)=split(/=/, $element);
	# print ("<p>$valeur</p>");
	$valeur =~ s/\+/ /g;
	$valeur =~ s/%(..)/pack('c',hex($1))/eg;
	$formulaire{$variable} = $valeur;

	# print ("<p>$formulaire{$variable}<p>");
}


# print "<p>***$formulaire{requete}</p>";
# print "<p>$formulaire{Mod}</p>";
my $modif=&ModifMod($formulaire{Mod});

if ($modif) {
	print "<p>La modification du mod&egravele a &eacutet&eacute effectu&eacutee avec succ&egraves</p>";
}
else {
	print "<p>Le mod&egravele s&eacutelectionn&eacute est d&eacuteja le mod&egravele utilis&eacute.</p>";
}

print("<form action=\"admin.pl?requete=".$formulaire{requete}."\" method=\"post\">");
print("</form>");


print("</body>\n "); 
print("</html>\n ");