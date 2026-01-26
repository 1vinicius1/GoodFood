package br.com.goodfood.domain.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "idUser")
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idUser")
    private Long idUser;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @ToString.Exclude
    @JsonIgnore
    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "profilePic")
    private String profilePic;

    public User(String name, String email, String password, String profilePic) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.profilePic = profilePic;
    }

    @PrePersist
    private void prePersist() {
        email = email.toLowerCase();
    }

    public Long getIdUser() {
        return idUser;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getProfilePic() {
        return profilePic;
    }
}
