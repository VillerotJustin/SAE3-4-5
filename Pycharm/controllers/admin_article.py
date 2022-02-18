#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

import pymysql.cursors
from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                        template_folder='templates')


@admin_article.route('/admin/article/show')
def show_article():
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

    return render_template('admin/article/show_article.html'
                           , articles=article
                           , filter_type_article=filter_type_article
                           , filter_Grade=filter_Grade
                           , filter_Taille=filter_Taille
                           , filter_Fournisseur=filter_Fournisseur)


@admin_article.route('/admin/type_article/show')
def show_type_article():
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM TypeProduit;'''
    mycursor.execute(sql)
    type_article = mycursor.fetchall()
    return render_template('admin/type_article/show_type_article.html', type_article=type_article)


@admin_article.route('/admin/type_article/add')
def add_type_article():
    return render_template('admin/type_article/add_type_article.html')


@admin_article.route('/admin/type_article_add', methods=['POST'])
def valid_add_type_article():
    libelle = request.form.get('libelle', '')
    sql = '''INSERT INTO TypeProduit VALUES
                (NULL, %s);'''
    mycursor.execute(sql, libelle)
    my
    return render_template('admin/type_article/show_type_article.html')


@admin_article.route('/admin/type_article/edit/<int:id>')
def edit_type_article(id):
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM TypeProduit WHERE idType=%s'''
    mycursor.execute(sql, id)
    type_article = mycursor.fetchall()
    return render_template('admin/type_article/edit_type_article.html', type_article=type_article)


@admin_article.route('/admin/type_article/edit/', methods=['POST'])
def valid_edit_type_article():
    mycursor = get_db().cursor()
    id = request.form.get('id', '')
    libelle = request.form.get('libelle','')
    sql = '''UPDATE TypeProduit SET LibelleType=%s WHERE idType=%s'''
    mycursor.execute(sql, (str(libelle), id))
    get_db().commit()
    print('new libelle: ', str(libelle), '; id type: ', str(id))
    return redirect(url_for('admin_article.show_type_article'))

@admin_article.route('/admin/type_article/delete/confirm/<int:id>', methods=['GET'])
def delete_type_article(id):
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM Produit 
             JOIN Variations ON Produit.idProduit = Variations.idProduit 
             WHERE idType=%s'''
    mycursor.execute(sql, id)
    articles = mycursor.fetchall()
    sql = '''SELECT COUNT(idProduit) AS nbr_articles FROM Produit WHERE idType=%s'''
    mycursor.execute(sql, id)
    nbr_articles = mycursor.fetchall()
    print(nbr_articles)
    return render_template('admin/type_article/delete_type_article.html', articles=articles, nbr_articles=nbr_articles)


@admin_article.route('/admin/type_article/delete/')
def valid_delete_type_article():
    mycursor = get_db().cursor()
    # bar = request.args.to_dict()
    # print(bar)
    id_type = request.args.get('id','')
    id_produit = request.args.get('id_article', '')
    sql = '''DELETE FROM Produit WHERE idType = %s AND idProduit=%s'''
    mycursor.execute(sql, (id_type, id_produit))
    print("un type d'article supprimé, id :", id)
    flash(u"un type d'article supprimé, id : " + id)
    return redirect(url_for('admin_article.show_type_article'))


@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM TypeProduit;'''
    mycursor.execute(sql)
    TypeProduit = mycursor.fetchall()
    sql = '''SELECT * FROM Fourniseur;'''
    mycursor.execute(sql)
    fournisseur = mycursor.fetchall()
    sql = '''SELECT * FROM Taille;'''
    mycursor.execute(sql)
    Taille = mycursor.fetchall()
    sql = '''SELECT * FROM Grade;'''
    mycursor.execute(sql)
    Grade = mycursor.fetchall()

    return render_template('admin/article/add_article.html', TypeProduit=TypeProduit, fournisseur=fournisseur, Taille=Taille, Grade=Grade)


@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()
    nom = request.form.get('nom', '')
    type_article_id = request.form.get('type_article_id', '')
    # type_article_id = int(type_article_id)
    prix = request.form.get('prix', '')
    stock = request.form.get('stock', '')
    description = request.form.get('description', '')
    image = request.form.get('image', '')
    sql = '''INSERT INTO Produit VALUES
                (NULL, %s, %s, %s, NULL, NULL, NULL, NULL);'''
    mycursor.execute(sql,(nom, prix, description,))
    get_db().commit()

    print(u'article ajouté , nom: ', nom, ' - type_article:', type_article_id, ' - prix:', prix, ' - stock:', stock, ' - description:', description, ' - image:', image)
    message = u'article ajouté , nom:'+nom + '- type_article:' + type_article_id + ' - prix:' + prix + ' - stock:'+  stock + ' - description:' + description + ' - image:' + image
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/article/delete/<int:id>', methods=['GET'])
def delete_article(id):
    mycursor = get_db().cursor()
    sql = '''DELETE FROM Variations WHERE idProduit = %s;'''
    mycursor.execute(sql, id)
    get_db().commit()
    sql = '''DELETE FROM Produit WHERE idProduit = %s;'''
    mycursor.execute(sql, id)
    get_db().commit()
    print("un article supprimé, id :" + str(id))
    message = ("un article supprimé, id :" + str(id))
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/article/edit/<int:id>', methods=['GET'])
def edit_article(id):
    mycursor = get_db().cursor()
    article = None
    types_articles = None
    return render_template('admin/article/edit_article.html', article=article, types_articles=types_articles)


@admin_article.route('/admin/article/edit/<int:id>', methods=['POST'])
def valid_edit_article():
    mycursor = get_db().cursor()
    nom = request.form['nom']
    id = request.form.get('id', '')
    type_article_id = request.form.get('type_article_id', '')
    #type_article_id = int(type_article_id)
    prix = request.form.get('prix', '')
    stock = request.form.get('stock', '')
    description = request.form.get('description', '')
    image = request.form.get('image', '')

    print(u'article modifié , nom : ', nom, ' - type_article:', type_article_id, ' - prix:', prix, ' - stock:', stock, ' - description:', description, ' - image:', image)
    message = u'article modifié , nom:'+nom + '- type_article:' + type_article_id + ' - prix:' + prix + ' - stock:'+  stock + ' - description:' + description + ' - image:' + image
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/type_article/details')
def show_details_type_article():
    return render_template('/admin/type_article/etat_type_article.html')