1. Mengambil Customer Name dengan Sales tertinggi
```bash 
awk -F, '{print $17, $6}' sandbox.csv | sort -nr | head -n 1
```
```bash
awk
```
Ini seperti alat yang bisa membaca dan mengolah file teks baris demi baris.
```bash
-F,
```
Ini bilang kepada awk untuk memisahkan setiap baris menjadi beberapa bagian berdasarkan tanda koma (,).
```bash
'{print $17, $6}': 
```
Ini memberi tahu awk untuk mencetak kolom ke-17 dan ke-6 dari setiap baris.
```bash
sandbox.csv
```
Ini nama file yang awk akan baca.
```bash
|
```
Ini seperti pipa yang menghubungkan output dari perintah sebelumnya ke perintah berikutnya.
```bash
sort -nr
```
```bash
sort
```
Ini perintah yang mengurutkan baris teks.
```bash
-n
```
Ini bilang kepada sort untuk mengurutkan dalam urutan angka.
```bash
-r
```
Ini bilang kepada sort untuk mengurutkan dalam urutan terbalik, jadi yang paling besar menjadi yang pertama.
```bash
|
``` 
Lagi pipa yang menghubungkan output dari sort -nr ke perintah berikutnya.
```bash
head -n 1
```
```bash
head
``` 
Ini perintah yang mencetak bagian pertama dari file.
```bash
-n 1
```
Ini bilang kepada head untuk mencetak hanya satu baris.