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
    articles = []
    sql="SELECT Produit.idProduit, LibelleProduit, Prix, Description, Stock, imageProduit FROM Produit INNER JOIN BDD_lwilcza2.varie_de vd on Produit.idProduit = vd.idProduit INNER JOIN BDD_lwilcza2.Variations V on vd.idVariation = V.idVariation;"
    mycursor.execute(sql)
    article = mycursor.fetchall()
    types_articles = []
    sql="SELECT * FROM TypeProduit"
    mycursor.execute(sql)
    type_article = mycursor.fetchall()
    articles_panier = []
    sql="SELECT * FROM PanierUser"
    mycursor.execute(sql)
    panier = mycursor.fetchall()
    prix_total = None
    return render_template('client/boutique/panier_article.html',  article=article, articlesPanier=articles_panier, prix_total=prix_total, itemsFiltre=types_articles)

@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    sql ='''SELECT Produit.idProduit, LibelleProduit, Prix, Description, Stock, imageProduit 
    FROM Produit 
    INNER JOIN BDD_lwilcza2.varie_de vd on Produit.idProduit = vd.idProduit INNER JOIN BDD_lwilcza2.Variations V on vd.idVariation = V.idVariation
    WHERE Produit.idProduit = %s;
    '''
    mycursor.execute(sql,id)
    article = mycursor.fetchall()
    sql ="SELECT * FROM Avis;"
    mycursor.execute(sql)
    commentaires = mycursor.fetchall()

    sql ="SELECT * FROM Commande;"
    mycursor.execute(sql)
    commandes_articles = mycursor.fetchall()
    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles)
