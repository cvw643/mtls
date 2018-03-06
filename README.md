mvn clean package
sh clean.sh
sh genkey.sh
mvn clean package
java -jar server/target/server-1.0-SNAPSHOT.jar

Try use your browser to open https://localhost:8443,
you would got error indicate no or invalid certificate.

Now import the client.pfx to your browser and try again, you would got "Hey, Welcome"