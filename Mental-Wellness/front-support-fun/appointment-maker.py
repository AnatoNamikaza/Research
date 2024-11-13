from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/make-appointment', methods=['GET', 'POST'])
def make_appointment():
    if request.method == 'POST':
        # Get the form data
        service = request.form['service']
        appointment_date = request.form['appointment_date']
        appointment_time = request.form['appointment_time']
        notes = request.form.get('notes', '')  # Optional notes

        # Store the appointment or process the data as needed
        # Example: save to database, send email, etc.

        return render_template('confirmation.html', service=service, appointment_date=appointment_date, appointment_time=appointment_time)

    return render_template('make-appointment.html')

if __name__ == "__main__":
    app.run(debug=True)
