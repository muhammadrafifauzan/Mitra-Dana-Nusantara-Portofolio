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
│
├── sql/
│   ├── 01_create_database.sql       # DDL: pembuatan schema & tabel
│   └── Query_SQL_Analyst.sql        # Query analitik per tahap
│
├── python/
│   └── mdn_bank_project_portofolio.py  # Script Google Colab (cleaning + viz + report)
│
├── analisa/
│   └── Analisa_Business_MDN_Bank/   # Hasil output query (18 analisis)
│
└── README.md
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

### 3. Executive Report Otomatis
```
┌──────────────────────────────────────────────────────────┐
│         RINGKASAN KINERJA BANK MDN — H1 2024             │
├──────────────────────────┬───────────────────────────────┤
│  Dana Pihak Ketiga       │  Rp X.XX Triliun              │
│  LDR                     │  XX.X%  ✅ Sehat              │
│  NPL Gross               │  X.XX%  ✅ AMAN               │
└──────────────────────────┴───────────────────────────────┘
```
Lengkap dengan **temuan utama (So What?)** dan **rekomendasi aksi (Now What?)**.

**Cara menjalankan:**

1. Buka [Google Colab](https://colab.research.google.com/)
2. Upload file `mdn_bank_project_portofolio.py`
3. Upload semua file CSV dari folder `dataset/`
4. Jalankan sel secara berurutan

---

## 📋 Indikator Kesehatan Bank (Referensi)

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

## 🛠️ Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10-blue?style=flat&logo=python&logoColor=white)
![Google Colab](https://img.shields.io/badge/Google%20Colab-F9AB00?style=flat&logo=googlecolab&logoColor=white)
![Claude AI](https://img.shields.io/badge/Claude%20AI-Anthropic-orange?style=flat)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![Matplotlib](https://img.shields.io/badge/Matplotlib-11557C?style=flat)

---

## ⚠️ Disclaimer

Dataset yang digunakan dalam proyek ini sepenuhnya **fiktif** dan dibuat untuk keperluan pembelajaran. Tidak merepresentasikan data nasabah, karyawan, atau operasional bank manapun yang nyata.

---

## 📬 Kontak

Proyek ini bagian dari **BA Learning Path — Perbankan**.  
Kontribusi, saran, dan diskusi sangat disambut! 🙌
