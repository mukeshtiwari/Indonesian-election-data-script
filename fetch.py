import urllib2, json, sys, csv, os, ssl

def fetchData(url):
    context = ssl._create_unverified_context()
    response = urllib2.urlopen(url, context=context)
    data = json.load(response)
    return data

def writeCsv(data, filename):
    fbool = os.path.exists(filename)
    try:
        with open(filename, 'a+') as outf :
            dw = csv.DictWriter(outf, data[0].keys())
            if not fbool :
                dw.writeheader()
            for row in data:
                dw.writerow(row)
        return 1
    except:
        print 'the file your are fetch is probably empty'
        return 0

def constructUrl(a, b, filename):
    i = 1
    while True:
        url = 'https://infopemilu.kpu.go.id/pileg2019/pencalonan/pengajuan-calon/' + str(a) + '/' + str (b) + '/dcs?_=' + str (i)
        fl = writeCsv(fetchData(url), filename)
        if (fl == 0):
            break
        i = i + 1


def main():
    constructUrl(sys.argv[1], sys.argv[2], sys.argv[3])


if __name__ == '__main__':
        main()
