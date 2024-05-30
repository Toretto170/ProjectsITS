# Importo le librerie necessarie
import sqlite3
import requests
import csv
from io import StringIO

# Connessione al database SQLite
db = sqlite3.connect('wine_data.db')
cursor = db.cursor()

# Carico gli URL dei datasets forniti
red_wine_url = 'https://raw.githubusercontent.com/FabioGagliardiIts/datasets/main/wine_quality/winequality-red.csv'
white_wine_url = 'https://raw.githubusercontent.com/FabioGagliardiIts/datasets/main/wine_quality/winequality-white.csv'

# Creo le due tabelle (se non esistono)
cursor.execute('''
    CREATE TABLE IF NOT EXISTS red_wine (
        fixed_acidity REAL,
        volatile_acidity REAL,
        citric_acid REAL,
        residual_sugar REAL,
        chlorides REAL,
        free_sulfur_dioxide REAL,
        total_sulfur_dioxide REAL,
        density REAL,
        pH RAL,
        sulphates REAL,
        alcohol REAL,
        quality INTEGER
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS white_wine (
        fixed_acidity REAL,
        volatile_acidity REAL,
        citric_acid REAL,
        residual_sugar REAL,
        chlorides REAL,
        free_sulfur_dioxide REAL,
        total_sulfur_dioxide REAL,
        density REAL,
        pH REAL,
        sulphates REAL,
        alcohol REAL,
        quality INTEGER
    )
''')

db.commit()

# Creo una funzione che estrapola i dati dai CSV
def data_csv(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.text
    else:
        print("Non è possibile scaricare il file CSV")

# Creo una funzione che inserisce i dati dai CSV alle tabelle
def insert_data_csv(data,wine_data):
    csv_data = data.split("\n")
    csv_reader = csv.reader(csv_data, delimiter=";")

    for row in csv_reader:
        if len(row) == 12:
            cursor.execute(f'''
                INSERT INTO {wine_data} (fixed_acidity, volatile_acidity, citric_acid, residual_sugar, chlorides,
                free_sulfur_dioxide, total_sulfur_dioxide, density, pH, sulphates, alcohol, quality)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', row)

    db.commit()

# Richiamo le funzioni per inserimento dei dati
red_wine_data = data_csv(red_wine_url)
insert_data_csv(red_wine_data, "red_wine")

white_wine_data = data_csv(white_wine_url)
insert_data_csv(white_wine_data, "white_wine")

# Chiudo la connessione al database
db.close()





    














