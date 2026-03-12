package com.example.bank.controller;

import com.example.bank.dto.TransferRequest;
import com.example.bank.entity.Account;
import com.example.bank.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {

    @Autowired
    private AccountRepository accountRepository;

    @GetMapping("/{number}")
    public ResponseEntity<Account> getBalance(@PathVariable String number) {
        return accountRepository.findByNumber(number)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/transfer")
    public ResponseEntity<String> transfer(@RequestBody TransferRequest request) {
        // Logique très simplifiée (à sécuriser en production !)
        // Vérifier soldes, débiter/crediter, créer transaction...
        return ResponseEntity.ok("Virement effectué avec succès");
    }
}
