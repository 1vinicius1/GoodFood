package br.com.goodfood.infra.exception.config;

import br.com.goodfood.infra.exception.AuthenticationException;
import br.com.goodfood.infra.exception.BusinessRuleException;
import br.com.goodfood.infra.exception.ConstraintException;
import br.com.goodfood.infra.exception.ObjectNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ObjectNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public StandardError objectNotFound(ObjectNotFoundException e, HttpServletRequest request) {
        return new StandardError(System.currentTimeMillis(), HttpStatus.NOT_FOUND.value(), "Não encontrado", e.getMessage(), request.getRequestURI());
    }

    @ExceptionHandler(ConstraintException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public StandardError constraint(ConstraintException e, HttpServletRequest request) {
        return new StandardError(System.currentTimeMillis(), HttpStatus.NOT_FOUND.value(), "Restrição de dados", e.getMessage(), request.getRequestURI());
    }

    @ExceptionHandler(BusinessRuleException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public StandardError businessRule(BusinessRuleException e, HttpServletRequest request) {
        return new StandardError(System.currentTimeMillis(), HttpStatus.BAD_REQUEST.value(), "Regra de negócio", e.getMessage(), request.getRequestURI());
    }

    @ExceptionHandler(AuthenticationException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public StandardError authentication(AuthenticationException e, HttpServletRequest request) {
        return new StandardError(System.currentTimeMillis(), HttpStatus.UNAUTHORIZED.value(), "Autenticação", e.getMessage(), request.getRequestURI());
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public StandardError genericException(Exception e, HttpServletRequest request) {
        return new StandardError(System.currentTimeMillis(), HttpStatus.BAD_REQUEST.value(), "Erro desconhecido", e.getMessage(), request.getRequestURI());
    }
}
