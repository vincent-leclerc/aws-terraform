# Installation d'un serveur web Nginx sur l'instance

## Connexion à l'instance en ssh

<pre>$ ssh -i chemin/firstkeypair.pem ubuntu@ip-publique-de-votre-instance</pre>


## Mise à jour de l'index de paquet local puis installation de Nginx :

<pre>sudo apt update<br>sudo apt install nginx -y </pre>

## Vérification que le server web Nginx tourne:
<pre>systemctl status nginx</pre>

Puis on vérifie que la page web(nginx) est bien accessible :
<pre>curl localhost</pre>

## Ajouter une règle entrante au groupe de sécurité :
 
- Accéder au groupe de sécurité de votre instance
- Cliquer sur l'onglet Règles entrantes, puis modifier les règles entrantes
- Cliquer sur ajouter une règle, puis choisir le type HTTP(80/TCP) et la source personnalisée: 0.0.0.0/0 

Vous devriez maintenant avoir accès à la page web en renseignant l'url : http://ip-publique-de-votre-instance