CREATE SCHEMA mdn_bank;

SELECT * FROM mdn_bank.cabang

SELECT * FROM mdn_bank.karyawan

SELECT * FROM mdn_bank.kpi_cabang

SELECT * FROM mdn_bank.kredit

SELECT * FROM mdn_bank.nasabah

SELECT * FROM mdn_bank.produk

SELECT * FROM mdn_bank.rekening

SELECT * FROM mdn_bank.transaksi


-- ============================================================
--  TAHAP 2 - SQL DASAR: SELECT & EKSPLORASI DATA
--  Bank Mitra Dana Nusantara (MDN)
-- ============================================================


--latihan 1 : Lihat 10 nasabah pertama
SELECT * FROM mdn_bank.nasabah LIMIT 10;

--latihan 2 : Pilih kolom penting untuk laporan manajemen
SELECT id_nasabah, nama_lengkap, segmen_nasabah, pekerjaan, penghasilan_bulanan, skor_kredit, kota
from mdn_bank.nasabah LIMIT 20;

--latihan 3 : Distribusi segmen nasabah
SELECT segmen_nasabah, 
		COUNT(*) AS jumlah_nasabah,
		ROUND(COUNT(*)*100/(SELECT COUNT (*) FROM mdn_bank.nasabah),2) AS persentase
		FROM mdn_bank.nasabah
		GROUP BY segmen_nasabah
		ORDER BY jumlah_nasabah DESC;
		
--latihan 4 : Statistik rekening aktif
SELECT COUNT (*) AS total_rekening,
		SUM(saldo) AS total_saldo,
		AVG(saldo) AS rata_rata_saldo,
		MAX(saldo) AS saldo_tertinggi,
		MIN(saldo) AS saldo_terendah
FROM mdn_bank.rekening WHERE status_rekening = 'Aktif';

-- latihan 5 : klasifikasi saldo (Case When)
SELECT nomor_rekening, nama_nasabah, saldo,
    CASE WHEN saldo >= 100000000 THEN 'WHALE (>100jt)'
         WHEN saldo >= 50000000  THEN 'HIGH (50-100jt)'
         WHEN saldo >= 10000000  THEN 'MEDIUM (10-50jt)'
         WHEN saldo >= 1000000   THEN 'LOW (1-10jt)'
         ELSE 'MICRO (<1jt)' END AS kategori_saldo,
    kode_produk
FROM mdn_bank.rekening WHERE status_rekening = 'Aktif'
ORDER BY saldo DESC LIMIT 30;
-- ============================================================
--  TAHAP 2 - SQL: FILTERING, WHERE, HAVING
-- ============================================================

-- KASUS 1: Kredit bermasalah (NPL) - laporan urgent direksi
SELECT id_kredit, nama_nasabah, jenis_kredit, plafon, sisa_pokok,
       kolektibilitas, bucket_dpd, jenis_agunan, kode_cabang
FROM mdn_bank.kredit
WHERE kolektibilitas IN ('Macet','Diragukan','Kurang Lancar')
ORDER BY sisa_pokok DESC;

-- KASUS 2: Transaksi mencurigakan (Fraud/AML)
SELECT id_transaksi, nama_nasabah, jenis_transaksi, nominal,
       tanggal, jam, channel, status
FROM mdn_bank.transaksi
WHERE flag_fraud = 'Ya' AND status = 'Berhasil' AND nominal > 5000000
ORDER BY nominal DESC, tanggal DESC;

-- KASUS 3: Target cross-selling KPR (Nasabah Premier skor kredit tinggi)
SELECT id_nasabah, nama_lengkap, pekerjaan, penghasilan_bulanan,
       skor_kredit, segmen_nasabah, kota, no_telepon
FROM mdn_bank.nasabah
WHERE segmen_nasabah = 'Premier' AND skor_kredit >= 700
  AND usia BETWEEN 28 AND 55 AND status_pernikahan = 'Menikah'
ORDER BY skor_kredit DESC, penghasilan_bulanan DESC;

-- KASUS 4: Rekening dormant dengan saldo
SELECT r.nomor_rekening, r.nama_nasabah, r.kode_produk,
       r.saldo, r.tanggal_buka, r.kode_cabang
FROM mdn_bank.rekening r
WHERE r.status_rekening = 'Dormant' AND r.saldo > 0
ORDER BY r.saldo DESC;

-- KASUS 5: Performa channel digital (HAVING)
SELECT channel,
       COUNT(*) AS jumlah,
       SUM(nominal) AS total_nilai,
       SUM(CASE WHEN status='Gagal' THEN 1 ELSE 0 END) AS gagal,
       ROUND(SUM(CASE WHEN status='Gagal' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS failure_rate
FROM mdn_bank.transaksi
WHERE tanggal BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY channel
HAVING COUNT(*) > 100
ORDER BY jumlah DESC;

-- ============================================================
--  TAHAP 2 - SQL: JOIN ANTAR TABEL
-- ============================================================

-- KASUS 1: Profil lengkap debitur (nasabah + kredit + cabang)
SELECT n.id_nasabah, n.nama_lengkap, n.usia, n.pekerjaan,
       n.penghasilan_bulanan, n.skor_kredit, n.segmen_nasabah,
       k.jenis_kredit, k.plafon, k.sisa_pokok, k.kolektibilitas,
       ROUND(k.sisa_pokok*100.0/k.plafon,1) AS pct_sisa,
       c.nama_cabang, c.kota
FROM mdn_bank.nasabah n
JOIN mdn_bank.kredit k ON n.id_nasabah = k.id_nasabah
JOIN mdn_bank.cabang c ON k.kode_cabang = c.kode_cabang
ORDER BY k.plafon DESC LIMIT 50;

-- KASUS 2: Nasabah tanpa rekening aktif (potential churn)
SELECT n.id_nasabah, n.nama_lengkap, n.email, n.no_telepon,
       n.tanggal_daftar, n.segmen_nasabah, n.kota
FROM mdn_bank.nasabah n
LEFT JOIN mdn_bank.rekening r ON n.id_nasabah = r.id_nasabah AND r.status_rekening = 'Aktif'
WHERE r.id_rekening IS NULL;

-- KASUS 3: Volume transaksi per cabang per produk
SELECT c.nama_cabang, c.kota, p.nama_produk, p.kategori,
       COUNT(t.id_transaksi) AS volume,
       SUM(t.nominal) AS total_nilai
FROM mdn_bank.transaksi t
JOIN mdn_bank.rekening r ON t.nomor_rekening = r.nomor_rekening
JOIN mdn_bank.produk p   ON r.kode_produk = p.kode_produk
JOIN mdn_bank.cabang c   ON t.kode_cabang = c.kode_cabang
WHERE t.status = 'Berhasil' AND t.tanggal >= '2024-01-01'
GROUP BY c.kode_cabang, p.kode_produk
ORDER BY c.nama_cabang, total_nilai DESC;

-- KASUS 4: Top 10 nasabah by transaksi 2024 (program loyalitas)
SELECT n.id_nasabah, n.nama_lengkap, n.segmen_nasabah,
       COUNT(t.id_transaksi) AS frekuensi,
       SUM(t.nominal) AS total_transaksi,
       COUNT(DISTINCT t.channel) AS variasi_channel
FROM mdn_bank.nasabah n
JOIN mdn_bank.transaksi t ON n.id_nasabah = t.id_nasabah
WHERE t.status = 'Berhasil' AND t.tanggal BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY n.id_nasabah, n.nama_lengkap, n.segmen_nasabah
ORDER BY total_transaksi DESC LIMIT 10;

-- ============================================================
--  TAHAP 2 - SQL LANJUTAN: AGGREGASI & WINDOW FUNCTION
-- ============================================================

-- KASUS 1: Tren bulanan DPK & LDR (ALCO Report)
SELECT tahun, bulan,
       SUM(dana_pihak_ketiga) AS total_dpk,
       SUM(kredit_outstanding) AS total_kredit,
       ROUND(SUM(kredit_outstanding)*100.0/SUM(dana_pihak_ketiga),2) AS ldr_pct,
       AVG(npl_pct) AS rata_npl,
       SUM(nasabah_baru) AS total_nasabah_baru
FROM mdn_bank.kpi_cabang
GROUP BY tahun, bulan ORDER BY tahun, bulan;

-- KASUS 2: Ranking cabang dengan WINDOW FUNCTION
SELECT kode_cabang, nama_cabang,
       SUM(dana_pihak_ketiga) AS total_dpk,
       AVG(npl_pct) AS avg_npl,
       AVG(pencapaian_pct) AS avg_pencapaian,
       RANK() OVER (ORDER BY SUM(dana_pihak_ketiga) DESC) AS rank_dpk,
       RANK() OVER (ORDER BY AVG(npl_pct) ASC) AS rank_npl
FROM mdn_bank.kpi_cabang WHERE tahun = 2024
GROUP BY kode_cabang, nama_cabang
ORDER BY total_dpk DESC;

-- KASUS 3: NPL heatmap per cabang
SELECT k.kode_cabang, c.nama_cabang,
       COUNT(*) AS total_debitur,
       SUM(CASE WHEN k.kolektibilitas='Lancar' THEN k.sisa_pokok ELSE 0 END) AS lancar,
       SUM(CASE WHEN k.kolektibilitas='Macet' THEN k.sisa_pokok ELSE 0 END) AS macet,
       ROUND(SUM(CASE WHEN k.kolektibilitas IN ('Kurang Lancar','Diragukan','Macet')
             THEN k.sisa_pokok ELSE 0 END)*100.0/NULLIF(SUM(k.sisa_pokok),0),2) AS npl_pct
FROM mdn_bank.kredit k JOIN mdn_bank.cabang c ON k.kode_cabang = c.kode_cabang
GROUP BY k.kode_cabang, c.nama_cabang
ORDER BY npl_pct DESC;

-- KASUS 4: RFM Segmentation dengan CTE
WITH rfm_base AS (
    SELECT id_nasabah, MAX(tanggal) AS last_trx,
           COUNT(*) AS frequency, SUM(nominal) AS monetary
    FROM mdn_bank.transaksi WHERE status = 'Berhasil' AND tanggal >= '2024-01-01'
    GROUP BY id_nasabah
),
rfm_scored AS (
    SELECT *,
        CASE WHEN last_trx >= '2024-05-01' THEN 3
             WHEN last_trx >= '2024-03-01' THEN 2 ELSE 1 END AS r_score,
        CASE WHEN frequency >= 20 THEN 3
             WHEN frequency >= 10 THEN 2 ELSE 1 END AS f_score,
        CASE WHEN monetary >= 50000000 THEN 3
             WHEN monetary >= 10000000 THEN 2 ELSE 1 END AS m_score
    FROM rfm_base
)
SELECT s.id_nasabah, n.nama_lengkap, n.segmen_nasabah, n.no_telepon,
       (r_score+f_score+m_score) AS rfm_total,
       CASE WHEN (r_score+f_score+m_score)>=8 THEN 'Champions'
            WHEN (r_score+f_score+m_score)>=6 THEN 'Loyal'
            WHEN (r_score+f_score+m_score)>=4 THEN 'Potential'
            ELSE 'At Risk' END AS rfm_segment
FROM rfm_scored s
JOIN mdn_bank.nasabah n ON s.id_nasabah = n.id_nasabah
ORDER BY rfm_total DESC;

