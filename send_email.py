"""
Send Google Cloud credit codes to email addresses. 

The script takes a csv file to pull the emails and codes from and a
username/password combination for an email to send the codes from.

The CSV file should be of the form:

```
email,code
<email>,ABCD-1234-ABCD-1234
```
"""

import csv
from email.mime.text import MIMEText
import smtplib
from time import sleep


HOST = 'smtp.gmail.com'
PORT = 465


def get_message(from_, email, credit_code):
    text = f'Your code is: {credit_code}'
    msg = MIMEText(text)
    msg['Subject'] = 'Your Google Cloud Credit Code'
    msg['From'] = from_
    msg['To'] = email
    return msg


def get_student_data(file_name):
    with open(file_name) as fp:
        reader = csv.DictReader(fp)
        data = [(d['email'].strip(), d['code'].strip()) for d in reader]
        return filter(lambda tup: all(tup), data)


def send_emails(file_name, username, password):

    student_data = get_student_data(file_name)

    s = smtplib.SMTP_SSL(HOST, PORT)
    s.ehlo()
    s.login(username, password)

    print('Sending emails to ...')

    for i, data in enumerate(student_data, start=1):
        print(f'{i}. ', data[0])
        msg = get_message(username, *data)
        s.send_message(msg, from_addr=FROM)
        sleep(2)  # Avoid Google from shutting us down

    s.quit()


if __name__ == '__main__':
    import argparse
    import getpass
    import sys

    parser = argparse.ArgumentParser('Code Sender')
    parser.add_argument('file_name')
    parser.add_argument('username')
    args = parser.parse_args()

    password = getpass.getpass().strip()
    if not password:
        print('Password required')
        sys.exit(1)

    send_emails(args.file_name, args.username, password)

