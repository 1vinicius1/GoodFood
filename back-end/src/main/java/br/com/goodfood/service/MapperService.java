package br.com.goodfood.service;


import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MapperService {
    @Autowired
    private ModelMapper modelMapper;

    public <I, O> O transform(I inputObject, Class<O> outputClass) {
        return modelMapper.map(inputObject, outputClass);
    }
}
