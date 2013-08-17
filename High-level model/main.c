/** @brief Main
 *  
 *  This file contains the main function and initialises the
 *  blockcipher Piccolo.
 *
 *  Authors: Robin Ankele <robin.ankele@student.tugraz.at>
 *           Muesluem Atas <muesluem.atas@student.tugraz.at>
 *           Ante Nikolic <ante.nikolic@student.tugraz.at>
 *
 *  Created: 3 Apr 2013
 *  Last Change: 25 Apr 2013
 *
 *  @filename main.c
 */

/* define used implementation */
#define MINIMUM_CHIPSIZE 0
#define MAXIMUM_PERFORMANCE 1

#include "errors.h"
#include "piccolo.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/**
 *  Displays some basic informations about the algorithm.
 */
void greetings();

/********************************************************/
int
main(int argc, char** args)
{
    greetings();
    
    int64_t plaintext = 0x0000000000000000;
    int64_t key[2];
    int64_t ciphertext = 0x0000000000000000;
    piccolo *algorithm;
    
#if MINIMUM_CHIPSIZE == 1
    createPiccoloMinChipsize(&algorithm);
#endif
#if MAXIMUM_PERFORMANCE == 1
    createPiccoloMaxPerformance(&algorithm);
#endif
    
    /* Reading parameters */
    int opt = 0;
    while((opt = getopt(argc, args, "p:c:k:")) != -1) {
        switch(opt){
            case 'p':
                if(strlen(optarg) == 16)
                    plaintext = strtoul(strtok(optarg, " "), NULL, 16);
                else{
                    printf("Error - Plaintext size does not match!\n");
                    return ERROR_INVALID_INPUT;
                }
                break;
            case 'c':
                if(strlen(optarg) == 16)
                    ciphertext = strtoul(strtok(optarg, " "), NULL, 16);
                else{
                    printf("Error - Ciphertext size does not match!\n");
                    return ERROR_INVALID_INPUT;
                }
                break;
            case 'k':
                if(strlen(optarg) == 21){
                    key[1] = strtoul(strtok(optarg, " "), NULL, 16);
                    key[0] = strtoul(strtok(NULL, " "), NULL, 16);
                }else{
                    printf("Error - Key size does not match!\n");
                    return ERROR_INVALID_INPUT;
                }
                break;
        }
    }
    
    /* Error handling */
    if((ciphertext != 0 && plaintext != 0) || (ciphertext == 0 && plaintext == 0)){
        printf("Error - Wrong operating modi!\n");
        printf("Usage: ./piccolo -p \"<64bit plain>\" or -c \"<64bit cipher>\" -k \"<80bit key>\"!\n");
        return ERROR_INVALID_INPUT;
    }/* Encryption */
    if(ciphertext == 0 && plaintext != 0){
        printf("Encryption\n");
        printf("P  =  %16llx\n", plaintext);
        printf("K  =  %04llx%16llx\n", key[1], key[0]);
        encryptP(algorithm, &plaintext, key, &ciphertext);
        printf("C  =  %16llx\n", ciphertext);
    }/* Decryption */
    if(ciphertext != 0 && plaintext == 0){
        printf("Decryption\n");
        printf("C  =  %16llx\n", ciphertext);
        printf("K  =  %04llx%16llx\n", key[1], key[0]);
        decryptP(algorithm, &plaintext, key, &ciphertext);
        printf("P  = %16llx\n", plaintext);
    }
    return SUCCESS;
}

/********************************************************/
void
greetings()
{
    printf("************************************************\n");
    printf("* PICCOLO blockcipher                          *\n");
#if MINIMUM_CHIPSIZE == 1
    printf("* - optimized to minimum chipsize              *\n");
#endif
#if MAXIMUM_PERFORMANCE == 1
    printf("* - optimized to maximum performance           *\n");
#endif
    printf("* BLOCKSIZE %d                                 *\n", BLOCKSIZE);
    printf("* KEYSIZE   %d                                 *\n", KEYSIZE);
    printf("************************************************\n");
}
