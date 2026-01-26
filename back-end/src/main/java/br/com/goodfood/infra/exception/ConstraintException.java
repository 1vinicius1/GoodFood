package br.com.goodfood.infra.exception;

public class ConstraintException extends RuntimeException {
    public ConstraintException(String message) {
        super(message);
    }
}
