// Tableau de memorisation des notes pour chaque liste
var ArrListeEtoile = new Object();

//-------------------------------------------------------
// Gestion de la visibilite des etoiles au survol
//-------------------------------------------------------
function GestionHover(idListe, indice, nbEtoile) {
	for (i=1; i<= nbEtoile; i++) //Pour toutes les étoiles de la liste
	{
		var idoff = "staroff-" + idListe + "-" + i;
		var idon = "staron-" + idListe + "-" + i;

		if(indice == -1)
		{
			// Sortie du survol de la liste des etoiles
			if (ArrListeEtoile[idListe] >= i){
				//Pour afficher une étoile jaune
				document.getElementById(idoff).style.display ="none";
				document.getElementById(idon).style.display ="block";
			}
			else {
				//Pour afficher une étoile blanche
				document.getElementById(idoff).style.display ="block";
				document.getElementById(idon).style.display ="none";
			}
		}
		else
		{
			// Survol de la liste des etoiles
			if(i <= indice) {
				//Pour afficher une étoile jaune
				document.getElementById(idoff).style.display ="none";
				document.getElementById(idon).style.display ="block";
			}
			else {
				//Pour afficher une étoile blanche
				document.getElementById(idoff).style.display ="block";
				document.getElementById(idon).style.display ="none";
			}
		}
	}
}


//-------------------------------------------------------
// Selection d une note pour une liste
//-------------------------------------------------------
function ChoixSelection(idListe, indice, nbEtoile,collection,idRequete) {
	//Pour dire au tableau qui mémorise tout que pour la liste "idListe", la note est de "indice"/"nbEtoile"
		ArrListeEtoile[idListe] = indice;
	//On récupére le label que l'on veut changer
		var score = "score-" + idListe;
	//Changement du label (l'affichage de la note en texte)
		//document.getElementById(score).innerHTML = " " + indice + "/" + nbEtoile;
		document.getElementById(score).innerHTML = "Vote enregistr\351 - ";
		open('noter.pl?&idDocument=' + idListe +'&note='+indice+'&collection='+collection+'&idRequete='+idRequete,'Enregistrement du vote','menubar=no, status=no, location=no, scrollbars=no, menubar=no, width=500, height=250, top= 200');
}


//-------------------------------------------------------
// Creation d une liste de notation unique
//-------------------------------------------------------
function CreateListeEtoile(idListe, nbEtoile, collection, idRequete) {
	//idListe pour identifier la liste
	//nbEtoile pour le nombre d'étoile voulue

	//Mémorisation de la liste (avec son nombre d'étoile)
		ArrListeEtoile[idListe] = 0;


	var renduListe = ""; //Initialisation
	renduListe += "<div id=\"listeEtoile\" class=\"listeEtoile\" onmouseout=\"GestionHover('" + idListe + "', -1, '" + nbEtoile + "')\">";
	renduListe += "<ul>"; //On dit qu'on va faire une liste

	for(i=1; i<=nbEtoile; i++) { //On cré les étoiles une par une jusqu'au nombre choisit
		renduListe += "<li>"; //Un point de la liste
		renduListe += "<a href=\"javascript:ChoixSelection('" + idListe + "','" + i + "','" + nbEtoile + "','" + collection + "','" + idRequete + "')\" onmouseover=\"GestionHover('" + idListe + "','" + i + "','" + nbEtoile + "') \">";
		renduListe += "<img id=\"staroff-" + idListe + "-" + i + "\" src=\"./bootstrap/img/staroff.gif\" border=\"0\" title=\"" + i + "\" style=\"border-width: 0px; display: block;\">";
		renduListe += "<img id=\"staron-" + idListe + "-" + i + "\" src=\"./bootstrap/img/staron.gif\" border=\"0\" title=\"" + i + "\" style=\"border-width: 0px; display: none;\">";
		renduListe += "</a>";
		renduListe += "</li>";//Fin du point
	}

	renduListe += "	</ul>"; //Fin de la liste
	renduListe += "</div>"; //Fin de la div
	renduListe += "<label id='score-" + idListe + "'></label>"; //Pour afficher la note en texte (ex : 3/5)
	
	//On met le code contenu dans "renduListe" dans la div qui s'appelle idListe (le nom est à l'intérieur de la variable idListe)
		document.getElementById(idListe).outerHTML = renduListe;
		
}

function open_infos(){
	window.open('aideRecherche.html','Wiki SID - Recherche','menubar=no, status=no, location=no, scrollbars=no, menubar=no, width=1200, height=550, left=100, top= 100');
}