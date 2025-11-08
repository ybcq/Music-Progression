var notaEscolhida = "C"

notas_musicais = new Array ();
notas_musicais[01] = new Array('C', '')
notas_musicais[02] = new Array('C#', 'Db')
notas_musicais[03] = new Array('D', '')
notas_musicais[04] = new Array('Eb', 'D#')
notas_musicais[05] = new Array('E', '')
notas_musicais[06] = new Array('F', '')
notas_musicais[07] = new Array('F#', 'Gb')
notas_musicais[08] = new Array('G', '')
notas_musicais[09] = new Array('G#', 'Ab')
notas_musicais[10] = new Array('A', '')
notas_musicais[11] = new Array('Bb', 'A#')
notas_musicais[12] = new Array('B', '')
                 
notas = new Array ('C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B')
//                  0    1     2    3     4    5    6     7    8     9    10   11
//tonic 2 3 b5 #5 6 7 
//0 2 4 6 8 9 11
escala    = new Array ();
escala[0] = new Array (0, 2, 4, 5, 7, 9, 11) // IONIAN
escala[1] = new Array (0, 3, 5, 6, 10)       // BLUES
escala[2] = new Array (0, 2, 3, 5, 7, 9, 11) // MENOR
escala[3] = new Array (0, 2, 4, 7, 9)        // PENTATONICA
escala[4] = new Array (0, 3, 5, 7, 10)       // PENTATONICA MENOR
escala[5] = new Array (0, 3, 4, 7, 8, 11)    // AUMENTADA
escala[6] = new Array (0, 2, 4, 6, 8, 10)    // WHOLE TONE
escala[7] = new Array (0, 2, 3, 6, 7, 9, 11)    // LIDIANA
escala[8] = new Array (0, 2, 4, 5, 7, 9, 10)     // MixoLIDIANA
escala[9] = new Array (0, 2, 3, 5, 7, 8, 10)     // AEOLIAN
escala[10] = new Array (0, 1, 3, 5, 6, 8, 10)    // LOCRIANA
escala[11] = new Array (0, 1, 3, 4, 6, 7, 9, 10) // Diminished (H-W)
escala[12] = new Array (0, 2, 3, 5, 6, 8, 9, 11) // Diminished (W-H)
escala[13] = new Array (0, 1, 3, 5, 7, 9, 10)    // Dorian b2    
escala[14] = new Array (0, 2, 4, 6, 8, 9, 11)    // Lydian Aug
escala[15] = new Array (0, 2, 4, 6, 8, 9, 11)    // Lydian b7 
escala[16] = new Array (0, 2, 4, 5, 7, 8, 10)    // Mixolydian b6
escala[17] = new Array (0, 2, 3, 5, 6, 8, 10)    // Locrian 2   
escala[18] = new Array (0, 1, 3, 4, 6, 8, 10)    // Altered    
escala[19] = new Array (0, 2, 3, 5, 7, 8, 11)    // Harmonic Minor
escala[20] = new Array (0, 1, 3, 5, 6, 9, 10)    // Locrian 6 
escala[21] = new Array (0, 2, 4, 5, 8, 9, 11)    // Ionian Aug 
escala[22] = new Array (0, 2, 3, 6, 7, 9, 10)    // Dorian #4    
escala[23] = new Array (0, 1, 4, 5, 7, 8, 10)    // Phrygian Major   
escala[24] = new Array (0, 3, 4, 6, 7, 9, 11)    // Lydian #9 
escala[25] = new Array (0, 1, 3, 4, 6, 8, 9)     // Altered bb7  
escala[26] = new Array (0, 2, 4, 7, 9)           // Pentatonic Major   
escala[27] = new Array (0, 4, 7, 8, 11)          // Augmented Tônica     
escala[28] = new Array (0, 2, 4, 5, 6, 8, 10)    // Arabian  
escala[29] = new Array (0, 1, 3, 7, 8)           // Balinese
escala[30] = new Array (0, 1, 4, 5, 7, 8, 11)    // Byzantina
escala[31] = new Array (0, 4, 6, 7, 11)          // Chinese
escala[32] = new Array (0, 2, 4, 7, 9)           // Chinese Mongolian
escala[33] = new Array (0, 1, 4, 5, 7, 8, 11)    // Double Harmonic
escala[34] = new Array (0, 2, 5, 7, 10)          // Egyptian 
escala[35] = new Array (0, 1, 3, 4, 5, 6, 8, 10) // Eight Tone Spanish 
escala[36] = new Array (0, 1, 4, 6, 8, 10, 11)   // Enigmatic 
escala[37] = new Array (0, 2, 4, 5, 7, 8, 10)    // Hindu 
escala[38] = new Array (0, 2, 3, 7, 8)           // Hirajoshi 
escala[39] = new Array (0, 3, 4, 6, 7, 9, 10)    // Hungarian Major 
escala[40] = new Array (0, 2, 3, 6, 7, 8, 11)    // Hungarian Minor 
escala[41] = new Array (0, 2, 3, 6, 7, 8, 11)    // Hungarian Gypsy
escala[42] = new Array (0, 2, 4, 5, 6, 7, 9, 11) // Ichikosucho 
escala[43] = new Array (0, 2, 3, 7, 9)           // Kumoi 
escala[44] = new Array (0, 2, 4, 6, 8, 10, 11)   // Leading Whole Tone 
escala[45] = new Array (0, 2, 3, 6, 7, 9, 11)    // Lydian Diminished
escala[46] = new Array (0, 2, 4, 6, 7, 8, 10)    // Lydian Minor
escala[47] = new Array (0, 2, 3, 5, 7, 8, 11)    // Mohammedan
escala[48] = new Array (0, 1, 3, 5, 7, 8, 11)    // Neopolitan
escala[49] = new Array (0, 1, 3, 5, 7, 9, 11)    // Neopolitan Major
escala[50] = new Array (0, 1, 3, 5, 7, 8, 10)    // Neopolitan Minor
escala[51] = new Array (0, 2, 4, 6, 7, 9, 10)    // Overtone
escala[52] = new Array (0, 1, 3, 7, 8)           // Pelog
escala[53] = new Array (0, 1, 4, 5, 6, 8, 11)    // Persian
escala[54] = new Array (0, 2, 4, 6, 9, 10)    	 // Prometheus
escala[55] = new Array (0, 1, 4, 6, 9, 10)    	 // Prometheus Neopolitan
escala[56] = new Array (0, 1, 4, 6, 7, 8, 11)  	 // Purvi Theta 
escala[57] = new Array (0, 1, 4, 5, 8, 9)  	 // Six Tone Symmetrical 
escala[58] = new Array (0, 1, 3, 6, 7, 8, 11)  	 // Todi Theta 

cordas = new Array (4, 9, 2, 7, 11, 4)
totalTrastes = 19
function fechaBraco(){
	for (corda = 0; corda < 6; corda ++){
		for (traste = 0; traste <totalTrastes + 2; traste ++){
			sp = eval('nt' + corda + '_' + traste)
			//sp.innerHTML = ''
                        jQuery('#nt' + corda + '_' + traste+' div').addClass('hidden');
                        jQuery('#nt' + corda + '_' + traste+' div').removeClass('dot');
                        jQuery('#nt' + corda + '_' + traste+' div').removeClass('tonic');
                        jQuery('#nt' + corda + '_' + traste+' div').removeClass('tonicdot');
                        jQuery('#nt' + corda + '_' + traste+' div').removeClass('firstfret');
                    }
	}
}


function procuraNota(strNota3) {
	for (n1=1; n1<=12; n1++) {if (notas_musicais[n1][0] == strNota3 || notas_musicais[n1][1] == strNota3) break	}
	return n1;
}

function montaEscala(intEscala)
{	        
	bolDots = !document.form1.dots.checked
	fechaBraco()
	tonica = ''
	arrDigitacao = escala[intEscala]
	var notaInicial = procuraNota(document.form1.tom.value) - 1 
        //设置cookie
        if(!document.form1.dots.checked)
        {
            jQuery.cookie('yinjie_yinfu',0,{ expires: 90, path: '/' });
        }else{
            jQuery.cookie('yinjie_yinfu',1,{ expires: 90, path: '/' });
        }
        jQuery.cookie('yinjie_diao',intEscala,{ expires: 90, path: '/' });
        jQuery.cookie('yinjie_zhuyin',document.form1.tom.value,{ expires: 90, path: '/' });
        
	// montando o array com as notas -----------------
	arrDigitacao2 = new Array();
	for (digito = 0; digito < arrDigitacao.length; digito ++)
	{
		arrDigitacao2[digito] = notas[((notaInicial + arrDigitacao[digito]) % 12 )]
		if (tonica == '') tonica = arrDigitacao2[digito]
	}
	for (corda = 0; corda < 6; corda ++)
	{
		tomAtual = 0
		for (traste = 0; traste <totalTrastes + 2; traste ++)
		{
				notaAtual = notas[cordas[corda] + tomAtual]
				for (n=0; n<arrDigitacao2.length; n++)
				{
					if (notaAtual == arrDigitacao2[n])
					{
						sp = eval('nt' + corda + '_' + traste)
						if (tonica == notaAtual)
						{
							if (bolDots)
                                                            {
                                                                jQuery('#nt' + corda + '_' + traste+' div').removeClass('hidden');
                                                                jQuery('#nt' + corda + '_' + traste+' div').addClass('tonicdot');
                                                            }
							
							else{
                                                            jQuery('#nt' + corda + '_' + traste+' div').removeClass('hidden');
                                                            jQuery('#nt' + corda + '_' + traste+' div').addClass('tonic');
                                                        }						
						}
						else
						{
                                                    
							if (bolDots)
                                                            {
                                                                jQuery('#nt' + corda + '_' + traste+' div').removeClass('hidden');
                                                                jQuery('#nt' + corda + '_' + traste+' div').addClass('dot');
                                                                //sp.innerHTML = '<div class="finger"></div>'
                                                            }
							else{
                                                            jQuery('#nt' + corda + '_' + traste+' div').removeClass('hidden');
                                                            //sp.innerHTML = '<div class="finger">' + notaAtual + '</div>'
                                                        }
							
						}
						break
					}
				}
				tomAtual ++
				if (cordas[corda] + tomAtual == 12) tomAtual = -cordas[corda]
		}
	}

        jQuery('.fret_0 .finger').removeClass('dot');
        //jQuery('.fret_0 .finger').removeClass('tonicdot');
        jQuery('.fret_0 .hidden').addClass('firstfret').removeClass('hidden');
        jQuery('.fret_0 .tonicdot').css('color','white');
}

function shownote()
{
    var notaEscolhida=document.form1.tom.value;
    montaEscala(document.form1.comboEscala.value);
}