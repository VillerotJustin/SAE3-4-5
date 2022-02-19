#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show')
def admin_commande_show():
        mycursor = get_db().cursor()
        # Recuperation des commandes

        sql = '''SELECT Commande.idCommande AS id
                       , Commande.dateCommande AS date_achat
                       , SUM(concerne.quantite) As nbr_articles
                       , SUM(concerne.quantite * Produit.Prix)  As prix_total
                       , Commande.idEtat AS etat_id
                       , Etat.libelleEtat AS libelle
                 From Commande
                 INNER JOIN Etat Etat on Commande.idEtat = Etat.idEtat
                 INNER JOIN concerne concerne on Commande.idCommande = concerne.idCommande
                 INNER JOIN Produit Produit on concerne.idProduit = Produit.idProduit
                 WHERE Commande.idUser = 2
                 GROUP BY Commande.idCommande
        '''
        mycursor.execute(sql)
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
            '''
        mycursor.execute(sql)
        articles_commande = mycursor.fetchall()
        return render_template('admin/commandes/show.html', commandes=commandes, articles_commande=articles_commande)


@admin_commande.route('/admin/commande/valider', methods=['get'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    id_commande = request.args.get('id', '')
    print(id_commande)
    sql = '''UPDATE Commande SET idEtat=2 WHERE idCommande=%s; '''
    mycursor.execute(sql, id_commande)
    get_db().commit()
    return redirect('/admin/commande/show') 
