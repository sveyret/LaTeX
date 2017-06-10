#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import getopt

try:
	from scribus import *
    
except ImportError:
	print 'Ce script doit être exécuté depuis Scribus.'
	sys.exit(1)

syntaxe = "scribus -g -ns <inputfile.sla> -py " + sys.argv[0] + " <sortie.pdf> <fichier.data> <autres.fichiers>"
pdf_sortie = ''
fichier_data = ''

for opt in sys.argv[1:]:
	if opt.endswith(".pdf"):
		pdf_sortie = opt
	elif opt.endswith(".data"):
		fichier_data = opt
	else:
		print("Paramètre non reconnu ignoré: {}".format(opt))

if (pdf_sortie == "" or fichier_data == ""):
	print("Les fichiers .pdf de sortie et .data de données doivent être spécifiés")
	print(syntaxe)
	sys.exit()

data = open(fichier_data)
titre = data.readline()
auteur = data.readline()
contributeur = data.readline()
editeur = data.readline()
isbn = data.readline()
resume = data.readline()
data.close()

resume = resume.replace(" \\par ", "\n")

def changeText(obj, text):
	deselectAll()
	selectObject(obj)
	selectText(0, getTextLength());
	deleteText();
	insertText(text, -1);

if haveDoc():
	changeText("Auteur", auteur);
	changeText("AuteurDos", auteur)
	changeText("AuteurTranche", auteur)
	changeText("Titre", titre)
	changeText("TitreDos", titre)
	changeText("TitreTranche", titre)
	changeText("Contributeur", contributeur)
	changeText("Éditeur", editeur)
	changeText("ÉditeurDos", editeur)
	changeText("Résumé", resume)
	saveDoc()
	pdf = PDFfile()
	pdf.file = pdf_sortie
	pdf.save()
else:
	print("Ce script nécessite un fichier ouvert.")
