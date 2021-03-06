#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST']) # Fini
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
    print('idpanier : ', idPanier)

#   idCommande = NULL
    datecommande = datetime.now()

    # Id Adresse Doit faire en sorte que l'utilisateur puissent ajouter des adressse (création d'une adresse par default si pas d'adresse)
    sql = "SELECT idAdresse FROM Adresse WHERE idUser = %s"
    test = mycursor.execute(sql, idUser)
    if (test == 0):
        print('Pas d\'adresse, création d\'une adresse par default')
        tuple_adresse = ('default street', 00000, 'default city', idUser)
        sql = "INSERT INTO Adresse VALUES (NULL , %s, %s, %s, %s)"
        mycursor.execute(sql, tuple_adresse)
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

    sql = '''SELECT last_insert_id() AS last_insert_id;'''
    mycursor.execute(sql)
    info_last_id = mycursor.fetchone()
    idCommande = info_last_id['last_insert_id']
    print('idCommande : ', idCommande)

# ==================================== Remplis la commande

    # recupper les données

    sql = "SELECT idProduit, idVariation, quantite FROM contient WHERE idPanier = %s"
    mycursor.execute(sql, idPanier)
    lignes = mycursor.fetchall()
    print('lignes panier : ', lignes)
    # insere les données
    print()
    print('insere les données')
    for ligne in lignes:
        print('ligne : ', ligne)
        tuple_ligne = (ligne["idProduit"], idCommande, ligne["idVariation"], ligne["quantite"])
        print('tuple_ligne : ', tuple_ligne)
        sql = "INSERT INTO concerne VALUES (%s, %s, %s, %s)"
        mycursor.execute(sql, tuple_ligne)
        get_db().commit()

# ==================================== Vide le panier

    sql = "DELETE FROM contient Where idPanier = %s"
    mycursor.execute(sql, idPanier)
    get_db().commit()

# ==================================== Info pour choix de l'adresse

    sql = '''SELECT Produit.LibelleProduit AS nom
                           , concerne.quantite AS quantite
                           , Produit.Prix As prix
                           , concerne.quantite * Produit.Prix As prix_ligne
                     From Commande
                     INNER JOIN Etat Etat on Commande.idEtat = Etat.idEtat
                     INNER JOIN concerne concerne on Commande.idCommande = concerne.idCommande
                     INNER JOIN Produit Produit on concerne.idProduit = Produit.idProduit
                     WHERE Commande.idCommande = %s
            '''
    mycursor.execute(sql, idCommande)
    articles_commande = mycursor.fetchall()

    sql = '''
    SELECT *
    From Adresse
    WHERE idUser = %s
    '''
    mycursor.execute(sql, idUser)
    Adresses = mycursor.fetchall()

    return render_template('client/commandes/addCommande.html', Adresses=Adresses, articles_commande=articles_commande, idCommande=idCommande)
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()

    # recupperation de l'id de la commande a traiter
    idCommande = request.form.get('idCommande', 0)
    print('idCommande : ', idCommande)

    # Recuperation des commandes

    sql = '''SELECT Commande.idCommande AS id
                   , Commande.dateCommande AS date_achat
                   , SUM(concerne.quantite) As nbr_articles
                   , SUM(concerne.quantite * Produit.Prix)  As prix_total
                   , Commande.idEtat AS etat_id
                   , Etat.libelleEtat AS libelle
                   , Adresse.*
             From Commande
             INNER JOIN Etat Etat on Commande.idEtat = Etat.idEtat
             INNER JOIN concerne concerne on Commande.idCommande = concerne.idCommande
             INNER JOIN Produit Produit on concerne.idProduit = Produit.idProduit
             INNER JOIN Adresse on Commande.idAdresse = Adresse.idAdresse
             WHERE Commande.idUser = %s
             GROUP BY Commande.idCommande
    '''
    mycursor.execute(sql, session['user_id'])
    commandes = mycursor.fetchall()

    # Affichage de la commande a traiter

    sql = '''SELECT Produit.LibelleProduit AS nom
                       , concerne.quantite AS quantite
                       , Produit.Prix As prix
                       , concerne.quantite * Produit.Prix As prix_ligne
                 From Commande
                 INNER JOIN Etat Etat on Commande.idEtat = Etat.idEtat
                 INNER JOIN concerne concerne on Commande.idCommande = concerne.idCommande
                 INNER JOIN Produit Produit on concerne.idProduit = Produit.idProduit
                 WHERE Commande.idCommande = %s
        '''
    mycursor.execute(sql, idCommande)
    articles_commande = mycursor.fetchall()
    return render_template('client/commandes/show.html', commandes=commandes, articles_commande=articles_commande)

@client_commande.route('/client/modif/validadressecommande', methods=['get','post'])
def validadressecommande():
    mycursor = get_db().cursor()
    idAdresse = request.form.get('Adresse', '')
    idCommande= request.form.get('idCommande', '')
    tuple_edit = (idAdresse, idCommande)
    print("valid adresse: ",tuple_edit)
    sql = '''
        UPDATE Commande
        SET idAdresse=%s
        WHERE idCommande=%s
        '''
    mycursor.execute(sql, tuple_edit)
    get_db().commit()
    return redirect('/client/article/show')
