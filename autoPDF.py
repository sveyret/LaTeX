#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import getopt

try:
	from scribus import *
    
except ImportError:
	print 'Ce script doit être exécuté depuis Scribus.'
	sys.exit(1)

syntaxe = "scribus -g -ns <inputfile.sla> -py " + sys.argv[0] + " <sortie.pdf> <fichier.data>"
pdf_sortie = ''
fichier_data = ''

for opt in sys.argv[1:]:
	if opt.endswith(".pdf"):
		pdf_sortie = opt
	elif opt.endswith(".data"):
		fichier_data = opt
	else:
		print("Paramètre non reconnu ignoré: {}".format(opt))

if pdf_sortie == "" or fichier_data == "":
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

resume = resume.replace(" \\par ", "\r")

dirtyDoc = False

def changeText(obj, text):
	text = text.rstrip("\r\n")
	if text == "":
		text = " "
	deselectAll()
	selectObject(obj)
	selectText(0, getTextLength())
	if text != getText():
		deleteText()
		insertText(text, -1)
		return True
	return False

if haveDoc():
	dirtyDoc |= changeText("Auteur", auteur)
	dirtyDoc |= changeText("AuteurDos", auteur)
	dirtyDoc |= changeText("AuteurTranche", auteur)
	dirtyDoc |= changeText("Titre", titre)
	dirtyDoc |= changeText("TitreDos", titre)
	dirtyDoc |= changeText("TitreTranche", titre)
	dirtyDoc |= changeText("Contributeur", contributeur)
	dirtyDoc |= changeText("Éditeur", editeur)
	dirtyDoc |= changeText("ÉditeurDos", editeur)
	dirtyDoc |= changeText("Résumé", resume)
	if dirtyDoc:
		saveDoc()
	pdf = PDFfile()
	pdf.file = pdf_sortie
	pdf.save()
else:
	print("Ce script nécessite un fichier ouvert.")
