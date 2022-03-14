#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_modif = Blueprint('client_modif', __name__,
                        template_folder='templates')

@client_modif.route('/client/modif/profile', methods=['GET'])
def client_profile():
    mycursor = get_db().cursor()
    sql='''
    SELECT * FROM Utilisateur WHERE idUser = %s;
    '''
    mycursor.execute(sql, session['user_id'])
    user = mycursor.fetchone()

    sql = '''
        SELECT * FROM Adresse WHERE idUser = %s;
        '''
    mycursor.execute(sql, session['user_id'])
    adresse = mycursor.fetchall()
    print(adresse)

    return render_template('client/Profile/profil.html', user=user, adresse=adresse)

@client_modif.route('/client/modif/add_Adresse')
def link_add_Adresse():
    return render_template('client/Profile/adresseAdd.html')

@client_modif.route('/client/modif/valid_add_adresse', methods=['POST'])
def add_Adresse():
    mycursor = get_db().cursor()
    adresse = request.form.get('adresse', '')
    code_postale = request.form.get('code_postale', '')
    ville = request.form.get('ville', '')
    tuple_add=(adresse, code_postale, ville, session['user_id'])
    sql='''
    INSERT INTO Adresse VALUE (NULL, %s, %s, %s, %s);
    '''
    mycursor.execute(sql, tuple_add)
    get_db().commit()
    print(tuple_add)

    return redirect(url_for('client_modif.client_profile'))

@client_modif.route('/client/modif/edit_Adresse/<int:id>')
def edit_type_article(id):
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM Adresse WHERE idAdresse=%s'''
    mycursor.execute(sql, id)
    Adresse = mycursor.fetchone()
    print(Adresse)
    return render_template('admin/type_article/edit_type_article.html', Adresse=Adresse)


@client_modif.route('/admin/type_article/edit/', methods=['POST'])
def valid_edit_type_article():
    mycursor = get_db().cursor()
    id = request.form.get('id', '')
    libelle = request.form.get('libelle', '')
    sql = '''UPDATE TypeProduit SET LibelleType=%s WHERE idType=%s'''
    mycursor.execute(sql, (str(libelle), id))
    get_db().commit()
    print('new libelle: ', str(libelle), '; id type: ', str(id))
    return redirect(url_for('admin_article.show_type_article'))