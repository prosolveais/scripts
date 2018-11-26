
import requests
import re
import sys
import html
import json
from urllib import parse

USERNAME='<username>'
PASSWORD='<password>'
URL='<domjudge url>'

def login(sess):

    """ Return True for successful auth, otherwise False """

    login_url = 'https://{}/login'.format(URL)
    data = sess.get(login_url)
    _csrf_token = re.findall(r'_csrf_token" value="(.*?)"', data.text)[0]
    _post_data = '_csrf_token={}&_username={}&_password={}'.format(_csrf_token, USERNAME, PASSWORD)
    _post_data = dict(parse.parse_qsl(_post_data))
    p = sess.post(login_url, data=_post_data, allow_redirects=False)
    return not login_url in p.text


def get_all_submissions(sess):

    url = 'https://{}/jury/submissions.php?view%5B3%5D=all'.format(URL)

    def slice_text(s, first, last):
        s = s.split(first)
        s = s[1].split(last)
        return s[0]

    data = sess.get(url)
    data = slice_text(data.text, '<tbody>', '</tbody>').split('\n')

    re_submit_data = re.compile(r'<a href="submission\.php\?id=\d+">(.*?)<\/a>')
    re_correctness = re.compile(r'<span.*>(.*?)<\/span>')
    re_id          = re.compile(r'submission\.php\?id=(\d+)')

    def get_source(id):
        src_url  = "https://{}/jury/show_source.php?id={}".format(URL, id)
        src_html = sess.get(src_url)
        code     = slice_text(src_html.text, 'id="editor0">', '</div>')
        return html.unescape(code)

    all_submissions = []
    for i, each in enumerate(data):

        print ("Fetching {}/{} submission...".format(i, len(data)))

        if each:
            parse_data = re_submit_data.findall(each)
            submit_id    = re_id.findall(each)[0]
            team_name    = parse_data[2]
            time_submit  = parse_data[1]
            problem_code = parse_data[3]
            language     = parse_data[4]
            correctness  = re_correctness.findall(parse_data[5])[0]
            code         = get_source(submit_id)

            submission = {}
            submission['Submit ID'] = submit_id
            submission['Team Name'] = team_name
            submission['Time Submit'] = time_submit
            submission['Problem Code'] = problem_code
            submission['Language'] = language
            submission['Correctness'] = correctness
            submission['Source Code'] = code
            all_submissions.append(submission)
        
    with open('submission-data.json', 'w') as f:
        json.dump(all_submissions, f, sort_keys=True, indent=4)


def main():

    sess = requests.Session()

    if not login(sess):
        print("Authentication failed!")
        sys.exit(1)

    get_all_submissions(sess)

    

if __name__ == '__main__':
    main()