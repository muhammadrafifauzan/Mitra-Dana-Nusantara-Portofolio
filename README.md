# 🏦 Bank MDN — Business Analyst Learning Path Portfolio

> Proyek simulasi end-to-end Business Analyst di industri perbankan menggunakan data fiktif **Bank Mitra Dana Nusantara (MDN)**. Dataset, query SQL, dan script Python dibuat dengan bantuan **Claude AI** (Anthropic).

---

## 📌 Deskripsi Proyek

Proyek ini merupakan portofolio pembelajaran **Business Analyst (BA) di bidang perbankan**, yang mencakup:

- Pemahaman fondasi bisnis perbankan (produk, segmen, indikator kesehatan bank)
- Eksplorasi & analisis data menggunakan **SQL (PostgreSQL)**
- Visualisasi & pelaporan eksekutif menggunakan **Python (Google Colab)**

Seluruh dataset bersifat **fiktif dan dibuat untuk tujuan edukasi**.

---

## 🤖 Peran Claude AI dalam Proyek Ini

| Komponen | Peran Claude AI |
|---|---|
| **Dataset CSV** | Pembuatan data sintetis 8 tabel (nasabah, transaksi, kredit, dll.) yang realistis dan konsisten antar tabel |
| **Query SQL** | Pembuatan query analitik mulai dari SELECT dasar, JOIN, HAVING, hingga Window Function & CTE |
| **Script Python** | Pembuatan pipeline data cleaning, visualisasi executive dashboard, dan executive report otomatis |

---

## 🗂️ Struktur Repositori

```
bank-mdn-portfolio/
├── sql/
│   ├── 01_create_database.sql           # DDL: pembuatan schema & tabel
│   ├─  Query_SQL_Analyst.sql            # Query analitik per tahap
│   └── Analisa Business MDN Bank.zip    # # Hasil output query (18 analisis)
│
└── README.md
│
├── python/
│   ├─  bank_mdn_results.zip            # Hasil output script python 
│   └── mdn_bank_project_portofolio.py  # Script Google Colab (cleaning + viz + report)
│
├── dataset/
│   ├── cabang.csv
│   ├── produk.csv
│   ├── nasabah.csv
│   ├── rekening.csv
│   ├── kredit.csv
│   ├── kpi_cabang.csv
│   ├── karyawan.csv
│   └── transaksi.csv

```

---

## 🗄️ Database — PostgreSQL

Database dibangun menggunakan **PostgreSQL** dengan schema `mdn_bank`, terdiri dari **8 tabel relasional**:

| Tabel | Deskripsi | Jumlah Kolom |
|---|---|---|
| `cabang` | Data cabang bank di seluruh Indonesia | 6 |
| `produk` | 12 produk perbankan (tabungan, deposito, kredit) | 7 |
| `nasabah` | Profil nasabah dengan segmentasi (Reguler/Prioritas/Premier) | 19 |
| `rekening` | Data rekening aktif, dormant, dan tutup | 10 |
| `transaksi` | Log transaksi harian dengan flag fraud | 14 |
| `kredit` | Portfolio kredit dengan kolektibilitas & DPD | 17 |
| `kpi_cabang` | KPI bulanan per cabang (DPK, LDR, NPL) | 11 |
| `karyawan` | Data SDM per cabang | 10 |

**Cara import ke PostgreSQL:**

```sql
-- Buat database terlebih dahulu
CREATE DATABASE mdn_bank;

-- Jalankan script DDL
\i sql/01_create_database.sql

-- Import CSV menggunakan COPY atau pgAdmin Import Tool
COPY mdn_bank.nasabah FROM '/path/to/nasabah.csv' DELIMITER ',' CSV HEADER;
-- (ulangi untuk setiap tabel)
```

> **Catatan:** Script DDL awalnya dibuat untuk SQLite. Untuk PostgreSQL, pastikan tipe data `DECIMAL` dan `BIGINT` sudah sesuai, dan ganti `TEXT` menjadi `VARCHAR` jika diperlukan.

---

## 📊 Query SQL — Tahapan Analisis

Query disusun bertahap sesuai learning path BA:

### Tahap 1 — Eksplorasi Data Dasar
- `SELECT` & kolom pilihan untuk laporan manajemen
- Distribusi segmen nasabah
- Statistik rekening aktif
- Klasifikasi saldo dengan `CASE WHEN`

### Tahap 2 — Filtering & Business Cases
- ⚠️ Kredit bermasalah (NPL) — laporan urgent direksi
- 🔍 Transaksi mencurigakan (Fraud/AML)
- 🎯 Target cross-selling KPR nasabah Premier
- 💤 Rekening dormant dengan saldo
- 📱 Performa channel digital dengan `HAVING`

### Tahap 3 — JOIN Multi-Tabel
- Profil lengkap debitur (nasabah + kredit + cabang)
- Nasabah tanpa rekening aktif (potential churn)
- Volume transaksi per cabang per produk
- Top 10 nasabah untuk program loyalitas

### Tahap 4 — Aggregasi & Window Function
- Tren bulanan DPK & LDR untuk ALCO Report
- Ranking cabang menggunakan `RANK() OVER`
- NPL heatmap per cabang
- **RFM Segmentation** dengan CTE (Champions, Loyal, Potential, At Risk)

---

## 🐍 Python — Google Colab

Script Python dirancang untuk dijalankan di **Google Colab** dan mencakup:

### 1. Data Loading & Cleaning
```python
# Upload CSV dari lokal ke Colab
from google.colab import files
uploaded = files.upload()

# Pipeline cleaning otomatis
def clean_dataframe(df):
    # Standardisasi nama kolom
    # Hapus duplikasi
    # Handle missing values
    # Konversi kolom tanggal
```

### 2. Executive Dashboard (Matplotlib & Seaborn)
6 visualisasi dalam satu figure:
- 🍩 Distribusi segmen nasabah (pie chart)
- 📈 Tren DPK per bulan 2024 (line chart)
- 📊 NPL Rate per jenis kredit (bar chart)
- 📉 Distribusi saldo rekening aktif (histogram)
- 🏆 Top 8 cabang berdasarkan DPK (bar chart)
- 📱 Volume transaksi per channel (bar chart)

## Berikut hasil aktual dari dataset MDN Bank:
KPI Utama H1 2024:

DPK: Rp 25,53 Triliun (97,5% dari target Rp 26,19 T — belum capai)
LDR: 71,8% — di bawah range ideal 78–92%
NPL Gross: 18,07% — ini yang paling kritis, jauh melampaui threshold OJK 5%
Fee-Based Income: Rp 52,5 Miliar
Nasabah baru H1: 7.380

Catatan penting soal NPL: Angka 18,07% sangat tinggi karena dari 250 debitur, ada 60 debitur masuk kolektibilitas bermasalah (Kurang Lancar 26 + Diragukan 19 + Macet 15). Semua jenis kredit melampaui threshold — KKB paling parah di 29,78%, diikuti KUR 23,87%. Cabang Medan Gatsu dan Bandung Buah Batu jadi cabang dengan NPL tertinggi (>47%).
└──────────────────────────┴───────────────────────────────┘
```

Cara menjalankan:

1. Buka [Google Colab](https://colab.research.google.com/)
2. Upload file `mdn_bank_project_portofolio.py`
3. Upload semua file CSV dari folder `dataset/`
4. Jalankan sel secara berurutan

---

📋 Indikator Kesehatan Bank (Referensi)

| Indikator | Nilai Ideal | Keterangan |
|---|---|---|
| CAR | ≥ 8% | Kecukupan modal |
| NPL | ≤ 5% | Kredit bermasalah |
| LDR | 78–92% | Loan-to-Deposit Ratio |
| BOPO | ≤ 85% | Efisiensi operasional |
| NIM | ≥ 3% | Net Interest Margin |
| ROA | ≥ 0.5% | Return on Assets |
| ROE | ≥ 10% | Return on Equity |


---

⚠️ Disclaimer

Dataset yang digunakan dalam proyek ini sepenuhnya **fiktif** dan dibuat untuk keperluan pembelajaran. Tidak merepresentasikan data nasabah, karyawan, atau operasional bank manapun yang nyata.

---

📬 Kontak

Proyek ini bagian dari **BA Learning Path — Perbankan**.  
Kontribusi, saran, dan diskusi sangat disambut! 🙌

📜 Lisensi

Proyek ini bersifat open portfolio. Bebas digunakan sebagai referensi belajar. Mohon cantumkan credit jika digunakan ulang.

---

⭐ Jika proyek ini menginspirasi, silakan beri bintang!

Last updated: June 2026 · Disusun oleh: Muhammad Rafi Fauzan
