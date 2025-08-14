<!DOCTYPE html>
<html>
<head>
    <title>Kuaför Randevu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: Arial;
            padding: 20px;
            background: #f0f0f0;
        }
        .container {
            max-width: 400px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
        }
        select, input, button {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            background: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .randevu-item {
            background: #f9f9f9;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .sil-btn {
            background: #f44336;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
        h2 {
            color: #333;
            text-align: center;
        }
        .saat-badge {
            background: #2196F3;
            color: white;
            padding: 5px 10px;
            border-radius: 3px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>KUAFÖR RANDEVU SİSTEMİ</h2>
        
        <select id="personel">
            <option>Ali</option>
            <option>Mehmet</option>
            <option>Sezer</option>
            <option>Rıza</option>
            <option>Ahmet</option>
        </select>
        
        <select id="saat">
            <option>08:00</option>
            <option>08:30</option>
            <option>09:00</option>
            <option>09:30</option>
            <option>10:00</option>
            <option>10:30</option>
            <option>11:00</option>
            <option>11:30</option>
            <option>12:00</option>
            <option>12:30</option>
            <option>13:00</option>
            <option>13:30</option>
            <option>14:00</option>
            <option>14:30</option>
            <option>15:00</option>
            <option>15:30</option>
            <option>16:00</option>
            <option>16:30</option>
            <option>17:00</option>
            <option>17:30</option>
            <option>18:00</option>
            <option>18:30</option>
            <option>19:00</option>
            <option>19:30</option>
            <option>20:00</option>
            <option>20:30</option>
            <option>21:00</option>
        </select>
        
        <input type="text" id="aciklama" placeholder="Müşteri adı / Açıklama">
        
        <button onclick="randevuEkle()">RANDEVU EKLE</button>
        
        <h3 id="baslik">Randevular</h3>
        <div id="randevuListesi"></div>
    </div>

    <script>
        // LocalStorage kullanarak veri saklama
        let randevular = JSON.parse(localStorage.getItem('randevular')) || [];
        
        function randevuEkle() {
            const personel = document.getElementById('personel').value;
            const saat = document.getElementById('saat').value;
            const aciklama = document.getElementById('aciklama').value;
            
            if (!aciklama) {
                alert('Lütfen açıklama girin!');
                return;
            }
            
            const yeniRandevu = {
                id: Date.now(),
                personel: personel,
                saat: saat,
                aciklama: aciklama,
                tarih: new Date().toLocaleDateString('tr-TR')
            };
            
            randevular.push(yeniRandevu);
            localStorage.setItem('randevular', JSON.stringify(randevular));
            
            document.getElementById('aciklama').value = '';
            randevulariGoster();
            alert('Randevu eklendi!');
        }
        
        function randevuSil(id) {
            randevular = randevular.filter(r => r.id !== id);
            localStorage.setItem('randevular', JSON.stringify(randevular));
            randevulariGoster();
        }
        
        function randevulariGoster() {
            const liste = document.getElementById('randevuListesi');
            const seciliPersonel = document.getElementById('personel').value;
            const bugun = new Date().toLocaleDateString('tr-TR');
            
            const bugunkunRandevular = randevular.filter(r => 
                r.personel === seciliPersonel && r.tarih === bugun
            );
            
            // Saate göre sırala
            bugunkunRandevular.sort((a, b) => a.saat.localeCompare(b.saat));
            
            liste.innerHTML = '';
            
            if (bugunkunRandevular.length === 0) {
                liste.innerHTML = '<p style="text-align:center; color:#999;">Randevu bulunmuyor</p>';
                return;
            }
            
            bugunkunRandevular.forEach(randevu => {
                const item = document.createElement('div');
                item.className = 'randevu-item';
                item.innerHTML = `
                    <div>
                        <span class="saat-badge">${randevu.saat}</span>
                        <span>${randevu.aciklama}</span>
                    </div>
                    <button class="sil-btn" onclick="randevuSil(${randevu.id})">Sil</button>
                `;
                liste.appendChild(item);
            });
            
            document.getElementById('baslik').textContent = `${seciliPersonel} - Bugünkü Randevular`;
        }
        
        // Personel değiştiğinde listeyi güncelle
        document.getElementById('personel').addEventListener('change', randevulariGoster);
        
        // Sayfa yüklendiğinde randevuları göster
        randevulariGoster();
        
        // Her 30 saniyede bir otomatik yenile
        setInterval(randevulariGoster, 30000);
    </script>
</body>
</html>
