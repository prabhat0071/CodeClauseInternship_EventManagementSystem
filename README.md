# 🎉 CodeClauseInternship_EventManagementSystem

This is a dynamic Event Management System developed as part of the **CodeClause Internship 2025**.  
The system allows users to explore upcoming events, book tickets, and view event details.  
Admins can manage events, attendees, and payment status using a dedicated admin panel.

## 🚀 Features

- 🗓️ Display of latest 3 events on homepage  
- 🔍 Full event details with image, date, location, and price  
- 🎫 Ticket booking system with form validation  
- 🧑‍💼 Admin panel for managing events, bookings, and attendees  
- 💾 Data stored in MySQL and handled through Flask backend  
- 📷 Image upload & display with dynamic URL generation

## 🛠️ Tech Stack

- **Frontend:** HTML, CSS, JavaScript  
- **Backend:** Python (Flask)  
- **Database:** MySQL  
- **Others:** Jinja2 templating, Bootstrap (optional)

## 📂 Folder Structure

project/
│
├── static/
│ └── image_web/ # Uploaded event images
│
├── templates/
│ ├── index.html
│ ├── login.html
│ ├── admin_dashboard.html
│ └── ... # All other HTML files
│
├── app.py # Main Flask application
├── database.sql # MySQL DB structure
└── README.md


<img width="1902" height="877" alt="image" src="https://github.com/user-attachments/assets/ef68c033-1934-4a81-be47-8fb30c96b4e2" />


<img width="1912" height="962" alt="image" src="https://github.com/user-attachments/assets/5b417eb0-5510-4458-83e4-58e735ee82e1" />


git clone https://github.com/prabhat0071/CodeClauseInternship_EventManagementSystem.git
cd CodeClauseInternship_EventManagementSystem

2. Install dependencies:

3. Package                Version
---------------------- -------
blinker                1.8.2
click                  8.1.7
colorama               0.4.6
Flask                  3.0.3
Flask-MySQLdb          2.0.0
greenlet               3.0.3
itsdangerous           2.2.0
Jinja2                 3.1.4
MarkupSafe             2.1.5
mysql-connector-python 9.4.0
mysqlclient            2.2.7
pdfkit                 1.0.0
pip                    24.1.2
playwright             1.44.0
pyee                   11.1.0
setuptools             70.3.0
typing_extensions      4.12.2
Werkzeug               3.0.3
wheel                  0.43.0

4. Import the `database.sql` file in your MySQL server.

5. Run the Flask app:

6.  Open browser and visit:

   http://localhost:5000

Developed during the **CodeClause Internship Program – July 2025**  
By **Prabhat Singh** ([@prabhat0071](https://github.com/prabhat0071))
