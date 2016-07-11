function cacher() {
	document.getElementById('requete').style.visibility="hidden";
	document.getElementById('wordcloud').style.visibility="hidden";
	document.getElementById('graph_mots').style.visibility="hidden";
	document.getElementById('graph_cat').style.visibility="hidden";

	document.getElementById('requete').style.display="none";
	document.getElementById('wordcloud').style.display="none";
	document.getElementById('graph_mots').style.display="none";
	document.getElementById('graph_cat').style.display="none";

	document.getElementById('btn_requete').style.background="";
	document.getElementById('btn_wordcloud').style.background="";
	document.getElementById('btn_graph_mots').style.background="";
	document.getElementById('btn_graph_cat').style.background="";

	return true;
}

function cacher2() {
	document.getElementById('wordcloud').style.visibility="hidden";
	document.getElementById('graph_mots').style.visibility="hidden";

	document.getElementById('wordcloud').style.display="none";
	document.getElementById('graph_mots').style.display="none";

	document.getElementById('btn_wordcloud').style.background="";
	document.getElementById('btn_graph_mots').style.background="";

	return true;
}

function afficher(id){
	if (id == "btn_all") {
		document.getElementById('btn_requete').style.background="";
		document.getElementById('btn_wordcloud').style.background="";
		document.getElementById('btn_graph_mots').style.background="";
		document.getElementById('btn_graph_cat').style.background="";
		document.getElementById('btn_all').style.background="#ffffff";

		document.getElementById('requete').style.visibility="visible";
		document.getElementById('wordcloud').style.visibility="visible";
		document.getElementById('graph_mots').style.visibility="visible";
		document.getElementById('graph_cat').style.visibility="visible";

		document.getElementById('requete').style.display="block";
		document.getElementById('wordcloud').style.display="block";
		document.getElementById('graph_mots').style.display="block";
		document.getElementById('graph_cat').style.display="block";

		document.getElementById('titre_description').innerHTML='Affichage global';
	}
	else {
		document.getElementById(id).style.visibility="visible";
		document.getElementById(id).style.display="block";
		document.getElementById('btn_'+id).style.background="#ffffff";
		document.getElementById('btn_all').style.background="";
		
		if (id=='requete') {
			document.getElementById('titre_description').innerHTML='Documents retournés';
		} else if (id=='wordcloud') {
			document.getElementById('titre_description').innerHTML='Nuage de mots';
		} else if (id=='graph_mots') {
			document.getElementById('titre_description').innerHTML='Répartition des mots les plus utilisés parmi les premiers articles';
		} else if (id=='graph_cat') {
			document.getElementById('titre_description').innerHTML='Graphique des catégories (top 10)';
		} else {
			document.getElementById('titre_description').innerHTML='Affichage global';
		}
	}
	return true;
}

function afficher2(id){
	if (id == "btn_all") {
		document.getElementById('btn_wordcloud').style.background="";
		document.getElementById('btn_graph_mots').style.background="";
		document.getElementById('btn_all').style.background="#ffffff";

		document.getElementById('wordcloud').style.visibility="visible";
		document.getElementById('graph_mots').style.visibility="visible";

		document.getElementById('wordcloud').style.display="block";
		document.getElementById('graph_mots').style.display="block";

		document.getElementById('titre_description').innerHTML='Affichage global';
	}
	else {
		document.getElementById(id).style.visibility="visible";
		document.getElementById(id).style.display="block";
		document.getElementById('btn_'+id).style.background="#ffffff";
		document.getElementById('btn_all').style.background="";
		
		if (id=='wordcloud') {
			document.getElementById('titre_description').innerHTML='Nuage de mots';
		} else if (id=='graph_mots') {
			document.getElementById('titre_description').innerHTML='Mots les plus fréquents de l\'article';
		} else {
			document.getElementById('titre_description').innerHTML='Affichage global';
		}
	}
	return true;
}

