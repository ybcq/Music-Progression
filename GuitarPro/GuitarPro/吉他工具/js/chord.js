if (window.addEventListener) {
	//FixPrototypeForGecko()
}
var Sys = {};
var ua = navigator.userAgent.toLowerCase();
var s; (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] : (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] : (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] : (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] : (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
function FixPrototypeForGecko() {
	HTMLElement.prototype.__defineGetter__("runtimeStyle", element_prototype_get_runtimeStyle);
	window.constructor.prototype.__defineGetter__("event", window_prototype_get_event);
	Event.prototype.__defineGetter__("srcElement", event_prototype_get_srcElement)
}
function element_prototype_get_runtimeStyle() {
	return this.style
}
function window_prototype_get_event() {
	return SearchEvent()
}
function event_prototype_get_srcElement() {
	return this.target
}
function SearchEvent() {
	if (document.all) {
		return window.event
	}
	func = SearchEvent.caller;
	while (func != null) {
		var A = func.arguments[0];
		if (A) {
			if (A.constructor == Event || A.constructor == MouseEvent) {
				return A
			}
		}
		func = func.caller
	}
	return null
}
function replaceChars(B, A, C) {
	temp = "" + B;
	while (temp.indexOf(A) > -1) {
		pos = temp.indexOf(A);
		temp = "" + (temp.substring(0, pos) + C + temp.substring((pos + A.length), temp.length))
	}
	return temp
}
function isChordLine(A) {
	return (A.toLowerCase().indexOf("<u") > -1)
}
function string(B, A) {
	newString = "";
	for (var C = 1; C <= A; C++) {
		newString += B
	}
	return newString
}
var bolChordsOnLyrics = false;
function variaAcorde(B, A) {
	totalAcordes = arrAcordes[B - 1].length;
	arrPosAcorde[B - 1] = (((arrPosAcorde[B - 1] + 1) >= totalAcordes) ? 0 : arrPosAcorde[B - 1] + 1);
	strAcorde = arrAcordes[B - 1][arrPosAcorde[B - 1]];
	desenhaAcorde(B, A, strAcorde)
}
function le(A) {
	rtxt = replaceChars(A, "S", "0");
	rtxt = replaceChars(rtxt, "A", "1");
	rtxt = replaceChars(rtxt, "D", "2");
	rtxt = replaceChars(rtxt, "F", "3");
	rtxt = replaceChars(rtxt, "G", "4");
	rtxt = replaceChars(rtxt, "H", "5");
	rtxt = replaceChars(rtxt, "J", "6");
	rtxt = replaceChars(rtxt, "K", "7");
	rtxt = replaceChars(rtxt, "L", "8");
	rtxt = replaceChars(rtxt, "O", "9");
	return rtxt
}
function reverseAcordes() {
	leftX = 0;
	direcao *= -1;
	for (a = 0; a < arrDesenhos.length; a++) {
		desenhaAcorde(a + 1, arrDesenhos[a], arrAcordes[a][arrPosAcorde[a]])
	}
}
var direcao = 1;
function desenhaAcorde(spanId, Titulo, strAcorde) {
	strAcorde = le(strAcorde);
	spanAcorde = eval("document.getElementById('acorde" + spanId + "')");
	spanNotas = eval("document.getElementById('notas" + spanId + "')");
	arrAcorde = strAcorde.split(" ");
	var min = 100;
	var max = toques = 0;
	tds = new Array();
	var bolTonica = true;
	for (n = 0; n < arrAcorde.length; n++) {
		arrAc = arrAcorde[n];
		if (arrAc != "X") {
			if (arrAc != "0" && parseInt(arrAc) < min) {
				min = parseInt(arrAc)
			}
			if (parseInt(arrAc) > max) {
				max = parseInt(arrAc)
			}
			if (arrAc.substring(0, 1) != "P" && arrAc != "0") {
				toques++
			}
			if (bolTonica) {
				tonica = n;
				bolTonica = false
			}
		}
	}
	var primeiroTraste = min;
	if (max <= 5) {
		min = 1
	}
	acorde = "<table border=0><tr><td width=15 valign=top align=right class=smalltext><div style='width:15px;'>&nbsp;</div><br />" + (min == 1 ? "": min + "") + "</td><td class='smalltext' width=70px><b><a class=db style='cursor:default;font-size:14px;text-align:center'>" + Titulo + '</a></b><!--img class=noprint onClick=ouvir("' + Titulo + '") src=images/ouvir.gif /--><br />';
	acorde += "<img src='images/braco.gif' />";
	if (spanId != 1000 && arrAcordes[spanId - 1].length > 1) {
		acorde += "<table border=0 width=65 cellpadding=0 cellspacing=0 height=35>";
		acorde += "<tr><td colspan=2 align=center><br /><a style='cursor:pointer;text-decoration:underline;' class='noprint smalltext' onClick=\"variaAcorde(" + spanId + ", '" + Titulo + "');\">转位</a></td></tr></table>"
	}
	acorde += "</td></tr><tr><td></td><td> </td</tr></table>";
	notas = "<br /><img height=3 /><br /><table cellpadding=0 cellspacing=0 width=66 height=80>";
	dedo = 1;
	for (traste = min; traste <= min + 4; traste++) {
		notas += "<tr height=16>";
		pestana = false;
		trasteVazio = true;
		for (corda = 0; corda <= 5; corda++) {
			tds[corda] = "<td width=11 valign=bottom height=16>";
			posPestana = (arrAcorde[corda] == "P" + traste);
			if (arrAcorde[corda] == traste || pestana || posPestana) {
				trasteVazio = false;
				if ((toques > 4 && traste == primeiroTraste) || pestana || posPestana) {
					if (!pestana) {
						dedo++
					}
					pestana = true;
					tds[corda] += "<img src='images/pestana.bmp' width=11 height=3 align=top />"
				} else {
					tds[corda] += "<img src=images/" + dedo + ".gif align=absmiddle />";
					dedo++
				}
			}
			tds[corda] += "</td>"
		}
		if (trasteVazio && dedo > 1 && dedo < 3 && toques < 4) {
			dedo++
		}
		if (direcao == -1) {
			for (n = 5; n >= 0; n--) {
				notas += tds[n]
			}
		} else {
			for (n = 0; n <= 5; n++) {
				notas += tds[n]
			}
		}
		notas += "</tr>"
	}
	notas += "<tr height=16>";
	if (direcao == -1) {
		for (n = arrAcorde.length - 1; n >= 0; n--) {
			notas += "<td height=20 width=11 class='smalltext' align=center>" + (arrAcorde[n] == "X" ? "<img src='images/x.gif' align=absmiddle />": (tonica == n ? "<img src='images/o_minusculo.gif' align=absmiddle />": "<img src='images/o_minusculo2.gif' align=absmiddle />")) + "</td>"
		}
	} else {
		for (n = 0; n < arrAcorde.length; n++) {
			notas += "<td height=20 width=11 class='smalltext' align=center>" + (arrAcorde[n] == "X" ? "<img src='images/x.gif' align=absmiddle />": (tonica == n ? "<img src='images/o_minusculo.gif' align=absmiddle />": "<img src='images/o_minusculo2.gif' align=absmiddle />")) + "</td>"
		}
	}
	notas += "</tr>";
	notas += "</table>";
	spanAcorde.innerHTML = acorde;
	if (spanId != 1000) {
		if (Sys.ie) {
			spanNotas.style.left = (leftX + 23) + "px";
			spanNotas.style.top = "9px";
			spanAcorde.style.left = (leftX + 5) + "px"
		}
		if (Sys.firefox) {
			spanNotas.style.left = (leftX + 20) + "px";
			spanNotas.style.top = "9px"
		}
		if (Sys.chrome) {
			spanNotas.style.left = (leftX + 20) + "px";
			spanNotas.style.top = "9px"
		}
	}
	spanNotas.innerHTML = notas
}
function ouvir(A) {
	for (n = 0; n < arrDesenhos.length; n++) {
		if (A == arrDesenhos[n]) {
			digitacao = le(arrAcordes[n][arrPosAcorde[n]]);
			break
		}
	}
	arrDig = digitacao.split(" ");
	digitacao = "";
	for (n = arrDig.length - 1; n >= 0; n--) {
		digitacao += arrDig[n] + " "
	}
	digitacao = replaceChars(digitacao, "X", "-1");
	digitacao = replaceChars(digitacao, " ", ":");
	parent.som.location = "http://www.ijita.com/"
}
function closeAcorde() {
	document.getElementById("acorde2000").innerHTML = "";
	document.getElementById("notas2000").innerHTML = ""
}
function acordeClassico(pAcorde) {
	for (n = 0; n < arrDesenhos.length; n++) {
		if (pAcorde == arrDesenhos[n] || pAcorde == arrDesenhos[n]) {
			break
		}
	}
	totalAcordes = arrAcordes[n].length;
	digitacao = arrAcordes[n][arrPosAcorde[n]];
	digitacao = le(digitacao.replace("P", ""));
	spanAcorde = eval("document.getElementById('acorde2000')");
	spanNotas = eval("document.getElementById('notas2000')");
	arrAcorde = digitacao.split(" ");
	var min = 100;
	var max = toques = 0;
	var bolTonica = true;
	for (n = 0; n < arrAcorde.length; n++) {
		arrAc = arrAcorde[n];
		if (arrAc != "X") {
			if (arrAc != "0" && parseInt(arrAc) < min) {
				min = parseInt(arrAc)
			}
			if (parseInt(arrAc) > max) {
				max = parseInt(arrAc)
			}
			if (arrAc.substring(0, 1) != "P" && arrAc != "0") {
				toques++
			}
			if (bolTonica) {
				tonica = n;
				bolTonica = false
			}
		}
	}
	var primeiroTraste = min;
	if (max >= 6) {
		primeiroTraste = min - 1
	} else {
		primeiroTraste = 0
	}
	acorde = '<table width=280 bgcolor=#F9F9F9 cellpadding=0 cellspacing=0 border=0><tr><td align=center><br /><img src="images/braco.png" /><br /><br /></td></tr></table>';
	spNotas = "<table cellpadding=0 cellspacing=0 border=0>";
	spNotas += "<tr height=18><td width=46></td><td width=46></td><td width=46></td><td width=46></td>";
	if (max >= 6) {
		spNotas += "<td width=46 valign=bottom><b>" + (primeiroTraste + 1) + "ª</b></td></tr>"
	} else {
		spNotas += "<td width=46></td></tr>"
	}
	for (corda = 0; corda <= 5; corda++) {
		spNotas += "<tr height=18>";
		for (traste = 5; traste >= 0; traste--) {
			spNotas += "<td width=46>";
			if (parseInt(arrAcorde[corda]) == 0 && traste == 0) {
				spNotas += "<img src=images/o_minusculo2.gif />"
			} else {
				if (parseInt(arrAcorde[corda] - primeiroTraste) == traste) {
					spNotas += "<img src=images/solta.gif />"
				} else {
					if (arrAcorde[corda] == "X" && traste == 0) {
						spNotas += "<img src=images/x.gif />"
					}
				}
			}
			spNotas += "</td>"
		}
		spNotas += "</tr>"
	}
	spNotas += "</table>";
	spanAcorde.innerHTML = acorde;
	spanNotas.innerHTML = spNotas;
	spanNotas.style.top = (event.clientY + ietruebody().scrollTop - 144) + "px";
	spanAcorde.style.top = (event.clientY + ietruebody().scrollTop - 138) + "px";
	spanNotas.style.left = (event.clientX + ietruebody().scrollLeft - 265) + "px";
	spanAcorde.style.left = (event.clientX + ietruebody().scrollLeft - 300) + "px";
	spanAcorde.style.filter = "progid:DXImageTransform.Microsoft.Shadow(direction=130,color=gray,strength=8);"
}
function MD(E, F) {
	var B = (ns6) ? 0 : 0;
	var D = (ns6) ? 0 : 0;
	var A = (ns6) ? 22 : 22;
	var C = (ns6) ? -11 : 0;
	curX = (ns6) ? E.pageX: event.clientX + ietruebody().scrollLeft;
	curY = (ns6) ? E.pageY: event.clientY + ietruebody().scrollTop;
	for (n = 0; n < arrDesenhos.length; n++) {
		if (F == arrDesenhos[n] || F == arrDesenhos[n]) {
			break
		}
	}
	totalAcordes = arrAcordes[n].length;
	strAcorde = arrAcordes[n][arrPosAcorde[n]];
	document.getElementById("acorde1000").style.filter = "progid:DXImageTransform.Microsoft.Shadow(direction=130,color=gray,strength=8);";
	document.getElementById("acorde1000").style.display = "block";
	document.getElementById("notas1000").style.display = "block";
	desenhaAcorde(1000, F, strAcorde);
	document.getElementById("notas1000").style.top = (curY + C - 47) + "px";
	document.getElementById("acorde1000").style.top = (curY + D - 50) + "px";
	document.getElementById("notas1000").style.left = (curX + A + 12) + "px";
	document.getElementById("acorde1000").style.left = (curX + B + 20) + "px";
	if (Sys.chrome) {
		document.getElementById("notas1000").style.top = (curY - 48) + "px"
	}
}
function AD(A) {
	document.getElementById("acorde1000").style.display = "none";
	document.getElementById("notas1000").style.display = "none"
}
var curX;
var curY;
var ns6 = document.getElementById && !document.all;
function ietruebody() {
	return (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement: document.body
}
notas_musicais = new Array();
notas_musicais[1] = new Array("C", "");
notas_musicais[2] = new Array("#C", "bD");
notas_musicais[3] = new Array("D", "");
notas_musicais[4] = new Array("bE", "#D");
notas_musicais[5] = new Array("E", "");
notas_musicais[6] = new Array("F", "");
notas_musicais[7] = new Array("#F", "bG");
notas_musicais[8] = new Array("G", "");
notas_musicais[9] = new Array("#G", "bA");
notas_musicais[10] = new Array("A", "");
notas_musicais[11] = new Array("bB", "#A");
notas_musicais[12] = new Array("B", "");
function retornaCifra() {
	arrayTags = document.getElementsByTagName("u");
	for (n = 0; n < arrayTags.length; n++) {
		if (ns6) {
			arrayTags[n].innerHTML = "" + retornaNovaNota2(arrayTags[n].innerHTML, tom, true) + ""
		} else {
			arrayTags[n].innerHTML = "<pre style='margin-left:0'>" + retornaNovaNota2(arrayTags[n].innerHTML, tom, true) + "</pre>"
		}
	}
}
function retornaCifra1() {
	tamanho1 = cifra.length;
	nova_cifra = "";
	for (n = 0; n < tamanho1; n++) {
		char1 = cifra.substr(n, 3);
		if (char1 == "<U>") {
			nota = "";
			n += 3;
			while (cifra.substr(n, 4) != "</U>" && n < tamanho1) {
				nota += cifra.substr(n, 1);
				n++
			}
			n += 4;
			nova_cifra += retornaNovaNota2(nota, tom, true)
		}
		nova_cifra += cifra.substr(n, 1)
	}
	document.getElementById("body").innerHTML = nova_cifra
}
function procuraNota(A) {
	for (n1 = 1; n1 <= 12; n1++) {
		if (notas_musicais[n1][0] == A || notas_musicais[n1][1] == A) {
			break
		}
	}
	return n1
}
function retornaNota(C, A) {
	id = procuraNota(C);
	if (id == 13) {
		return C
	}
	if (A < 0) {
		A += 12
	}
	if (A > 12) {
		A = A % 12
	}
	var B = id + A;
	if (B > 12) {
		B = B % 12
	}
	C = notas_musicais[B][0];
	return C
}
function retornaNovaNota2(B, A, C) {
	B += " ";
	nova_nota = "";
	nota_2 = "";
	tamanho = B.length;
	acorde = "";
	aberto = false;
	for (pos = 0; pos < tamanho; pos++) {
		nova_nota += B.substr(pos, 1);
		notaFutura = nova_nota + B.substr(pos + 1, 1);
		if ((B.substr(pos, 1) == " " || B.substr(pos, 1) == "\t") && aberto) {
			aberto = false;
			if (C) {
				nota_2 += "<u>" + acorde + "</u>"
			} else {
				nota_2 += acorde
			}
			acorde = "";
			txtAcorde = ""
		}
		if (B.substr(pos, 1) != " " && B.substr(pos, 1) != "\t" && !aberto) {
			aberto = true;
			acorde = "";
			txtAcorde = ""
		}
		if (procuraNota(notaFutura) == 13) {
			if (A == 0) {
				acorde += nova_nota
			} else {
				acorde += retornaNota(nova_nota, A)
			}
			nova_nota = ""
		}
		if (!aberto && pos < tamanho - 1) {
			nota_2 += B.substr(pos, 1)
		}
	}
	return nota_2
}
function toURL(B, C, D) {
	B = tom;
	var A = new Array();
	for (i = 0; i < D.length; i++) {
		A[i] = retornaNovaNota2(D[i], parseInt(C), false)
	}
	return "action=tom&tomFrom=" + B + "&tomTo=" + C + "&chordsA=" + D + "&chordsB=" + A
};