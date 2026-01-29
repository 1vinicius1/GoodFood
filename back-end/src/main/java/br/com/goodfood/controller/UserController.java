package br.com.goodfood.controller;

import br.com.goodfood.domain.user.User;
import br.com.goodfood.domain.user.UserDTO;
import br.com.goodfood.service.MapperService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    private final MapperService mapperService;

    public UserController(MapperService mapperService) {
        this.mapperService = mapperService;
    }

    @GetMapping("/me")
    public ResponseEntity<UserDTO> me(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        UserDTO dto = mapperService.transform(user, UserDTO.class);
        return ResponseEntity.ok(dto);
    }
}

