#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    #Variables
    idUser = session['user_id']
    mycursor = get_db().cursor()

# ==================================== Création de la commande

    # Id Panier
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, idUser)
    if (idPanier is None or idPanier == () or idPanier == 0):
        print('Panier inexistant création panier')
        sql = "INSERT INTO PanierUser VALUES (NULL , %s)"
        mycursor.execute(sql, idUser)
        get_db().commit()
        sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
        mycursor.execute(sql, idUser)
    idPanier = mycursor.fetchone()
    print('idpanier after fetchone : ', idPanier)
    idPanier = idPanier['idPanier']

#   idCommande = NULL
    datecommande = datetime.now()

    # Id Adresse Doit faire en sorte que l'utilisateur puissent ajouter des adressse (création d'une adresse par default si pas d'adresse)
    sql = "SELECT idAdresse FROM Adresse WHERE idUser = %s"
    test = mycursor.execute(sql, idUser)
    if (test == 0):
        print('Panier inexistant création panier')
        tuple_adresse = ('default street', 00000, 'default city', idUser)
        sql = "INSERT INTO Adresse VALUES (NULL , %s, %s, %s, %s)"
        mycursor.execute(sql, idUser)
        get_db().commit()
        sql = "SELECT idAdresse FROM Adresse WHERE idUser = %s"
        mycursor.execute(sql, idUser)
    idAdresse = mycursor.fetchone()
    print('idAdresse after fetchone : ', idAdresse)
    idAdresse = idAdresse['idAdresse']
    print('idAdresse : ', idAdresse)

    idEtat = 1      # Etat par defaut en traitement
    tuple_commande = (datecommande, idAdresse, idEtat, idUser)
    print('Tuple commande : ', tuple_commande)

    sql = "INSERT INTO Commande VALUES (NULL , %s, %s, %s, %s)"
    mycursor.execute(sql, tuple_commande)
    get_db().commit()

# ==================================== Remplis la commande

    # recupper les données

    sql = "SELECT idAdresse FROM Adresse WHERE idPanier = %s"
    mycursor.execute(sql, idPanier)
    lignes = mycursor.fetchall()
    print('lignes panier : ', lignes)

    # insere les données

    test = 1

# ==================================== Vide le panier

    sql = "DELETE FROM contient Where idPanier = %s"
    mycursor.execute(sql, idPanier)
    get_db().commit()

    flash(u'Commande ajoutée')
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()
    commandes = None
    articles_commande = None
    return render_template('client/commandes/show.html', commandes=commandes, articles_commande=articles_commande)

