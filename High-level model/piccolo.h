/** @brief Piccolo definitions
 *
 *  This file contains the definitions of the blockcipher
 *  Piccolo. 
 *
 *  Authors: Robin Ankele <robin.ankele@student.tugraz.at>
 *           Muesluem Atas <muesluem.atas@student.tugraz.at>
 *           Ante Nikolic <ante.nikolic@student.tugraz.at>
 *
 *  Created: 3 Apr 2013
 *  Last Change: 3 Apr 2013
 *
 *  @filename piccolo_chipsize.h
 */

#ifndef PICCOLO_H
#define PICCOLO_H

#include <stdint.h>

#define KEYSIZE   80
#define BLOCKSIZE 64
#define ROUNDS    25
#define DIFFSIZE  16
#define GF2_4     16
#define PERMSIZE   8
#define SBOXSIZE   4
#define MATELEMT   4
#define KEYCONST  0x0F1E2D3C

extern const int M[4][4];

#define X(x, pos) ((x >> pos) & 0x1)
#define NOR(x, y, z) z = !(x | y)
#define XOR(x, y, z) z = x ^ y
#define XNOR(x, y, z) z = !(x ^ y)

typedef struct _piccolo_{
    int (*grFunction)(struct _piccolo_  *algorithm, int64_t x, int64_t *y, int16_t* wk, int16_t* rk);
    int (*igrFunction)(struct _piccolo_  *algorithm, int64_t *x, int64_t y, int16_t* wk, int16_t* rk);
    int (*fFunction)(struct _piccolo_  *algorithm, int16_t x, int16_t *y);
    int (*sbox)(struct _piccolo_  *algorithm, int8_t x, int8_t *y);
    int8_t (*gm)(struct _piccolo_ *pi, int8_t a, int8_t b);
    int (*diffusionFunction)(struct _piccolo_  *algorithm, int16_t x, int16_t *y);
    int (*roundPermutation)(struct _piccolo_  *algorithm, int64_t x, int64_t *y);
    int (*keySchedule)(struct _piccolo_  *algorithm, int64_t *k, int16_t *wk, int16_t *rk);
    int (*con2i)(struct _piccolo_  *algorithm, int8_t i, int16_t *constants);
} piccolo;

/**
 *  Encryption - encrypts the plaintext P using the key K.
 *  @param plaintext the plaintext P
 *  @param key the key K
 *  @param ciphertext the ciphertext C
 *  @return errorcode of encryption
 */
int encryptP(piccolo *pi, int64_t* plaintext, int64_t* key, int64_t* ciphertext);

/**
 *  Decryption - decrypts the ciphertext C using the key K.
 *  @param plaintext the plaintext P
 *  @param key the key K
 *  @param ciphertext the ciphertext C
 *  @return errorcode of decryption
 */
int decryptP(piccolo *pi, int64_t* plaintext, int64_t* key, int64_t* ciphertext);

/**
 *  Encryption function - encrypts one block using the 
 *  whiteining keys and round keys. Resulting in a cipher
 *  block.
 *  @param x plaintext of BLOCKSIZE
 *  @param y ciphertext of BLOCKSIZE
 *  @param wk whitening keys
 *  @param rk round keys
 *  @return errorcode
 */
int grFunction(piccolo *pi, int64_t x, int64_t *y, int16_t* wk, int16_t* rk);

/**
 *  Decryption function - decrypts one block using the
 *  whiteining keys and round keys. Resulting in a plain
 *  block.
 *  @param x plaintext of BLOCKSIZE
 *  @param y ciphertext of BLOCKSIZE
 *  @param wk whitening keys
 *  @param rk round keys
 *  @return errorcode
 */
int igrFunction(piccolo *pi, int64_t *x, int64_t y, int16_t* wk, int16_t* rk);

/**
 *  does a fFunction operation on the inputblock.
 *  @param x inputvalue
 *  @param y outputvalue
 *  @return errorcode
 */
int fFunction(piccolo *pi, int16_t x, int16_t *y);

/**
 *  does a sbox lookup for a block of SBOXSIZE.
 *  @param x inputvalue
 *  @param y sbox lookuped outputvalue
 *  @return errorcode
 */
int sbox(piccolo *pi, int8_t x, int8_t *y);

/**
 *  performs a GF(2^4) multiplication
 *  @param a operand
 *  @param b operand
 *  @return result
 */
int8_t gm(piccolo *pi, int8_t a, int8_t b);

/**
 *  calculates the diffusion of a block with the diffusion 
 *  Matrix M.
 *  @param x inputvalue
 *  @param y diffusied outputvalue
 *  @return errorcode
 */
int diffusionFunction(piccolo *pi, int16_t x, int16_t *y);

/**
 *  Round permutation.
 *  @param x inputvalue
 *  @param y shuffled outputvalue
 *  @return errorcode
 */
int roundPermutation(piccolo *pi, int64_t x, int64_t *y);

/**
 *  Key scheduling - generates whitening and roundkeys 
 *  from the key (key lenght KEYSIZE).
 *  @param k the key 
 *  @param wk whitening keys - wki(16) 0<=i<= 4
 *  @param rk round keys (4) - rkj(16) 0<=j<=2r
 *  @return errorcode
 */
int keySchedule(piccolo *pi, int64_t *k, int16_t *wk, int16_t *rk);


/**
 *  calculates the constant values con2i and con2i+1 needed
 *  for the key scheduling function.
 *  @param i round number
 *  @param constants con2i and con2i+1 constants
 *  @return errorcode
 */
int con2i(piccolo *pi, int8_t i, int16_t *constants);

/**
 *  Concatenation Function.
 *  @param x0 value to concatenate 
 *  @param x1 value to concatenate
 *  @param x2 value to concatenate
 *  @param x3 value to concatenate 
 *  @param y concatenated value
 *  @return errorcode
 */
int concatenate(int16_t x0, int16_t x1, int16_t x2, int16_t x3, int64_t *y);

/**
 *  Seperate Function.
 *  @param x0 deconcatenated value
 *  @param x1 deconcatenated value
 *  @param x2 deconcatenated value
 *  @param x3 deconcatenated value
 *  @param y concatenated value
 *  @return errorcode
 */
int seperate(int16_t *x0, int16_t *x1, int16_t *x2, int16_t *x3, int64_t y);

/**
 *  Creates a new instance of Piccolo - optimized to minimum chipsize
 *  @param algorithm the algorithm handle
 */
void createPiccoloMinChipsize(piccolo **algorithm);

/**
 *  Creates a new instance of Piccolo - optimized to maximum performance
 *  @param algorithm the algorithm handle
 */
void createPiccoloMaxPerformance(piccolo **algorithm);

#endif /* PICCOLO_H */
