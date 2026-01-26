package br.com.goodfood.controller;

import br.com.goodfood.domain.auth.AuthService;
import br.com.goodfood.domain.auth.LoginRequestDTO;
import br.com.goodfood.domain.auth.LoginResponseDTO;
import br.com.goodfood.domain.user.UserRegisterDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO loginData) {
        LoginResponseDTO dto = authService.login(loginData);
        return ResponseEntity.ok(dto);
    }

    @PostMapping("/register")
    public ResponseEntity<LoginResponseDTO> userRegister(
            @RequestPart("data") String data,
            @RequestParam(value = "profilePic", required = false) MultipartFile profilePic
    ) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        UserRegisterDTO dto = mapper.readValue(data, UserRegisterDTO.class);

        LoginResponseDTO response = authService.userRegister(dto, profilePic);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
