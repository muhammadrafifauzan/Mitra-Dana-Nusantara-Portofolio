-- ============================================================
--  BANK MITRA DANA NUSANTARA (MDN)
--  Script Pembuatan Database & Import Data
--  Versi : 1.0  |  Program BA Learning Path
-- ============================================================
-- Cara jalankan (SQLite):
--   sqlite3 mdn_bank.db < 01_create_database.sql
-- ============================================================

DROP TABLE IF EXISTS transaksi;
DROP TABLE IF EXISTS kredit;
DROP TABLE IF EXISTS rekening;
DROP TABLE IF EXISTS kpi_cabang;
DROP TABLE IF EXISTS karyawan;
DROP TABLE IF EXISTS nasabah;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS cabang;

CREATE TABLE cabang (
    kode_cabang   VARCHAR(10) PRIMARY KEY,
    nama_cabang   VARCHAR(100),
    kota          VARCHAR(50),
    provinsi      VARCHAR(50),
    kepala_cabang VARCHAR(100),
    tanggal_buka  DATE
);

CREATE TABLE produk (
    kode_produk    VARCHAR(10) PRIMARY KEY,
    nama_produk    VARCHAR(100),
    kategori       VARCHAR(30),
    suku_bunga_pct DECIMAL(5,2),
    biaya          VARCHAR(100),
    minimum_dana   BIGINT,
    keterangan     TEXT
);

CREATE TABLE nasabah (
    id_nasabah          VARCHAR(10) PRIMARY KEY,
    nama_lengkap        VARCHAR(100),
    jenis_kelamin       VARCHAR(15),
    tanggal_lahir       DATE,
    usia                INT,
    nik                 VARCHAR(20) UNIQUE,
    alamat              TEXT,
    kota                VARCHAR(50),
    provinsi            VARCHAR(50),
    email               VARCHAR(100),
    no_telepon          VARCHAR(20),
    pekerjaan           VARCHAR(50),
    penghasilan_bulanan BIGINT,
    pendidikan          VARCHAR(10),
    status_pernikahan   VARCHAR(15),
    tanggal_daftar      DATE,
    kode_cabang         VARCHAR(10),
    segmen_nasabah      VARCHAR(20),
    skor_kredit         INT
);

CREATE TABLE rekening (
    id_rekening     VARCHAR(12) PRIMARY KEY,
    nomor_rekening  VARCHAR(20) UNIQUE,
    id_nasabah      VARCHAR(10),
    nama_nasabah    VARCHAR(100),
    kode_produk     VARCHAR(10),
    tanggal_buka    DATE,
    saldo           BIGINT,
    status_rekening VARCHAR(15),
    tanggal_tutup   DATE,
    kode_cabang     VARCHAR(10)
);

CREATE TABLE transaksi (
    id_transaksi    VARCHAR(12) PRIMARY KEY,
    nomor_rekening  VARCHAR(20),
    id_nasabah      VARCHAR(10),
    nama_nasabah    VARCHAR(100),
    jenis_transaksi VARCHAR(50),
    debit_kredit    VARCHAR(7),
    nominal         BIGINT,
    tanggal         DATE,
    jam             TEXT,
    channel         VARCHAR(30),
    status          VARCHAR(15),
    flag_fraud      VARCHAR(5),
    keterangan      TEXT,
    kode_cabang     VARCHAR(10)
);

CREATE TABLE kredit (
    id_kredit            VARCHAR(10) PRIMARY KEY,
    id_nasabah           VARCHAR(10),
    nama_nasabah         VARCHAR(100),
    kode_produk          VARCHAR(10),
    jenis_kredit         VARCHAR(30),
    plafon               BIGINT,
    tenor_bulan          VARCHAR(10),
    suku_bunga_pct       DECIMAL(5,2),
    tanggal_mulai        DATE,
    tanggal_jatuh_tempo  DATE,
    sisa_pokok           BIGINT,
    angsuran_per_bulan   BIGINT,
    bucket_dpd           INT,
    kolektibilitas       VARCHAR(20),
    jenis_agunan         VARCHAR(50),
    skor_kredit          INT,
    kode_cabang          VARCHAR(10)
);

CREATE TABLE kpi_cabang (
    kode_cabang        VARCHAR(10),
    nama_cabang        VARCHAR(100),
    tahun              INT,
    bulan              INT,
    dana_pihak_ketiga  BIGINT,
    kredit_outstanding BIGINT,
    npl_pct            DECIMAL(5,2),
    fee_based_income   BIGINT,
    nasabah_baru       INT,
    target_dpk         BIGINT,
    pencapaian_pct     DECIMAL(6,2),
    PRIMARY KEY (kode_cabang, tahun, bulan)
);

CREATE TABLE karyawan (
    id_karyawan     VARCHAR(10) PRIMARY KEY,
    nama_lengkap    VARCHAR(100),
    jenis_kelamin   VARCHAR(15),
    tanggal_lahir   DATE,
    jabatan         VARCHAR(50),
    divisi          VARCHAR(50),
    kode_cabang     VARCHAR(10),
    tanggal_masuk   DATE,
    gaji_pokok      BIGINT,
    status_karyawan VARCHAR(15)
);

CREATE INDEX IF NOT EXISTS idx_trx_tanggal   ON transaksi(tanggal);
CREATE INDEX IF NOT EXISTS idx_trx_nasabah   ON transaksi(id_nasabah);
CREATE INDEX IF NOT EXISTS idx_trx_fraud     ON transaksi(flag_fraud);
CREATE INDEX IF NOT EXISTS idx_kredit_kol    ON kredit(kolektibilitas);
CREATE INDEX IF NOT EXISTS idx_nsb_segmen    ON nasabah(segmen_nasabah);

SELECT 'Schema MDN Bank berhasil dibuat!' AS status;
