#! C:\Perl64\bin\perl.exe

use strict;
use CGI qw(:all);
require './perlTraitement/programmesRecherche.pl';

my $idDocument=param("idDocument");
my $collection=param("collection");
my $note=param("note");
my $idRequete=param("idRequete");
#Boucle
&noterArticle($idDocument,$collection,$idRequete);

print("content-type : text/html\n\n"); 
print ("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
print("<html xmlns=\"http://www.w3.org/1999/xhtml\">\n");
print("<head>");
print("<!-- Latest compiled and minified CSS -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
print("<!-- Optional theme -->");
print("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap-theme.min.css\">");
print ("<script language=\"JavaScript\" type=\"text/javascript\">
function loaded(){    window.setTimeout(window.close(), -1);	}
</script>");
print("</head>\n");
print("<body onload=\"loaded();\">");