"""
Send Google Cloud credit codes to email addresses. 

The script takes a csv file to pull the emails and codes from and a
username/password combination for an email to send the codes from.

The CSV file should be of the form:

```
name,uid,code
Paul,pl2648,ABCD-1234-ABCD-1234
```
"""

import csv
from email.mime.text import MIMEText
import smtplib
from time import sleep


HOST = 'smtp.gmail.com'
PORT = 465

MSG = """
Hi {name}! Looks like you've been given some Google Cloud credit.
Please review the following guides and setup a VM with your given code.

VM Creation Guide: https://goo.gl/DfMx3w
VM Configuration Guide: https://goo.gl/nAc5Sm

Your code is: {credit_code}
"""


def get_message(from_, data):
    text = MSG.format(name=data['name'], credit_code=data['code'])
    msg = MIMEText(text)
    msg['Subject'] = 'Your Google Cloud Credit Code'
    msg['From'] = from_
    msg['To'] = data['email']
    return msg


def get_student_data(file_name):
    with open(file_name) as fp:
        reader = csv.DictReader(fp)
        data = [
            {
                'name': d['name'].strip(),
                'email': d['uid'].strip() + '@columbia.edu',
                'code': d['code'].strip()
            }
            for d in reader
        ]
        return filter(lambda d: all(d.values()), data)


def send_emails(file_name, username, password):

    student_data = get_student_data(file_name)

    s = smtplib.SMTP_SSL(HOST, PORT)
    s.ehlo()
    s.login(username, password)

    print('Sending emails to ...')

    for i, data in enumerate(student_data, start=1):
        print(f'{i}. ', data['email'])
        msg = get_message(username, data)
        s.send_message(msg, from_addr=username)
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

