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
    sql = '''
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
    tuple_add = (adresse, code_postale, ville, session['user_id'])
    sql = '''
    INSERT INTO Adresse VALUE (NULL, %s, %s, %s, %s);
    '''
    mycursor.execute(sql, tuple_add)
    get_db().commit()
    print(tuple_add)

    return redirect(url_for('client_modif.client_profile'))


@client_modif.route('/client/modif/editAdresse/<int:idAdresse>')
def edit_adresse(idAdresse):
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM Adresse WHERE idAdresse=%s'''
    mycursor.execute(sql, idAdresse)
    Adresse = mycursor.fetchone()
    print(Adresse)
    return render_template('client/Profile/editAdresse.html', Adresse=Adresse)


@client_modif.route('/client/modif/valid_edit_Adresse/', methods=['POST'])
def valid_edit_adresse():
    mycursor = get_db().cursor()
    idAdresse = request.form.get('id', '')
    adresse = request.form.get('adresse', '')
    code_postale = request.form.get('code_postale', '')
    ville = request.form.get('ville', '')
    tuple_edit=(adresse, code_postale, ville, idAdresse)
    sql = '''
    UPDATE Adresse
    SET adresse=%s, code_postale=%s, ville=%s
    WHERE idAdresse=%s
    '''
    mycursor.execute(sql, tuple_edit)
    get_db().commit()
    return redirect(url_for('client_modif.client_profile'))


@client_modif.route('/client/modif/deleteAdresse/<int:idAdresse>', methods=['GET'])
def delete_Adresse(idAdresse):
    mycursor = get_db().cursor()

    # ---------------------------

    sql = '''SELECT * FROM Commande 
                 WHERE idAdresse = %s'''
    mycursor.execute(sql, (idAdresse))
    test_commande = mycursor.fetchall()
    for test in test_commande:
        print(test)
        if ((test.get("idEtat") != 3)):
            message = ("L'adresse avec pour id :" + str(idAdresse)
                       + " ne peut pas etre supprimé car elle est actuellement utiliser dans une commande en cours")
            flash(message)
            return redirect(url_for('client_modif.client_profile'))
        else:
            sql = '''DELETE FROM concerne WHERE idCommande = %s'''
            mycursor.execute(sql, (test["idCommande"]))
            get_db().commit()
            sql = '''DELETE FROM Commande WHERE idAdresse = %s AND idCommande = %s'''
            mycursor.execute(sql, (idAdresse, test["idCommande"]))
            get_db().commit()

    # ---------------------------

    sql = '''DELETE FROM Adresse WHERE idAdresse=%s'''
    mycursor.execute(sql, idAdresse)
    get_db().commit()
    print('Adresse suprimer: ', str(idAdresse))
    message = ("une adresse supprimé, id :" + str(idAdresse))
    flash(message)

    return redirect(url_for('client_modif.client_profile'))
