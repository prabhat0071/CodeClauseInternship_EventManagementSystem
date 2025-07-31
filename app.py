from flask import Flask, request, redirect, render_template,url_for,flash, session, flash
from db_config import get_connection
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import timedelta
from decimal import Decimal

app = Flask(__name__)
app.secret_key = 'prabhu$2025@secure_key1222'

@app.route('/signup', methods=['POST'])
def signup():
    full_name = request.form['full_name']
    email = request.form['email']
    phone = request.form['phone']
    password = request.form['password_hash']
    hashed_password = generate_password_hash(password)
    confirm_password = request.form['confirm_password']
    if password != confirm_password:
        return "Passwords do not match"
    conn = get_connection()
    cursor = conn.cursor()

    # Check if user already exists
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    existing_user = cursor.fetchone()
    if existing_user:
        return "User already exists"

    # Insert new user
    cursor.execute("INSERT INTO users (full_name, email, phone, password_hash) VALUES (%s, %s, %s, %s)",
                   (full_name, email, phone, hashed_password))
    conn.commit()
    cursor.close()
    conn.close()

    return redirect("/login")  # ya koi confirmation page

# 🏠 Home page
@app.route('/')
def home():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, title, image_filename FROM events ORDER BY id DESC LIMIT 3")
    events = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('index.html', events=events)

@app.route('/signup', methods=['GET'])
def signup_form():
    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])

def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        remember = 'remember_me' in request.form  # ✅ Checkbox check
        conn = get_connection()
        cursor = conn.cursor()

        # ✅ role bhi select karo
        cursor.execute("SELECT id, password_hash, role , full_name FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user and check_password_hash(user[1], password):
            session['user_id'] = user[0]
            session['role'] = user[2]  # tuple ka 3rd item
            session['full_name'] = user[3]
            
               # ✅ If "remember me" checked, set session to last 7 days
            if remember:
                session.permanent = True
                app.permanent_session_lifetime = timedelta(days=7)
            else:
                session.permanent = False  # session browser band hone pe khatam

            # ✅ Role check
            if user[2] == 'admin':
                return redirect(url_for('dashboard'))  # Flask route name
            else:
                return redirect(url_for('book_ticket'))
        else:
            return "Invalid email or password"

    return render_template('login.html')
# 📋 DASHBOARD (Login ke baad user ko yahan bhejna)    
@app.route('/logout')
def logout():
    session.clear()  # sabhi session keys remove ho jaayengi
    return redirect(url_for('login'))  # logout ke baad login page pe bhej do    
    



@app.route('/admin/dashboard', methods=['GET', 'POST'])
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    conn = get_connection()
    cursor = conn.cursor()

    # ✅ Count total users
    cursor.execute("SELECT COUNT(*) FROM users")
    total_users = cursor.fetchone()[0]
    return render_template('dashboard.html',total_users=total_users)

@app.route('/admin/users')
def list_users():
    # Session check (optional)
    if 'role' not in session or session['role'] != 'admin':
        return redirect(url_for('login'))

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, full_name, email, role FROM users")
    users = cursor.fetchall()
    conn.close()
    
    return render_template('admin-users.html', users=users)

@app.route('/admin/delete_user/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    if 'role' not in session or session['role'] != 'admin':
        return redirect(url_for('login'))

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
    conn.commit()
    conn.close()
    return redirect(url_for('list_users'))


@app.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']

        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user:
            return redirect(url_for('reset_password', email=email))
        else:
            return "Email not found"

    return render_template('forgot_password.html')

@app.route('/reset-password/<email>', methods=['GET', 'POST'])
def reset_password(email):
    if request.method == 'POST':
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']

        if new_password != confirm_password:
            return "Passwords do not match"

        hashed_password = generate_password_hash(new_password)

        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE users SET password_hash = %s WHERE email = %s", (hashed_password, email))
        conn.commit()

        return redirect(url_for('login'))

    return render_template('reset_password.html', email=email)


@app.route('/attendees', methods=['GET'])
def attendees_form():
    return render_template('attendees.html')

@app.route('/submit-attendee', methods=['POST'])
def submit_attendee():
    name = request.form['name']
    email = request.form['email']
    phone = request.form['phone']
    event = request.form['event_type']
    status = request.form['status']

    # ✅ Insert into MySQL
    insert_query = """
        INSERT INTO attendees (name, email, phone, event_type, status)
        VALUES (%s, %s, %s, %s, %s)
    """
    values = (name, email, phone, event, status)
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(insert_query, values)
    conn.commit()

    return redirect(url_for('thank_you'))

@app.route('/thank-you')
def thank_you():
    # return "<h2>✅ Form submitted successfully!</h2>"
    return render_template("thankyou.html")


# @app.route('/admin-attendees', methods=['GET'])
# def admin_attendees_form():
#     return render_template('admin-attendees.html')


@app.route('/admin/attendees')
def admin_attendees():
    
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # dictionary=True for column names
    cursor.execute("SELECT * FROM attendees ORDER BY created_at DESC")
    attendees = cursor.fetchall()
    conn.close()
    return render_template('admin-attendees.html', attendees=attendees)


# @app.route('/admin/events', methods=['GET'])
# def admin_event_form():
#     return render_template('events.html')


@app.route("/admin/events")
def admin_event_form():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # dictionary=True for column names
    cursor.execute("SELECT * FROM events")
    event_data = cursor.fetchall()
    conn.close()
    return render_template("events.html", events=event_data)

@app.route('/admin/add-event', methods=['GET'])
def add_event_form():
    return render_template('add_event.html')

@app.route('/add_event', methods=['POST'])
def add_admin_event():
    user_id = session['user_id']
    title = request.form['title']
    date = request.form['date']
    price = request.form['price']
    location = request.form['location']
    start_time = request.form['start_time']
    end_time = request.form['end_time']

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # dictionary=True for column names

    query = """
        INSERT INTO events (title, event_date, ticket_price, location, start_time, end_time,user_id)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    values = (title, date, price, location, start_time, end_time,user_id)

    cursor.execute(query, values)
    conn.commit()

    conn.close()
    # flash('Event added successfully!')
    return redirect(url_for('admin_event_form'))

# @app.route('/events-concert', methods=['GET'])
# def event_concert():
#     return render_template('event-concert.html')



@app.route('/edit/<int:event_id>', methods=['GET', 'POST'])
def edit_event(event_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        name = request.form['name']
        date = request.form['date']
        price = request.form['price']
        location = request.form['location']

        query = "UPDATE events SET title=%s, event_date=%s, ticket_price=%s, location=%s WHERE id=%s"
        cursor.execute(query, (name, date, price, location, event_id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('admin_event_form'))

    # GET method - show data in form
    cursor.execute("SELECT * FROM events WHERE id = %s", (event_id,))
    event = cursor.fetchone()
    cursor.close()
    conn.close()

    return render_template('edit_event.html', event=event)

@app.route('/delete_event', methods=['POST'])
def delete_event():
    event_id = request.form['event_id']
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("DELETE FROM events WHERE id = %s", (event_id,))
        conn.commit()
        flash('Event deleted successfully!', 'success')
    except Exception as e:
        conn.rollback()
        flash(f'Error deleting event: {str(e)}', 'error')
    finally:
        cursor.close()

    return redirect(url_for('admin_event_form'))  # ya jahan list dikh rahi ho


@app.route('/book')
def book_ticket():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, title FROM events")
    events = cursor.fetchall()
    cursor.close()
    return render_template('book.html', events=events)



@app.route('/book_ticket', methods=['POST'])
def book_ticket_submit():
    user_id = session['user_id']
    name = request.form['name']
    email = request.form['email']
    event_id = request.form['event_id']
    num_tickets = int(request.form['num_tickets'])
    upi_id = request.form['upi_id']

    conn = get_connection()
    cursor = conn.cursor()
    # Event ka price nikalna
    cursor.execute("SELECT ticket_price FROM events WHERE id = %s", (event_id,))
    result = cursor.fetchone()
    if result:
        price_per_ticket = Decimal(result[0])
        total_price = price_per_ticket * Decimal(num_tickets)
    else:
        total_price = 0

    query = """
        INSERT INTO ticket_bookings 
        (event_id, user_id, name, email, num_tickets, upi_id, status, ticket_price)
        VALUES (%s, %s, %s , %s, %s, %s, %s, %s)
    """
    data = (event_id, user_id, name, email , num_tickets, upi_id, 'Pending', total_price)
    cursor.execute(query, data)
    conn.commit()
    cursor.close()

    return "Ticket booked successfully! You'll get confirmation soon."




@app.route('/admin/booking_listing')
def admin_bookings():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            b.id AS booking_id,
            b.name AS user_name,
            e.title AS event_title,
            b.num_tickets,
            b.booking_time,
            b.status,
            b.ticket_price
        FROM ticket_bookings b
        JOIN events e ON b.event_id = e.id
        ORDER BY b.booking_time DESC
    """)
    bookings = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("admin-bookings.html", bookings=bookings)


@app.route('/event_anniversary', methods=['GET'])
def event_anniversary():
    return render_template("event-anniversary.html")

@app.route('/event_birthday', methods=['GET'])
def event_birthday():
    return render_template("event-birthday.html")

@app.route('/event_concern', methods=['GET'])
def event_concern():
    return render_template("event-concert.html")

if __name__ == '__main__':
    app.run(debug=True)
