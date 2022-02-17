#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')


@client_article.route('/client/index')
@client_article.route('/client/article/show')      # remplace /client
def client_article_show():                                 # remplace client_index

    # Affichage filtre
    mycursor = get_db().cursor()
    sql = '''SELECT Produit.*, V2.*
        FROM Produit 
        INNER JOIN Variations V2 on Produit.idProduit = V2.idProduit'''
    list_param = []
    condition_and = ""
    if "filter_word" in session \
            or "filter_Grade" in session \
            or "filter_Taille" in session \
            or "filter_Fournisseur" in session \
            or "filter_prix_min" in session \
            or "filter_prix_max" in session \
            or "filter_type_article" in session:
        sql = sql + " WHERE "

    print()
    print()
    print("Show article")
    if "filter_word" in session:
        print(1)
        sql = sql + " Produit.LibelleProduit LIKE %s"
        print(2)
        print(sql)
        recherche = "%" + session["filter_word"] + "%"
        print('3 ' + recherche)
        list_param.append(recherche)
        print('4 ')
        print(list_param)
        condition_and = " AND "
        print(5)

    print('test prix ')
    if "filter_prix_min" in session or "filter_prix_max" in session:
        sql = sql + condition_and + " Produit.Prix BETWEEN %s AND %s "
        list_param.append(session["filter_prix_min"])
        list_param.append(session["filter_prix_max"])
        condition_and = " AND "

    print('test Type article ')
    if "filter_type_article" in session:
        sql = sql + condition_and + "("
        last_type = session["filter_type_article"][-1]
        for item in session['filter_type_article']:
            sql = sql + " Produit.idType = %s "
            if item != last_type:
                sql = sql + " or "
            list_param.append(item)
        sql = sql + ")"
        condition_and = " AND "

    print('test Grade article ')
    if "filter_Grade" in session:
        sql = sql + condition_and + "("
        last_grade = session["filter_Grade"][-1]
        for item in session['filter_Grade']:
            sql = sql + " Produit.idGrade = %s "
            if item != last_grade:
                sql = sql + " or "
            list_param.append(item)
        sql = sql + ")"
        condition_and = " AND "

    print('test Taille article ')
    if "filter_Taille" in session:
        sql = sql + condition_and + "("
        last_Taille = session["filter_Taille"][-1]
        for item in session['filter_Taille']:
            sql = sql + " Produit.idTaille = %s "
            if item != last_Taille:
                sql = sql + " or "
            list_param.append(item)
        sql = sql + ")"
        condition_and = " AND "

    print('test Taille article ')
    if "filter_Fournisseur" in session:
        sql = sql + condition_and + "("
        last_Fournisseur = session["filter_Fournisseur"][-1]
        for item in session['filter_Fournisseur']:
            sql = sql + " Produit.idFourniseur = %s "
            if item != last_Fournisseur:
                sql = sql + " or "
            list_param.append(item)
        sql = sql + ")"
        condition_and = " AND "

    print('resultat fin')
    tuple_sql = tuple(list_param)
    print(sql)
    print(list_param)
    mycursor.execute(sql, tuple_sql)
    article = mycursor.fetchall()

    # Affichage Panier
    print()
    print('Panier affichage')
    print('id user : ', session['user_id'])
    articles_panier = []
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, session['user_id'])
    print('id panier : ', idPanier)
    sql = '''SELECT contient.*
                    , Produit.LibelleProduit
                    , Produit.Prix
        FROM contient
        INNER JOIN Produit Produit on contient.idProduit = Produit.idProduit
        WHERE contient.idPanier = %s'''
    mycursor.execute(sql, idPanier)
    monPanier = mycursor.fetchall()

    # Prix total
    sql = '''SELECT SUM(contient.quantite * Produit.Prix) AS Prix_Total
            FROM contient
            INNER JOIN Produit Produit on contient.idProduit = Produit.idProduit
            WHERE contient.idPanier = %s'''
    mycursor.execute(sql, idPanier)
    prix_total = mycursor.fetchone()
    print('Prix_Total : ', prix_total["Prix_Total"])
    prix_total = prix_total["Prix_Total"]

    # For filter

    sql = "SELECT * FROM TypeProduit"
    mycursor.execute(sql)
    filter_type_article = mycursor.fetchall()

    sql = "SELECT * FROM Grade"
    mycursor.execute(sql)
    filter_Grade = mycursor.fetchall()

    sql = "SELECT * FROM Taille"
    mycursor.execute(sql)
    filter_Taille = mycursor.fetchall()

    sql = "SELECT * FROM Fourniseur"
    mycursor.execute(sql)
    filter_Fournisseur = mycursor.fetchall()

    return render_template('client/boutique/panier_article.html'
                           , article=article
                           , articlesPanier=articles_panier
                           , prix_total=prix_total
                           , filter_type_article=filter_type_article
                           , filter_Grade=filter_Grade
                           , filter_Taille=filter_Taille
                           , filter_Fournisseur=filter_Fournisseur
                           , monPanier=monPanier)

@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    sql ='''SELECT Produit.idProduit, LibelleProduit, Prix, Description, Stock, imageProduit
        FROM Produit
    INNER JOIN Variations V2 on Produit.idProduit = V2.idProduit
    WHERE Produit.idProduit = %s;
    '''
    mycursor.execute(sql,id)
    article = mycursor.fetchall()
    sql ='''SELECT * FROM Avis
            WHERE idProduit = %s;'''
    mycursor.execute(sql,id)
    commentaires = mycursor.fetchall()

    sql ="SELECT * FROM Commande;"
    mycursor.execute(sql)
    commandes_articles = mycursor.fetchall()
    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles)
