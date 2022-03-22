#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_adresse = Blueprint('admin_adresse', __name__,
                        template_folder='templates')

@admin_adresse.route('/admin/adresse/stats')
def stats():
    test = 1

    return render_template('admin/stats.html', test=test)

