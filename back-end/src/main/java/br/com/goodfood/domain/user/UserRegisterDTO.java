package br.com.goodfood.domain.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UserRegisterDTO(
        @NotNull(message = "O nome não pode ser nulo.")
        @NotBlank(message = "O nome é obrigatório.")
        String name,

        @NotNull(message = "O e-mail não pode ser nulo.")
        @NotBlank(message = "O e-mail é obrigatório.")
        @Email(message = "E-mail inválido. Verifique o valor informado.")
        String email,

        @NotNull(message = "A senha não pode ser nula.")
        @NotBlank(message = "A senha é obrigatória.")
        String password
        ) {
}
