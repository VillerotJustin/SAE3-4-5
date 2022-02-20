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
    mycursor = get_db().cursor()
    libelle = request.form.get('libelle', '')
    sql = '''INSERT INTO TypeProduit VALUES
                (NULL, %s);'''
    mycursor.execute(sql, libelle)
    get_db().commit()
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

    # Recuperation donnee

    nom = request.form.get('nom', '')
    description = request.form.get('description', '')
    prix = float(request.form.get('Prix', ''))
    idFourniseur = int(request.form.get('fournisseur', None))
    idType = int(request.form.get('TypeProduit', None))
    idTaille = int(request.form.get('Taille', None))
    print('idTaille : ', idTaille)
    if (idTaille == 0):
        idTaille = None
        print('idTaille reatribution : ', idTaille)
    idGrade = int(request.form.get('Grade', None))
    print('idGrade : ', idGrade)
    if (idGrade == 0):
        idGrade = None
        print('idGrade reatribution : ', idGrade)
    tuple_add = (nom, prix, description, idFourniseur, idType, idTaille, idGrade)
    print('tuple_add : ', tuple_add)

    # Création du produit
    sql = '''INSERT INTO Produit VALUES (NULL, %s, %s, %s, %s, %s, %s, %s);'''
    mycursor.execute(sql, tuple_add)
    get_db().commit()

    # Recupperation de l'id du produit
    sql = '''SELECT last_insert_id() AS last_insert_id;'''
    mycursor.execute(sql)
    info_last_id = mycursor.fetchone()
    idProduit = info_last_id['last_insert_id']
    print('idProduit : ', idProduit)

    # donnee variation

    libelleVariation = ""
    image = request.form.get('Image', '')
    stock = request.form.get('stock', '')
    tuple_variation = (libelleVariation, image, stock, idProduit)
    print('tuple_variation : ', tuple_variation)

    # Création de la variation par default
    sql = '''INSERT INTO Variations VALUES (NULL, %s, %s, %s, %s);'''
    mycursor.execute(sql, tuple_variation)
    get_db().commit()

    print(u'article ajouté , nom: ', nom, ' - typeArticle:', idType, ' - prix:', prix, ' - stock:', stock, ' - description:', description, ' - image:', image)
    message = u'article ajouté , nom:'+nom + '- typeArticle:' + str(idType) + ' - prix:' + str(prix) + ' - stock:' + stock + ' - description:' + description + ' - image:' + image
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/article/delete/<int:id>', methods=['GET'])
def delete_article(id):
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM contient WHERE idProduit = %s;'''
    test_contient = mycursor.execute(sql, id)
    sql = '''SELECT * FROM concerne WHERE idProduit = %s;'''
    test_concerne = mycursor.execute(sql, id)
    if (test_contient == 1 or test_concerne == 1):
        message = ("L'article avec pour id :" + str(id) + " ne peut pas etre suprimmer car il est actuellement dans la commande d'un client")
        flash(message)
        return redirect(url_for('admin_article.show_article'))

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
    # Formulaire
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

    # Donnee produit
    sql = '''SELECT Produit.*, V2.*
                FROM Produit 
                INNER JOIN Variations V2 on Produit.idProduit = V2.idProduit
                WHERE Produit.idProduit = %s'''
    mycursor.execute(sql, id)
    Produit = mycursor.fetchone()

    return render_template('admin/article/edit_article.html', TypeProduit=TypeProduit
                                                            , fournisseur=fournisseur
                                                            , Taille=Taille
                                                            , Grade=Grade
                                                            , Produit=Produit)


@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    mycursor = get_db().cursor()

    # Recuperation donnee
    idProduit = int(request.form.get('id', None))
    nom = request.form.get('nom', '')
    description = request.form.get('description', '')
    prix = float(request.form.get('Prix', ''))
    idFourniseur = int(request.form.get('fournisseur', None))
    idType = int(request.form.get('TypeProduit', None))
    idTaille = int(request.form.get('Taille', None))
    print('idTaille : ', idTaille)
    if (idTaille == 0):
        idTaille = None
        print('idTaille reatribution : ', idTaille)
    idGrade = int(request.form.get('Grade', None))
    print('idGrade : ', idGrade)
    if (idGrade == 0):
        idGrade = None
        print('idGrade reatribution : ', idGrade)
    tuple_add = (nom, prix, description, idFourniseur, idType, idTaille, idGrade, idProduit)
    print('tuple_add : ', tuple_add)

    # edition du produit
    sql = '''
    UPDATE Produit 
    SET LibelleProduit = %s
        , Prix = %s
        , Description = %s
        , idFourniseur = %s
        , idType = %s
        , idTaille = %s
        , idGrade = %s
    WHERE idProduit = %s;
    '''
    mycursor.execute(sql, tuple_add)
    get_db().commit()


    # donnee variation
    sql = '''SELECT idVariation FROM Variations WHERE idProduit = %s'''
    mycursor.execute(sql, idProduit)
    idVariation = mycursor.fetchone()
    idVariation = idVariation["idVariation"]
    libelleVariation = ""
    image = request.form.get('Image', '')
    stock = request.form.get('stock', '')
    tuple_variation = (image, stock, idProduit, idVariation)
    print('tuple_variation : ', tuple_variation)

    # edition de la variation par default
    sql = '''
        UPDATE Variations 
        SET imageProduit = %s
            , Stock = %s
        WHERE idProduit = %s and idVariation = %s;
        '''
    mycursor.execute(sql, tuple_variation)
    get_db().commit()

    print(u'article modifié , nom : ', nom, ' - type_article:', idType, ' - prix:', prix, ' - stock:', stock, ' - description:', description, ' - image:', image)
    message = u'article modifié , nom:'+nom + '- type_article:' + str(idType) + ' - prix:' + str(prix) + ' - stock:'+  stock + ' - description:' + description + ' - image:' + image
    flash(message)
    return redirect(url_for('admin_article.show_article'))


@admin_article.route('/admin/type_article/details')
def show_details_type_article():
    return render_template('/admin/type_article/etat_type_article.html')