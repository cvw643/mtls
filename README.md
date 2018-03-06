## Usage

- Run the server
```
mvn clean package
sh clean.sh
sh genkey.sh
mvn clean package
java -jar server/target/mtls-server-1.0-SNAPSHOT.jar
```

- Use your browser to connect the server
1. open https://localhost:8443 without importing certificate.
  Yes, you would get error for no or invalid certificate.
2. Import a pfx and try again.
  OK, you would get "Hey, Welcome xxx!"