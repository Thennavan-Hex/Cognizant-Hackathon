import io
import os
import random
from flask import Flask, render_template,request, send_file, session
import gspread
import datetime
from oauth2client.service_account import ServiceAccountCredentials
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import qrcode


app = Flask(__name__)

app.secret_key="3280151"


# Gmail SMTP Configuration

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
GMAIL_USERNAME = "jeevasslj@gmail.com"  # Replace with your Gmail username
GMAIL_PASSWORD = "xuxb cxbv zawa rlsk"  # Replace with your Gmail password

# Authentication
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', scope)
gc = gspread.authorize(credentials)

# Open the Google Sheet
sheet = gc.open_by_key('1A6pf45KV23syGmeilUrIWc3e5lgHmtic4FfE4eDAjdw')  # Replace with your sheet's key
worksheet = sheet.get_worksheet(0)  # Select the first worksheet

@app.route('/' , methods=['POST','GET'])
def car():
   if request.method == 'POST':
      cn=session.get('cn')
      con=session.get('con')
      return render_template("main.html" ,cn=cn ,con=con)
   return render_template ("main.html" )
 
@app.route('/search', methods=['POST'])
def search():
   cn=request.form['cn']
   con=request.form['con']
   email=request.form['email']
   session['email']=email
   session['cn']=cn
   session['con']=con
   return render_template("search.html" ,carnum=cn ,caron=con)

@app.route('/search1' ,methods=['POST'])
def placesearch():
   search_term = request.form['search']
   cn=session.get('cn')
   con=session.get('con')
    # Iterate through all rows and find matches in any column
   all_rows = worksheet.get_all_values()
   results = []
   for row_index, row_data in enumerate(all_rows):
    if any(search_term.lower() in cell.lower() for cell in row_data):
        results.append(row_data)

   return render_template('search2.html', results=results,carnum=cn ,caron=con) 

@app.route('/select/<int:name>')
def select(name):
   place_value=name
   place_value = str(place_value)
   pname=worksheet.acell('A'+place_value).value
   
   amt=worksheet.acell('C'+place_value).value
   session['amt']=amt
   return render_template("parkdetail.html", parkname=pname,amt=amt)

@app.route('/pay', methods=['POST'])
def pay():
   amount_per_hour=session.get('amt')
   amount_per_hour=amount_per_hour[1:3]
   aph=int(amount_per_hour)
   fromdt=request.form['fromDate']
   fyear=fromdt[0:4]
   fiyear=int(fyear)
   fmonth=fromdt[5:7]
   fimonth=int(fmonth)
   fdate=fromdt[8:10]
   fidate=int(fdate)
   fhr=fromdt[11:13]
   fihr=int(fhr)
   fmin=fromdt[14:16]
   fimin=int(fmin)
   todt=request.form['toDate']
   tyear=todt[0:4]
   toyear=int(tyear)
   tmonth=todt[5:7]
   tomonth=int(tmonth)
   tdate=todt[8:10]
   todate=int(tdate)
   thr=todt[11:13]
   tohr=int(thr)
   tmin=todt[14:16]
   tomin=int(tmin)
   start_date_time = datetime.datetime(fiyear, fimonth, fidate, fihr, fimin, 0)
   end_date_time = datetime.datetime(toyear, tomonth, todate, tohr, tomin, 0)
   total_amount = calculate_amount(aph, start_date_time, end_date_time)
   total_amount=round(total_amount,2)
   cn=session.get('cn')
   con=session.get('con')
   session['from1']=start_date_time
   session['to']=end_date_time
   session['tamt']=total_amount
   return render_template("payment.html", from1=start_date_time,to=end_date_time,tamt=total_amount,cn=cn,con=con)
   
@app.route('/bill')
def bill():
   id=random.randint(11111111, 99999999)
   img=qr(id)
   cn=session.get('cn')
   con=session.get('con')
   from1=session.get('from1')
   to=session.get('to')
   tamt=session.get('tamt')
   mailname=session.get('name1')
   email=session.get('email')
   server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
   server.ehlo()
   server.starttls()
   server.login(GMAIL_USERNAME, GMAIL_PASSWORD)
   
   html = render_template("mail.html",img=img ,id=id,cn=cn,con=con,from1=from1,to=to,tamt=tamt)

   msg = MIMEMultipart()
   msg["From"] = "ParkCo"
   msg["To"] = email
   msg["Subject"] = "Confirmation Mail"
   msg.attach(MIMEText(html, "html"))
   print(email)
   server.sendmail(GMAIL_USERNAME, email, msg.as_string())
   server.close()
         
   
   server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
   server.ehlo()


   return render_template("bill.html",img=img ,id=id,cn=cn,con=con,from1=from1,to=to,tamt=tamt)

def calculate_amount(amount_per_hour, start_date_time, end_date_time):
    # Calculate the total duration in hours.
    duration = end_date_time - start_date_time
    total_hours = duration.total_seconds() / 3600

    # Calculate the total amount earned.
    
    total_amount = total_hours * amount_per_hour

    return total_amount


def qr(id):
    
    text = id

    if text:
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(text)
        qr.make(fit=True)

        img = qr.make_image(fill_color="black", back_color="white")

        img_io = io.BytesIO()
        img.save(img_io, format='PNG')
        img_io.seek(0)
        filename = '{}.png'.format(text)
        filepath = os.path.join('static/images/qr', filename)
        img.save(filepath)

        return send_file(img_io, mimetype='image/png')

    else:
        return 'Please provide the text to encode as a query parameter "text"'

   
   

if __name__ == '__main__':
    app.run(debug=True)