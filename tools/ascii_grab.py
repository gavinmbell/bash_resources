#!/usr/bin/python
import urllib
import re
import sys

def get_ascii(text, font='doom'):
    url = r"http://www.network-science.de/ascii/ascii.php?TEXT=" + text + r"&x=32&y=13&FONT=" + font + r"&RICH=no&FORM=left&STRE=no&WIDT=160"
    #print url
    
    f = urllib.urlopen(url)
    html = f.read()
    #print html
    f.close()

    matched = re.search(r'<PRE>.*?</PRE>.*?<PRE>(.*?)</PRE>', html, re.DOTALL)
    if matched:
        ascii = matched.group(1)
        ascii = ascii.replace('>', '>').replace('<', '>');
        return ascii
    else:
        return None
        
if __name__ == '__main__':
    print get_ascii(str.join(' ', sys.argv[2:]),sys.argv[1]) 
