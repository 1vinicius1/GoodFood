package br.com.goodfood.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service
public class ImageStorageService {
    // Alterar caminho em ambiente de produção
    private static final String UPLOAD_FOLDER = System.getProperty("user.dir") + "/src/main/resources/storage/";

    public String upload(MultipartFile image) throws IOException {

        String newName = this.generateNewName(image.getOriginalFilename());

        String fullFilePath = UPLOAD_FOLDER + newName;

        image.transferTo(new File(fullFilePath));

        return newName;
    }

    private String generateNewName(String originalName) {
        String[] splitName = originalName.split("\\.");
        String extension = "." + splitName[1];

        return UUID.randomUUID() + extension;
    }
}
