
# Firefox _engabiat_ en contenidor

Aquest projecte permet executar el navegador **Firefox** dins d’un contenidor, de manera que totes les dades generades (descàrregues, bookmarks, configuració, cookies, etc.) quedin persistents al sistema. Això aporta un punt extra de **seguretat** quan es vol navegar per llocs web en què no es té plena confiança, evitant que el navegador tingui accés directe al sistema host.

**Autor:** Angel Galindo Muñoz  
**Data:** 30/11/2025

---

## Objectiu
- Aïllar Firefox
- Mantenir persistència de dades (perfil, descàrregues, configuració).
- Facilitar la integració amb l'escriptori (Gnome).

---

## Scripts per a aconseguir-ho
Aquests **5 scripts** permeten aconseguir-ho:

### 1. `firefox_engabiat.01.paquets_usuari_i_carpetes.sh`
Instal·la els paquets necessaris, crea l’usuari i les carpetes per al _Firefox engabiat_.

### 2. `firefox_engabiat.02.crea_imatge.sh`
Construeix la imatge del contenidor amb Firefox.

### 3. `firefox_engabiat.03.executa_firefox.sh`
Executa el contenidor amb _Firefox engabiat_.

### 4. `firefox_engabiat.04.depura_firefox.sh`
Si quelcom falla i cal investigar-ho, aquest script executa el contenidor en mode depuració, iniciant un shell **bash** per inspeccionar-lo.

### 5. `firefox_engabiat.05.crea_drecera.sh`
Crea una drecera per executar el contenidor des de **GNOME**.

---

## Beneficis resultants
- **Seguretat**: Firefox no té accés directe al sistema host.
- **Persistència**: Les dades del perfil es guarden fora del contenidor.
- **Integració**: Es pot llançar des de l’escriptori com qualsevol aplicació.

