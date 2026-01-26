package br.com.goodfood.domain.auth;

import br.com.goodfood.domain.user.User;
import br.com.goodfood.domain.user.UserRegisterDTO;
import br.com.goodfood.domain.user.UserRepository;
import br.com.goodfood.infra.exception.AuthenticationException;
import br.com.goodfood.infra.exception.BusinessRuleException;
import br.com.goodfood.infra.exception.ObjectNotFoundException;
import br.com.goodfood.infra.security.TokenService;
import br.com.goodfood.service.ImageStorageService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;
    private final ImageStorageService imageStorageService;

    public AuthService(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            TokenService tokenService,
            ImageStorageService imageStorageService
    ) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
        this.imageStorageService = imageStorageService;
    }

    public LoginResponseDTO login(LoginRequestDTO loginData) {
        User user = userRepository.findByEmail(loginData.email())
                .orElseThrow(() -> new ObjectNotFoundException(
                        "Erro! Não foi possível realizar o login! E-mail ou senha incorretos."
                ));

        if (!passwordEncoder.matches(loginData.password(), user.getPassword())) {
            throw new AuthenticationException(
                    "Erro! Não foi possível realizar o login! E-mail ou senha incorretos."
            );
        }

        String token = tokenService.generateToken(user);
        return new LoginResponseDTO(user.getName(), token);
    }

    @Transactional
    public LoginResponseDTO userRegister(UserRegisterDTO dto, MultipartFile profilePic) {
        Boolean exists = userRepository.existsByEmail(dto.email());

        if (exists) {
            throw new BusinessRuleException(
                    "Erro! Não foi possível cadastrar usuário. Já existe um usuário com esse e-mail cadastrado."
            );
        }

        try {
            User newUser;

            if (profilePic != null && !profilePic.isEmpty()) {
                String imageName = imageStorageService.upload(profilePic);
                newUser = new User(dto.name(), dto.email(), passwordEncoder.encode(dto.password()), imageName);
            } else {
                newUser = new User(dto.name(), dto.email(), passwordEncoder.encode(dto.password()), null);
            }

            userRepository.save(newUser);
            String token = tokenService.generateToken(newUser);

            return new LoginResponseDTO(newUser.getName(), token);
        } catch (IOException e) {
            throw new RuntimeException("Erro! Não foi possível salvar a foto de perfil do usuário.");
        }
    }
}
