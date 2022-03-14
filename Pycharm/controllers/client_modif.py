#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_modif = Blueprint('client_modif', __name__,
                        template_folder='templates')

@client_modif.route('/client/modif/profile', methods=['POST'])
def client_profile():
    mycursor = get_db().cursor()
    sql='''
    SELECT * FROM Utilisateur WHERE idUser = %s;
    '''
    mycursor.execute(sql, session['user_id'])
    user = mycursor.fetchone()

    return render_template('client/profil.html', user=user)

