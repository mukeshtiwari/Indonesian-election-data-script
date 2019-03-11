(import urllib2 json csv sys os ssl)


; Fetch the json data from given url
(defn fetch-url [url]
   (->>
       (.urlopen urllib2 url)
       (.load json)))

; Write json-data into file-name. If file exists, then
; don't write the header again, otherwise write it.
; If json-data is empty, then just return the file without
; writing anything
(defn write-csv [json-data file-name]
   (setv file-exists (.exists os.path file-name))
   (if (not json-data)
       file-name
       (with [outf (open file-name "a+")]
         (do
           (setv dw (.DictWriter csv outf (.keys (get json-data 0))))
           (if (not file-exists)
               (.writeheader dw))
           (for [row json-data]
             (.writerow dw row))))))

; Construct urls based on national-level, state-level. 
; The challenge was finding the page number for which you want to access the 
; data. It seems that they were numbered randomly which made life very difficult, otherwise
; we don't need the page number because we can always run a loop from beginning of page-number to end of page-number
(defn construct-url [file-name n-level s-level p-number]
   (setv url (+ "https://infopemilu.kpu.go.id/pileg2019/pencalonan/pengajuan-calon/" (str n-level) "/" (str s-level) "/dcs?_=" (str p-number)))
   (-> (fetch-url url)
       (write-csv file-name)))

;(write-csv (fetch-url "https://infopemilu.kpu.go.id/pileg2019/pencalonan/pengajuan-calon/1/1/dcs?_=2") "abc.csv")
;(construct-url "abc.csv" 1 1 1)
; hy fetch.hy file-name 1 1 1
(defmain [&rest args]
   (construct-url (get args 1) 
                  (get args 2)
                  (get args 3)
                  (get args 4)))
