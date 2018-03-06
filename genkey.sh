CLIENT_CER=client.cer
CLIENT_PFX=client.pfx
CLIENT_JKS=client.jks
SERVER_CER=server.cer
SERVER_JKS=server.jks
SERVER_TRUST_JKS=trust.jks
PASSWORD=changeme

echo Generate a client and server RSA 2048 key pair
keytool -genkeypair -alias client -keyalg RSA -keysize 2048 -dname "CN=Client,OU=Client,O=IBS,L=Beijing,S=CA,C=U" -keypass $PASSWORD -storepass $PASSWORD -keystore $CLIENT_JKS 
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 -dname "CN=Server,OU=Server,O=IBS,L=Beijing,S=CA,C=U" -keypass $PASSWORD -storepass $PASSWORD -keystore $SERVER_JKS 

echo Export public certificates for both the client and server
keytool -exportcert -alias client -file $CLIENT_CER -storepass $PASSWORD -noprompt -keystore $CLIENT_JKS
keytool -exportcert -alias server -file $SERVER_CER -storepass $PASSWORD -noprompt -keystore $SERVER_JKS

echo Import the client and server public certificates into each others keystore
#keytool -importcert -alias server-public-cert -file $SERVER_CER -storepass $PASSWORD -noprompt -keystore $CLIENT_JKS
keytool -importcert -alias client-public-cert -file $CLIENT_CER -storepass $PASSWORD -noprompt -keystore $SERVER_TRUST_JKS

cp $SERVER_JKS $SERVER_TRUST_JKS server/src/main/resources

echo Convert client jks to pfx
java -jar cert-helper/target/cert-helper-1.0-SNAPSHOT.jar $CLIENT_JKS $PASSWORD $CLIENT_PFX
