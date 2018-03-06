CLIENT1_CER=client1.cer
CLIENT1_PFX=client1.pfx
CLIENT1_JKS=client1.jks
CLIENT2_CER=client2.cer
CLIENT2_PFX=client2.pfx
CLIENT2_JKS=client2.jks
SERVER_CER=server.cer
SERVER_JKS=server.jks
SERVER_TRUST_JKS=trust.jks
PASSWORD=changeme

echo Generate a client and server RSA 2048 key pair
keytool -genkeypair -alias client1 -keyalg RSA -keysize 2048 -dname "CN=Client1,OU=Client,O=IBS,L=Beijing,S=CA,C=U" -keypass $PASSWORD -storepass $PASSWORD -keystore $CLIENT1_JKS
keytool -genkeypair -alias client2 -keyalg RSA -keysize 2048 -dname "CN=Client2,OU=Client,O=IBS,L=Beijing,S=CA,C=U" -keypass $PASSWORD -storepass $PASSWORD -keystore $CLIENT2_JKS
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 -dname "CN=Server,OU=Server,O=IBS,L=Beijing,S=CA,C=U" -keypass $PASSWORD -storepass $PASSWORD -keystore $SERVER_JKS 

echo Export public certificates for both the client and server
keytool -exportcert -alias client1 -file $CLIENT1_CER -storepass $PASSWORD -noprompt -keystore $CLIENT1_JKS
keytool -exportcert -alias client2 -file $CLIENT2_CER -storepass $PASSWORD -noprompt -keystore $CLIENT2_JKS
keytool -exportcert -alias server -file $SERVER_CER -storepass $PASSWORD -noprompt -keystore $SERVER_JKS

echo Import the client certificates into server trust keystore
keytool -importcert -alias client1-public-cert -file $CLIENT1_CER -storepass $PASSWORD -noprompt -keystore $SERVER_TRUST_JKS
keytool -importcert -alias client2-public-cert -file $CLIENT2_CER -storepass $PASSWORD -noprompt -keystore $SERVER_TRUST_JKS

cp $SERVER_JKS $SERVER_TRUST_JKS server/src/main/resources

echo Convert client jks to pfx for importing on client OS
java -jar cert-helper/target/cert-helper-1.0-SNAPSHOT.jar $CLIENT1_JKS $PASSWORD $CLIENT1_PFX
java -jar cert-helper/target/cert-helper-1.0-SNAPSHOT.jar $CLIENT2_JKS $PASSWORD $CLIENT2_PFX
