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
    mycursor = get_db().cursor()
    sql='''SELECT Produit.idProduit, LibelleProduit, Prix, Description, Stock, imageProduit
        FROM Produit
    INNER JOIN Variations V2 on Produit.idProduit = V2.idProduit;'''
    mycursor.execute(sql)
    article = mycursor.fetchall()
    articles_panier = []
    sql="SELECT * FROM PanierUser"
    mycursor.execute(sql)
    panier = mycursor.fetchall()
    prix_total = None

    # For filter

    sql = "SELECT * FROM TypeProduit"
    mycursor.execute(sql)
    filter_type_article = mycursor.fetchall()

    return render_template('client/boutique/panier_article.html'
                           ,  article=article
                           , articlesPanier=articles_panier
                           , prix_total=prix_total
                           , filter_type_article=filter_type_article)

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
