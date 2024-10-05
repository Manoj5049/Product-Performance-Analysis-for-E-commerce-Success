import psycopg2
from flask import Flask, render_template,request
import pandas as pd 


app = Flask(__name__)
# Replace the following values with your actual database credentials
dbname = 'postgres'
user = 'postgres'
password = '7780'
host = 'localhost'
port = '5432'

# Establish a connection to the PostgreSQL database
try:
    connection = psycopg2.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host,
        port=port
    )

    # Create a cursor object to execute SQL queries
    cursor = connection.cursor()

    # Execute your SQL queries here
    cursor.execute('Select * from information_schema.tables;')
    rows = cursor.fetchall()

# Iterate through the result
    # for row in rows:
    #     print(row)

except Exception as e:
    print(f"Error: Unable to connect to the database - {e}")

# finally:
#     # Close the cursor and connection
#     if cursor:
#         cursor.close()
#     if connection:
#         connection.close()

@app.route('/start', methods=['GET', 'POST'])
def start_page():
    return render_template('dmql_test.html')

@app.route('/process_query', methods=['GET', 'POST'])
def inp():
    if request.method == 'POST':
        print(request)
        query = request.form['query']
        print(query)
        cursor.execute(query)
        column_names = [desc[0] for desc in cursor.description]
        res = cursor.fetchall()
        output = pd.DataFrame(res)
        output.columns = column_names
        output.index = output.index + 1
    return render_template('output.html',output = output.to_html())

@app.route('/erdiag', methods=['GET', 'POST'])
def data_format():
    return render_template('dmql_test2.html')


if __name__ == '__main__':
    app.run(debug=True)