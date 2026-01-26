package br.com.goodfood.domain.user;

import lombok.Data;

@Data
public class UserDTO {
    private Long idUser;
    private String name;
    private String email;
    private String profilePic;
}