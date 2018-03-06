package mtls.cert;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.security.Key;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.util.Enumeration;

public class CertHelper {

    /**
     * 将keystore转为pfx
     */
    public static void jks2Pfx(String jksPath, String jksPassword, String pfxPath) throws Exception {
        KeyStore inputKeyStore = KeyStore.getInstance("JKS");
        FileInputStream fis = new FileInputStream(jksPath);
        char[] nPassword;

        if ((jksPassword == null)
                || jksPassword.trim().equals("")) {
            nPassword = null;
        } else {
            nPassword = jksPassword.toCharArray();
        }

        inputKeyStore.load(fis, nPassword);
        fis.close();

        KeyStore outputKeyStore = KeyStore.getInstance("PKCS12");

        outputKeyStore.load(null, jksPassword.toCharArray());

        Enumeration enums = inputKeyStore.aliases();

        while (enums.hasMoreElements()) { // we are readin just one
            // certificate.

            String keyAlias = (String) enums.nextElement();

            System.out.println("alias=[" + keyAlias + "]");

            if (inputKeyStore.isKeyEntry(keyAlias)) {
                Key key = inputKeyStore.getKey(keyAlias, nPassword);
                Certificate[] certChain = inputKeyStore
                        .getCertificateChain(keyAlias);

                outputKeyStore.setKeyEntry(keyAlias, key,
                        jksPassword.toCharArray(), certChain);
            }
        }

        FileOutputStream out = new FileOutputStream(pfxPath);

        outputKeyStore.store(out, nPassword);
        out.close();

    }

    public static void main(String[] args) throws Exception {
        if (args.length != 3) {
            usage();
            return;
        }
        jks2Pfx(args[0], args[1], args[2]);
    }

    private static void usage() {
        System.out.println("program <jksPath> <jksPassword> <pfxPath>");
    }
}
