package br.com.goodfood.infra.exception.config;

public record StandardError(
        long timestamp,
        int status,
        String error,
        String message,
        String path
) {}
