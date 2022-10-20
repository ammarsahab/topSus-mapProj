# topSus-mapProj
Map Application for STK 493 (Topik Khusus Statistika)

Application link: https://mammarstpc.shinyapps.io/MapApp/

# ENG

## Introduction
In the second half of 2022, most Indonesian college students, including those in IPB University, began attending offline classes. 
Since most students had attended online classes, they were unfamiliar with their campus layout, especially the location of certain classrooms.
Most students ended up surveying classrooms on their own and passing on verbal descriptions of classroom locations (i.e. in building X, near Y) and videos.
Not all students are able to visualize a classroom's location based on verbal descriptions only.
Moreover, they cannot locate themselves relative to the classroom.
The ability to position the classrooms on a map would be very helpful for new students navigating the campus.
Moreover, the ability for students to input rooms that they have located to a public site, instead of only their classmates or friends, 
would unlock a huge source of information on campus locations.

## Purpose

This application aims to make it easier for students to find locations or places to carry out lectures in an attractive way.
In addition to providing the position of the place of study, this application also provides an overview or condition of the place of study, so that the information provided is more specific.

## How this app works

Room data is stored in a view only Google Sheet.

User location is obtained using JavaScript; user must permit app to track their location.

Map is rendered using leaflet.js; markers and map boundaries are adjusted according to user's locations and room data.

Inputs regarding room location is passed onto an editable Google Sheet (not the room Google Sheet!). Sheet administrator manually copies room data if correct.

## What this app can do
- Locate user location and pinpoint their location (blue circle)
- Show marker corresponding to classroom location and data regarding the classroom (name, location, coordinates) if searched
- Allow users to input room data based on their location. Users cannot input data regarding a classroom if not located there.
- This to ensure inputted data has the highest quality possible.
  - Moreover, from a security perspective multiple submissions from the same location would be suspicious

(Already a minimum viable product!)

## What this app cannot do
- Handle huge amounts of data: backend uses Google Sheets. Plan is to transition to using PostgreSQL/SQLite. Sheets is more optimized.
- Automatic data checking for inputs/edit - differentiate between rooms with no data at all, room with data but w/o coordinates, revise room.
- User separation: non-users can view, users can add locations, admins can approve.
- Take only user data from their session
- Menu to help admins; approve, disapprove
- Likes\dislikes: is the room location helpful?
- Media: pictures


# IND

## Latar Belakang 
Di akhir 2022, mahasiswa di Indonesia, khususnya IPB University, mulai melaksanakan kelas luring.
Mahasiswa tidak terbiasa dengan denah kampus; selama ini, mereka melaksanakan kuliah luring.
Mahasiswa akhirnya melakukan survei pribadi ke ruangan kelas. Informasi mengenai lokasi diberikan secara verbal (misal, di gedung X, dekat Y) dan menggunakan video.
Tak semua mahasiswa dapat memvisualisasikan lokasi kelas berdasarkan deskripsi verbal saja.
Mahasiswa juga tak bisa mencari lokasi mereka relatif ke ruang kelas.
Oleh karena itu, kemampuan memosisikan ruang kelas dalam peta dapat membantu mahasiswa melakukan navigasi di kampus.
Selain itu, kemampuan mahasiswa memasukkan ruangan yang telah mereka temukan di suatu situs publik, bukan hanya ruang kelas atau teman,
akan membuka sumber informasi yang signifikan mengenai lokasi kampus.

## Tujuan
Aplikasi ini bertujuan untuk memudahkan mahasiswa dalam mencari lokasi atau tempat melaksanakan kuliah secara luring.
Selain memberikan posisi tempat perkuliahan, aplikasi ini juga memberikan gambaran atau kondisi tempat kuliah, sehingga informasi yang diberikan lebih spesifik.


## Cara Kerja

Data ruangan ditaruh di Google Sheet yang hanya dapat dibaca

Lokasi user diambil menggunakan JavaScript; user harus mengizinkan aplikasi mengakses lokasinya.

Peta dirender menggunakan leaflet; marker dan batas peta diatur sesuai dengan lokasi user dan data ruangan.

Input mengenai lokasi ruangan dimasukkan ke Goo Google Sheet yang dapat diedit - bukan Sheet ruangan. 
Administrator sheet dapat mamasukkan data ruangan secara manual jika benar.

## Apa yang aplikasi dapat lakukan
- Mencari lokasi user dan menunjukkan lokasinya di peta (lingkaran biru)
- Memperlihatkan marker yang menunjukkan lokasi kelas dan menunjukkan data teks mengenai ruang kelas (nama, lokasi, koordinat) jika dicari.
- Memperbolehkan user menginput data ruangan berdasarkan lokasinya. User tidak dapat menginput data ruangan jika dia tidak ada di ruangan tersebut.
- Ini membantu memastikan kualitas data; selain itu, jika ada banyak input di satu lokasi, ini dapat dicurigai

(Tujuan utama telah dipenuhi!)
