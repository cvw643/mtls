package mtls.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class ServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);
    }

    @GetMapping
    ResponseEntity<?> getMessage() {
        return ResponseEntity.ok("Hey, welcome!");
    }

    @EnableWebSecurity
    static class SecurityConfig extends WebSecurityConfigurerAdapter {
        protected void configure(HttpSecurity http) throws Exception {
            // Disable http basic authentication since we are using client auth.
            http.httpBasic().disable();

            // Turn off CSRF and session management for this REST service.
            http.csrf().disable().sessionManagement().sessionCreationPolicy(SessionCreationPolicy.NEVER);
        }
    }

}
