# Penjelasan Sandbox.sh

## Pengaturan Awal

Menyimpan URL untuk file CSV yang ingin diunduh didalam variable `CSV_URL`

```bash
# Define CSV URL
CSV_URL='https://drive.usercontent.google.com/u/0/uc?id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0&export=download'
```

## Mengunduh File CSV

Langkah pertama adalah mengunduh file CSV dari Google Drive menggunakan perintah `curl`.

```bash
# Download the CSV file from Google Drive
echo "=== Downloading CSV from Google Drive ==="
curl -L -o sandbox.csv "$CSV_URL"
```

Dalam perintah `curl` ini:
- `-L` digunakan untuk mengikuti redirect kalau ada.
- `-o sandbox.csv` menentukan nama file untuk menyimpan hasil unduhan.
- `"$CSV_URL"` adalah URL dari file CSV yang telah kita buat sebelumnya.

## Memeriksa Status Unduhan

Kemudian, script memeriksa apakah download tadi berhasil atau gagal.

```bash
# Check if the download was successful
echo "=== Checking download status ==="
if [ $? -ne 0 ]; then
  echo "=== Failed to download the CSV file from $CSV_URL. Exiting. ==="
  exit 1
fi
echo "=== Download successful ==="
printf "\n"
```

Dalam blok `if` ini:
- ` $?` digunakan untuk mengecek status keluaran dari perintah sebelumnya (dalam hal ini, `curl`). Jika nilai tidak sama (`-ne`) dengan `0`, itu berarti unduhan gagal.

### Pelanggan dengan Penjualan Terbanyak

```bash
# Customer with the Most Sales
echo "=== Customer with the Most Sales ==="
awk -F, '{print $17, $6}' sandbox.csv | sort -nr | head -n 1 | awk '{print $2, $3}'
echo -e "\n"
```

Dalam bagian ini:
- `awk -F, '{print $17, $6}' sandbox.csv` digunakan untuk memilih kolom 17 (Sales) dan kolom 6 (Customer Name).
- `sort -nr` digunakan untuk mengurutkan hasil secara numerik secara terbalik (dari yang terbesar ke yang terkecil).
- `head -n 1` digunakan untuk mendapatkan baris pertama (yaitu yang memiliki penjualan terbanyak).
- `awk '{print $2, $3}'` digunakan untuk mencetak first name (`$2`) dan last name (`$3`) dari Customer Name. 

### Pelanggan dengan Profit Terkecil dan Terbesar

```bash
# Customer with the Least Profit
echo "=== Customer with the Least Profit ==="
awk -F, '{print $20, $6}' sandbox.csv | sort | head -n 1 | awk '{print $2, $3}'
echo -e "\n"

# Customer with the Most Profit
echo "=== Customer with the Most Profit ==="
awk -F, '{print $20, $6}' sandbox.csv | sort -nr | head -n 1 | awk '{print $2, $3}'
echo -e "\n"
```

Kedua bagian ini hampir sama dengan bagian sebelumnya, tapi kali ini kolom yang dipilih adalah kolom ke-20 (Profit).


### Kategori dengan Total Profit Tertinggi

```bash
# Categories with Most Total Profit
echo "=== Categories with Most Total Profit ==="
awk -F, '{profit[$14] += $20} END {for (category in profit) print "Profit:", profit[category],"| Category:", category}' sandbox.csv | sort -nr | head -n 3
awk -F, '{profit[$14] += $20} END {for (category in profit) print profit[category], category}' sandbox.csv | sort -nr | head -n 3
echo -e "\n"
```


1. `awk -F, '{profit[$14] += $20} END {for (category in profit) print "Profit:", profit[category],"| Category:", category}' sandbox.csv`
   - `awk` digunakan untuk memanipulasi dan mencetak data berdasarkan aturan yang ditentukan.
   - `-F,` digunakan untuk menentukan pemisah kolom, di sini kita menggunakan koma (,) karena file CSV dipisahkan oleh koma.
   - `'{profit[$14] += $20}` digunakan untuk menghitung total profit untuk setiap kategori (kolom ke-14) dengan menambahkan nilai profit setiap baris.
   - `END {for (category in profit) print "Profit:", profit[category],"| Category:", category}` akan mencetak total profit dan nama kategori untuk setiap kategori yang tercatat dalam array `profit`.
   - `sandbox.csv` adalah nama file CSV yang digunakan sebagai input.

2. `sort -nr | head -n 3`
   - `sort -nr` digunakan untuk mengurutkan hasil secara numerik secara terbalik (dari yang tertinggi ke terendah).
   - `head -n 3` digunakan untuk mendapatkan tiga baris pertama dari hasil yang sudah diurutkan, yang akan memberikan tiga kategori dengan total profit tertinggi.




### Mendapatkan Tanggal Pesanan dan Jumlah untuk Pelanggan dengan Nama "Adriaens"

```bash
# Get Quantity and Order Date for Customer with "Adriaens"
echo "=== Getting Order Date and Quantity for Customer Named 'Adriaens' ==="
awk -F, '$6 ~ /Adriaens/ {print "Order Date: ", $2}' sandbox.csv
awk -F, '$6 ~ /Adriaens/ {print "Quantity: "$18}' sandbox.csv
echo -e "\n"
```

1. `awk -F, '$6 ~ /Adriaens/ {print "Order Date: ", $2}' sandbox.csv`
   - `awk` adalah perintah untuk memanipulasi dan mencetak data berdasarkan pola atau aturan yang ditentukan.
   - `-F,` mengatur pemisah kolom menjadi koma (,) karena file CSV biasanya pake koma sebagai pemisah
   - `'$6 ~ /Adriaens/` digunakan untuk memilih baris-baris yang nama pelanggannya (kolom ke-6) cocok dengan pola "Adriaens".
   - `{print "Order Date: ", $2}` mencetak tanggal pesanan (kolom ke-2) dari baris-baris yang dipilih sebelumnya.
   - `sandbox.csv` adalah nama file CSV yang digunakan sebagai input.

2. `awk -F, '$6 ~ /Adriaens/ {print "Quantity: "$18}' sandbox.csv`
   - Sama seperti sebelumnya, namun kali ini kita mencetak jumlah pesanan (kolom ke-18) dari baris-baris yang dipilih.
 