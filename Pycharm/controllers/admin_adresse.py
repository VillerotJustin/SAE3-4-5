#! /usr/bin/python
# -*- coding:utf-8 -*-
import numpy as np
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g, Response

from connexion_db import get_db
from matplotlib.figure import Figure
import matplotlib.pyplot as plt

import io
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

admin_adresse = Blueprint('admin_adresse', __name__,
                        template_folder='templates')

@admin_adresse.route('/admin/adresse/stats', methods=['GET', 'POST'])
def stats():
    mycursor = get_db().cursor()
    sql='''
    SELECT TRUNCATE((code_postale / 1000),0) as region
         , COUNT(idAdresse) as nbrAddDep
    From Adresse
    GROUP BY TRUNCATE((code_postale / 1000),0)
    ORDER BY region;
    '''
    mycursor.execute(sql)
    statsInfo = mycursor.fetchall()
    regions=""
    nbradresse=""
    for row in statsInfo:
        regions+=str(row['region'])+","
        nbradresse+=str(row['nbrAddDep'])+","
    regions=regions[0:-1]
    nbradresse=nbradresse[0:-1]
    return render_template('admin/adresse/stats.html', statsInfo=statsInfo, regions=regions, nbradresse=nbradresse)

@admin_adresse.route('/admin/adresse/graph', methods=['GET', 'POST'])
def plot_png():
    mycursor = get_db().cursor()
    sql = '''
        SELECT TRUNCATE((code_postale / 1000),0) as region
             , COUNT(idAdresse) as nbrAddDep
        From Adresse
        GROUP BY TRUNCATE((code_postale / 1000),0)
        ORDER BY region;
        '''
    mycursor.execute(sql)
    statsInfo = mycursor.fetchall()
    regions = [str(row['region']) for row in statsInfo]
    nbradresse = [int(row['nbrAddDep']) for row in statsInfo]
    fig = Figure()
    axis = fig.add_subplot(1, 1, 1)
    axis.set_xlabel('Régions')
    axis.set_ylabel("Nombre d'adresse")
    axis.set_title("Nombre d'adresse par région")
    xs = regions
    ys = nbradresse
    axis.bar(xs, ys)
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')