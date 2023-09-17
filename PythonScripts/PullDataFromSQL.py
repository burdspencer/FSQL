#!/usr/bin/env python
# coding: utf-8

# In[6]:


#1. Get Libraries needed to gather data
import numpy as np
import pandas as pd
import os
from datetime import date
import pyarrow.feather as feather
import pyodbc
import sqlalchemy as sa
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.linear_model import SGDClassifier, LinearRegression
from sklearn.model_selection import train_test_split


# In[7]:


#engine = create_engine('mssql+pyodbc://python@DESKTOP-OPJ55MD\SQLEXPRESS')
import pyodbc

connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=.\SQLEXPRESS;DATABASE=ProFootballReference;Trusted_Connection=yes;')


df = pd.DataFrame(pd.read_sql_query("EXEC ssp_PullScheduleData 2022", connection))

#cursor=connection.cursor()
#cursor.execute("EXEC ssp_PullScheduleData")
#df = pd.DataFrame(cursor.fetchall())
#cursor.close()
connection.close()

df.columns
#connection = sqlite3.connect('DESKTOP-OPJ55MD\SQLExpress\ProFootballReference')


# In[16]:


X = df[[ 'HomeFlag','AvgPointsFor',
       'AvgPointsAgainst', 'AvgOff1stD', 'AvgOffTotYd', 'AvgOffPassYd',
       'AvgOffRushYd', 'AvgOffTO', 'AvgDef1stD', 'AvgDefTotYd', 'AvgDefPassYd',
       'AvgDefRushYd', 'AvgDefTO', 'AvgExPointsOff', 'AvgExPointsDef',
       'AvgExPointsSpecial', 'LastPointsFor', 'LastPointsAgainst',
       'LastOff1stD', 'LastOffTotYd', 'LastOffPassYd', 'LastOffRushYd',
       'LastOffTO', 'LastDef1stD', 'LastDefTotYd', 'LastDefPassYd',
       'LastDefRushYd', 'LastDefTO', 'LastExPointsOff', 'LastExPointsDef',
       'LastExPointsSpecial']]
X.replace({"Y" : 1, "N" : 0}, inplace=True)
X = X.fillna(0)
Y = df['Result']

Y.replace({"W" : 1, "T" : 0, "L" : -1}, inplace=True)

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2)

names = ["Nearest_Neighbors", "Linear_SVM", "Polynomial_SVM", "RBF_SVM", "Gaussian_Process",
         "Gradient_Boosting", "Decision_Tree", "Extra_Trees", "Random_Forest", "Neural_Net", "AdaBoost",
         "Naive_Bayes", "QDA", "SGD"]

classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    SVC(kernel="poly", degree=3, C=0.025),
    SVC(kernel="rbf", C=1, gamma=2),
    GaussianProcessClassifier(1.0 * RBF(1.0)),
    GradientBoostingClassifier(n_estimators=100, learning_rate=1.0),
    DecisionTreeClassifier(max_depth=5),
    ExtraTreesClassifier(n_estimators=10, min_samples_split=2),
    RandomForestClassifier(max_depth=5, n_estimators=100),
    MLPClassifier(alpha=1, max_iter=1000),
    AdaBoostClassifier(n_estimators=100),
    GaussianNB(),
    QuadraticDiscriminantAnalysis(),
    SGDClassifier(loss="hinge", penalty="l2")]


model = LinearRegression()
model.fit(X, Y)

r_sq = model.score(X, Y)
print(f"coefficient of determination: {r_sq}")

print(f"intercept: {model.intercept_}")

print(f"coefficients: {model.coef_}")

    
scores = []
for name, clf in zip(names, classifiers):
    clf.fit(X_train, Y_train)
    score = clf.score(X_test, Y_test)
    scores.append(score)

df = pd.DataFrame()
df['name'] = names
df['score'] = scores


# In[17]:


df.sort_values('score',ascending=False)


# In[ ]:




