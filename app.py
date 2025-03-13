# app.py
from flask import Flask, render_template, request, redirect, url_for, flash, session
import pymysql
import db
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# Ruta para la página de inicio (home)
@app.route('/')
def home():
    return render_template('home.html')


@app.route('/gestion_restaurant/<int:restaurant_id>', methods=['GET', 'POST'])
def gestion_restaurant(restaurant_id):
    connection = db.get_connection()
    cursor = connection.cursor()

    # Ver la capacidad actual del restaurante
    cursor.execute('SELECT capacity FROM restaurant WHERE restaurant_id = %s', (restaurant_id,))
    restaurant = cursor.fetchone()

    if request.method == 'POST':
        # Si se está actualizando la capacidad
        if 'capacity' in request.form:
            new_capacity = request.form['capacity']
            cursor.execute('UPDATE restaurant SET capacity = %s WHERE restaurant_id = %s', 
                           (new_capacity, restaurant_id))
            connection.commit()
            return redirect(url_for('gestion_restaurant', restaurant_id=restaurant_id))

        # Si se está gestionando una reserva (confirmar o rechazar)
        reserve_id = request.form['reserve_id']
        action = request.form['action']

        cursor.execute('SELECT dinner FROM reserve WHERE reserve_id = %s', (reserve_id,))
        reserve = cursor.fetchone()
        dinner_count = reserve['dinner']

        if action == 'confirm':
            # Actualizar capacidad al confirmar reserva
            new_capacity = restaurant['capacity'] - dinner_count
            cursor.execute('UPDATE restaurant SET capacity = %s WHERE restaurant_id = %s', 
                           (new_capacity, restaurant_id))
            cursor.execute('UPDATE reserve SET estatus = %s WHERE reserve_id = %s', 
                           ('confirmada', reserve_id))

        elif action == 'reject':
            # Recuperar capacidad al rechazar reserva
            new_capacity = restaurant['capacity'] + dinner_count
            cursor.execute('UPDATE restaurant SET capacity = %s WHERE restaurant_id = %s', 
                           (new_capacity, restaurant_id))
            cursor.execute('UPDATE reserve SET estatus = %s WHERE reserve_id = %s', 
                           ('rechazada', reserve_id))
        elif action == 'delete':
            cursor.execute('DELETE FROM reserve WHERE reserve_id = %s', (reserve_id,))
            #recuperar capacidad al rechazar reserva
            new_capacity = restaurant['capacity'] + dinner_count
            cursor.execute('UPDATE restaurant SET capacity = %s WHERE restaurant_id = %s', 
                           (new_capacity, restaurant_id))
            cursor.execute('UPDATE reserve SET estatus = %s WHERE reserve_id = %s', 
                           ('rechazada', reserve_id))
            

        connection.commit()
        return redirect(url_for('gestion_restaurant', restaurant_id=restaurant_id))

    # Obtener las reservas del restaurante
    cursor.execute('SELECT r.reserve_id, r.date, r.dinner, r.estatus, c.name AS customer_name, c.phone_number '
                   'FROM reserve r '
                   'JOIN customer c ON r.customer_id = c.customer_id '
                   'WHERE r.restaurant_id = %s', (restaurant_id,))
    reservations = cursor.fetchall()
    
    cursor.close()
    connection.close()
    

    return render_template('gestion_restaurant.html', 
                           capacity=restaurant['capacity'], 
                           reservations=reservations, 
                           restaurant_id=restaurant_id) 
    
    
# Ejecutar la aplicación
if __name__ == '__main__':
    app.run(debug=True, port=80)