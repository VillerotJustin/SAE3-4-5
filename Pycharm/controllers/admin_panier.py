#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_panier = Blueprint('admin_panier', __name__,
                        template_folder='templates')

@admin_panier.route('/admin/panier/filtre', methods=['POST'])
def admin_panier_filtre():
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
        if filter_prix_min < filter_prix_max:
            session['filter_prix_min'] = int(filter_prix_min)
            session['filter_prix_max'] = int(filter_prix_max)
        else:
            flash(u'min < max')

    return redirect('/admin/article/show')
    # return redirect(url_for('client_index'))

@admin_panier.route('/admin/panier/filtre/suppr', methods=['POST'])
def admin_panier_filtre_suppr():
    session.pop('filter_word', None)
    session.pop('filter_type_article', None)
    session.pop('filter_Grade', None)
    session.pop('filter_Taille', None)
    session.pop('filter_Fournisseur', None)
    session.pop('filter_prix_min', None)
    session.pop('filter_prix_max', None)
    print("suppr filtre")
    return redirect('/admin/article/show')
    # return redirect(url_for('client_index'))
