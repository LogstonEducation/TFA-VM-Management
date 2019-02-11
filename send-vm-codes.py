import csv
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
import time
import random


SMTP_ADDRESS = 'smtp.gmail.com'
SMTP_PORT = '587'

SUBJECT_TEMPLATE = "Hi {uni}! Here's your server code..."
MESSAGE_TEMPLATE = """
Hello!

You've been issued a server code for use use with the Tools For Analytics
course. Please use the code below to create and configure a Virtual Machine (VM)
for this course.

Server Code: {code}

VM Creation Guide: https://goo.gl/DfMx3w
VM Configuration Guide: https://goo.gl/nAc5Sm

Best,
Paul
""".strip()


def send_message(sender_uni, smtp_server, recipient, subject, message):
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = f'{sender_uni}@columbia.edu' 
    msg['To'] = recipient

    # Add two spaces to end of message because it seems to get truncated.
    # I don't know why.
    msg.attach(MIMEText(message + '  '))

    smtp_server.send_message(msg)


def send_messages(sender_uni, sender_password, data):
    smtp_server = smtplib.SMTP(SMTP_ADDRESS, SMTP_PORT)
    smtp_server.starttls()
    smtp_username = f'{sender_uni}@columbia.edu'
    smtp_server.login(smtp_username, sender_password)

    for i, row in enumerate(data):
        email = row['uni'] + '@columbia.edu'
        print(f'{i}.'.rjust(5), f'Emailing {email}')
        subject = SUBJECT_TEMPLATE.format(uni=row['uni'])
        message = MESSAGE_TEMPLATE.format(code=row['code'])

        send_message(sender_uni, smtp_server, email, subject, message)

        # Sleep for random amount to throw google off our scent
        time.sleep(random.randint(1, 10))  

    smtp_server.quit()
    print('All Done.')


def main():
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('sender_uni')
    parser.add_argument('sender_password',
                        help='Use an app password from google')
    parser.add_argument('code_file_path')

    args = parser.parse_args()

    with open(args.code_file_path) as fp:
        data = list(csv.DictReader(fp))

    assert 'uni' in data[0], 'Could not find "uni" in headers of csv'
    assert 'code' in data[0], 'Could not find "code" in headers of csv'

    send_messages(args.sender_uni, args.sender_password, data)


main()

