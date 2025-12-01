
# Firefox _engabiat_ en contenidor

Aquest petit projecte permet executar el navegador **Firefox** dins d’un contenidor utilitzant un usuari no privilegiat.

Evita que el navegador corri directament com l'usuari del host, que tingui accés directe al sistema de fitxers i a l'espai de processos del host. El navegador corre amb un usuari no privilegiat dins d'un contenidor i totes les dades que genera (descàrregues, bookmarks, configuració, cookies, etc.) queden persistents a una carpeta definida.

Això aporta un punt extra de **seguretat** quan es vol navegar per llocs web en què no es té plena confiança, però no ofereix seguretat absoluta, no eximeix de l'ús antivirus.

**Autor:** Angel Galindo Muñoz  
**Data:** 30/11/2025

---

## Objectiu
- Aïllar Firefox
- Mantenir persistència de dades (perfil, descàrregues, configuració).
- Facilitar la integració amb l'escriptori (Gnome).

---

## Scripts per a aconseguir-ho
Aquests **5 scripts** permeten aconseguir-ho creant un contenidor _podman rootless_ des d'un usuari no privilegiat:

### 1. `firefox_engabiat.01.paquets_usuari_i_carpetes.sh`
Instal·la els paquets necessaris, crea l’usuari i les carpetes per al _Firefox engabiat_.

### 2. `firefox_engabiat.02.crea_imatge.sh`
Construeix la imatge del contenidor amb Firefox. Pot tornar a executar-se en qualsevol moment per a actualitzar el navegador.

### 3. `firefox_engabiat.03.executa_firefox.sh`
Executa el contenidor amb _Firefox engabiat_.

### 4. `firefox_engabiat.04.depura_firefox.sh`
Si quelcom falla i cal investigar-ho, aquest script executa el contenidor en mode depuració, iniciant un shell **bash** per inspeccionar-lo.

### 5. `firefox_engabiat.05.crea_drecera.sh`
Crea una drecera al Dash de **Gnome** per a facilitar-ne l'execució.

---

## Mostra dels fitxers generats navegant

Com els veus l'usuari real del sistema:

```bash
convidat@zoquero:~$ ls -lat firefox_engabiat.dades/
total 40
drwxr-x--- 21 convidat convidat 4096 de des.   1 21:37 ..
-rw-------  1 convidat convidat   38 de des.   1 21:31 .bash_history
drwxrwxr-x  9 convidat convidat 4096 de des.   1 21:30 .
drwxr-xr-x  2 convidat convidat 4096 de des.   1 21:20 Baixades
...
drwx------  3 convidat convidat 4096 de des.   1 21:16 .dbus
```


Com es veuen des del contenidor:

```bash
convidat@zoquero:~$ firefox_engabiat/firefox_engabiat.04.depura_firefox.sh 
convidat@1c13796ea7e2:/$ ls -lat /convidat/
total 40
-rw------- 1 convidat convidat   14 de des.   1 20:30 .bash_history
drwxrwxr-x 9 convidat convidat 4096 de des.   1 20:30 .
dr-xr-xr-x 1 root     root     4096 de des.   1 20:27 ..
drwxr-xr-x 2 convidat convidat 4096 de des.   1 20:20 Baixades
...
drwx------ 3 convidat convidat 4096 de des.   1 20:16 .dbus
```


L'usuari és homònim, però la primera carpeta es mostra des del host i la segona des del contenidor.

---

## Beneficis resultants
- **Seguretat**: Firefox no té accés directe al sistema host.
- **Persistència**: Les dades del perfil es guarden fora del contenidor.
- **Integració**: Es pot llançar des de l’escriptori com qualsevol aplicació.

