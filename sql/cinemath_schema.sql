-- ====================================================================
-- CineMath Network - Enterprise Relational Database Schema (PostgreSQL)
-- Conceptual ERD & Physical DDL Implementation
-- Author: Ahmad Fauzan (NIM: 11220940000031)
-- ====================================================================

-- 1. Table: Cabang_Bioskop (Cinema Branches)
CREATE TABLE Cabang_Bioskop (
    id_cabang INT PRIMARY KEY,
    nama_cabang VARCHAR(100) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    no_telp VARCHAR(20) NOT NULL,
    manager VARCHAR(100) NOT NULL
);

-- 2. Table: Studio (Weak Entity dependent on Cabang_Bioskop)
CREATE TABLE Studio (
    id_studio INT NOT NULL,
    id_cabang INT NOT NULL,
    tipe_layar VARCHAR(50) NOT NULL, -- e.g., '2D', '3D', 'IMAX'
    kapasitas_kursi INT NOT NULL,
    PRIMARY KEY (id_cabang, id_studio),
    FOREIGN KEY (id_cabang) REFERENCES Cabang_Bioskop(id_cabang)
        ON DELETE CASCADE
);

-- 3. Table: Film (Exact DDL from Slide 12)
CREATE TABLE Film (
    film_id INT PRIMARY KEY,
    judul VARCHAR(100) NOT NULL,
    durasi INT NOT NULL,
    tahun_rilis INT NOT NULL,
    genre VARCHAR(50),
    sutradara VARCHAR(100),
    daftar_aktor TEXT -- Bisa dalam string/json
);

-- 4. Table: Penayangan_Film (Movie Showtimes)
CREATE TABLE Penayangan_Film (
    penayangan_id INT PRIMARY KEY,
    film_id INT NOT NULL,
    id_cabang INT NOT NULL,
    id_studio INT NOT NULL,
    jadwal_tayang TIMESTAMP NOT NULL, -- Tanggal dan waktu mulai
    durasi INT NOT NULL,
    FOREIGN KEY (film_id) REFERENCES Film(film_id)
        ON DELETE CASCADE,
    FOREIGN KEY (id_cabang, id_studio) REFERENCES Studio(id_cabang, id_studio)
        ON DELETE CASCADE
);

-- 5. Table: Pelanggan (Registered Customers)
CREATE TABLE Pelanggan (
    pelanggan_id INT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    no_telp VARCHAR(20) NOT NULL
);

-- 6. Table: Tiket (Exact DDL from Slide 12)
CREATE TABLE Tiket (
    tiket_id INT PRIMARY KEY,
    harga DECIMAL(10, 2) NOT NULL, -- Harga tiket dengan 2 desimal
    tempat_duduk VARCHAR(10) NOT NULL, -- F2, C2
    penayangan_id INT NOT NULL,
    pelanggan_id INT,
    FOREIGN KEY (penayangan_id) REFERENCES Penayangan_Film(penayangan_id) 
        ON DELETE CASCADE,
    FOREIGN KEY (pelanggan_id) REFERENCES Pelanggan(pelanggan_id) 
        ON DELETE SET NULL
);

-- 7. Table: Reservasi (Advance Ticket Bookings)
CREATE TABLE Reservasi (
    id_reservasi INT PRIMARY KEY,
    tiket_id INT UNIQUE NOT NULL,
    status VARCHAR(50) NOT NULL, -- e.g., 'Pending', 'Confirmed', 'Cancelled'
    tenggat_konfirmasi TIMESTAMP NOT NULL,
    FOREIGN KEY (tiket_id) REFERENCES Tiket(tiket_id)
        ON DELETE CASCADE
);

-- 8. Table: Laporan_Penjualan (Sales Audit & Revenue Logs)
CREATE TABLE Laporan_Penjualan (
    id_laporan INT PRIMARY KEY,
    id_cabang INT NOT NULL,
    id_studio INT NOT NULL,
    film_id INT NOT NULL,
    tanggal_laporan DATE NOT NULL,
    total_tiket_terjual INT NOT NULL DEFAULT 0,
    total_pendapatan DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (film_id) REFERENCES Film(film_id)
        ON DELETE CASCADE,
    FOREIGN KEY (id_cabang, id_studio) REFERENCES Studio(id_cabang, id_studio)
        ON DELETE CASCADE
);
