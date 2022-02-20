#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                          template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])  # Fini
def client_panier_add():
    mycursor = get_db().cursor()
    idProduit = request.form.get('idProduit', None)
    idVariation = request.form.get('idVariation', None)
    quantite = request.form.get('quantite', None)
    print('ajout panier')
    # Id Panier
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, session['user_id'])
    if (idPanier is None or idPanier == () or idPanier == 0):
        print('Panier inexistant création panier')
        sql = "INSERT INTO PanierUser VALUES (NULL , %s)"
        mycursor.execute(sql, session['user_id'])
        get_db().commit()
        sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
        mycursor.execute(sql, session['user_id'])
    idPanier = mycursor.fetchone()
    print('idpanier after fetchone : ', idPanier)
    idPanier = idPanier['idPanier']

    # Ajout dans le panier
    print('id Produit : ', idProduit)
    print('id panier : ', idPanier)
    tuple_Panier = (idProduit, idPanier, idVariation)
    print('tuple : ', tuple_Panier)
    sql = "SELECT * FROM contient WHERE idProduit = %s AND idPanier = %s AND idVariation = %s;"
    mycursor.execute(sql, tuple_Panier)
    test = mycursor.fetchall()
    print('test : ', test)
    if (test is None or test == ()):
        tuple_Panier = (idProduit, idPanier, idVariation, quantite)
        print('produit pas dans le panier')
        sql = "INSERT INTO contient VALUES (%s, %s, %s, %s)"
        mycursor.execute(sql, tuple_Panier)
        get_db().commit()
    else:
        print('produit dans le panier')
        tuple_Panier = (quantite, idProduit, idPanier, idVariation)
        sql = "UPDATE contient set quantite=(quantite+ %s) WHERE idProduit = %s AND idPanier = %s AND idVariation = %s;"
        mycursor.execute(sql, tuple_Panier)
        get_db().commit()
    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))


@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    idProduit = request.form.get('idProduit', None)
    idVariation = request.form.get('idVariation', None)

    # Id Panier
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, session['user_id'])
    if (idPanier is None or idPanier == () or idPanier == 0):
        print('Panier inexistant création panier')
        sql = "INSERT INTO PanierUser VALUES (NULL , %s)"
        mycursor.execute(sql, session['user_id'])
        get_db().commit()
        sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
        mycursor.execute(sql, session['user_id'])
    idPanier = mycursor.fetchone()
    print('idpanier after fetchone : ', idPanier)
    idPanier = idPanier['idPanier']

    # Diminue la quantite
    print('Diminution de la quantite')
    tuple_Panier = (idProduit, idPanier, idVariation)
    # test quantite
    sql = "SELECT contient.quantite FROM contient WHERE idProduit = %s AND idPanier = %s AND idVariation = %s;"
    mycursor.execute(sql, tuple_Panier)
    test_quantite = mycursor.fetchone()
    test_quantite = test_quantite["quantite"]
    print('test quantite : ', test_quantite)


    if (test_quantite == 1):
        sql = "DELETE FROM contient WHERE idProduit = %s AND idPanier = %s AND idVariation = %s;"
        mycursor.execute(sql, tuple_Panier)
        get_db().commit()
    else:
        sql = "UPDATE contient set quantite=(quantite-1) WHERE idProduit = %s AND idPanier = %s AND idVariation = %s;"
        mycursor.execute(sql, tuple_Panier)
        get_db().commit()

    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))


@client_panier.route('/client/panier/vider', methods=['POST'])  # Fini
def client_panier_vider():
    mycursor = get_db().cursor()

    # Id Panier
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, session['user_id'])
    if (idPanier is None or idPanier == () or idPanier == 0):
        print('Panier inexistant création panier')
        sql = "INSERT INTO PanierUser VALUES (NULL , %s)"
        mycursor.execute(sql, session['user_id'])
        get_db().commit()
        sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
        mycursor.execute(sql, session['user_id'])
    idPanier = mycursor.fetchone()
    print('idpanier after fetchone : ', idPanier)
    idPanier = idPanier['idPanier']

    # Vide le panier
    sql = "DELETE FROM contient Where idPanier = %s"
    mycursor.execute(sql, idPanier)
    get_db().commit()

    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    idProduit = request.form.get('idProduit', None)
    idVariation = request.form.get('idVariation', None)
    mycursor = get_db().cursor()

    # Id Panier
    sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
    idPanier = mycursor.execute(sql, session['user_id'])
    if (idPanier is None or idPanier == () or idPanier == 0):
        print('Panier inexistant création panier')
        sql = "INSERT INTO PanierUser VALUES (NULL , %s)"
        mycursor.execute(sql, session['user_id'])
        get_db().commit()
        sql = "SELECT idPanier FROM PanierUser WHERE idUser = %s"
        mycursor.execute(sql, session['user_id'])
    idPanier = mycursor.fetchone()
    print('idpanier after fetchall : ', idPanier)
    idPanier = idPanier['idPanier']

    # Supprime la ligne
    tuple_delete = (idPanier, idProduit, idVariation)
    print('Delete line')
    print('id Produit : ', idProduit)
    print('id panier : ', idPanier)
    print('tuple_delete : ', tuple_delete)
    sql = "DELETE FROM contient Where idPanier = %s AND idProduit = %s AND idVariation = %s"
    mycursor.execute(sql, tuple_delete)
    get_db().commit()

    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre', methods=['POST'])  # Fini
def client_panier_filtre():
    mycursor = get_db().cursor()
    filter_word = request.form.get('filter_word', None)
    filter_type_article = request.form.getlist('filter_type_article', None)
    filter_Grade = request.form.getlist('filter_Grade', None)
    filter_Taille = request.form.getlist('filter_Taille', None)
    filter_Fournisseur = request.form.getlist('filter_Fournisseur', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    print("word: " + filter_word + str(len(filter_word)))

    if filter_word or filter_word == "":
        if len(filter_word) > 1:
            session['filter_word'] = filter_word
        else:
            if len(filter_word) == 1:
                flash(u'votre Mot recherché doit être composé d\'au moins 2 lettres')
            else:
                session.pop('filter_word', None)

    if filter_type_article and filter_type_article != []:
        print("filter_type_article : ", filter_type_article)
        if isinstance(filter_type_article, list):
            check_filter_type_article = True
            for number_type_article in filter_type_article:
                print('test', number_type_article)
                if not number_type_article.isdecimal():
                    check_filter_type_article = False
                if check_filter_type_article:
                    session['filter_type_article'] = filter_type_article
                    print(session['filter_type_article'])

    if filter_Grade and filter_Grade != []:
        print("filter_Grade : ", filter_Grade)
        if isinstance(filter_Grade, list):
            check_filter_Grade = True
            for number_departement in filter_Grade:
                print('test', number_departement)
                if not number_departement.isdecimal():
                    check_filter_Grade = False
                if check_filter_Grade:
                    session['filter_Grade'] = filter_Grade

    if filter_Taille and filter_Taille != []:
        print("filter_Taille : ", filter_Taille)
        if isinstance(filter_Taille, list):
            check_filter_Taille = True
            for number_departement in filter_Taille:
                print('test', number_departement)
                if not number_departement.isdecimal():
                    check_filter_Taille = False
                if check_filter_Taille:
                    session['filter_Taille'] = filter_Taille

    if filter_Fournisseur and filter_Fournisseur != []:
        print("filter_Fournisseur : ", filter_Fournisseur)
        if isinstance(filter_Fournisseur, list):
            check_filter_Fournisseur = True
            for number_departement in filter_Fournisseur:
                print('test', number_departement)
                if not number_departement.isdecimal():
                    check_filter_Fournisseur = False
                if check_filter_Fournisseur:
                    session['filter_Fournisseur'] = filter_Fournisseur

    print("filter_prix : ")
    if filter_prix_min or filter_prix_max:
        print("min " + str(filter_prix_min))
        print("max " + str(filter_prix_max))
        print(20 < 100)
        if (float(filter_prix_min) <= float(filter_prix_max)):
            session['filter_prix_min'] = int(filter_prix_min)
            session['filter_prix_max'] = int(filter_prix_max)
            print(session['filter_prix_min'])
            print(session['filter_prix_max'])

        else:
            flash(u'min < max')

    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])  # Fini
def client_panier_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_type_article', None)
    session.pop('filter_Grade', None)
    session.pop('filter_Taille', None)
    session.pop('filter_Fournisseur', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    print("suppr filtre")
    return redirect('/client/article/show')
    # return redirect(url_for('client_index'))
