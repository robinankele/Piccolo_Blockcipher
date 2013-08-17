/** @brief Piccolo implementation
 *
 *  This file contains the implementation of the blockcipher
 *  Piccolo. This should serve as high-level model for the 
 *  hardware implementation.
 *
 *  Authors: Robin Ankele <robin.ankele@student.tugraz.at>
 *           Muesluem Atas <muesluem.atas@student.tugraz.at>
 *           Ante Nikolic <ante.nikolic@student.tugraz.at>
 *
 *  Created: 3 Apr 2013
 *  Last Change: 25 Apr 2013
 *
 *  @filename piccolo_performance.c
 */

/* This algorithm implementation is optimized for maximum 
   performance. */

#include "errors.h"
#include "piccolo.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


/********************************************************/
static int
p_grFunction(piccolo *algorithm, int64_t x, int64_t *y, int16_t* wk, int16_t* rk)
{
    if(y == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    int16_t x0, x1, x2, x3;
    x3 = x;
    x2 = x >> 16;
    x1 = x >> 32,
    x0 = x >> 48;
    
    /* performing Gr function */
    XOR(x0, wk[0], x0);
    XOR(x2, wk[1], x2);
    
    int16_t temp = 0x0000;
    int16_t fx   = 0x0000;
    int64_t y_   = 0x0000000000000000;
    int i = 0;
    for(; i < ROUNDS - 1; i++){
        
        /* F - function */
        if(fFunction(algorithm, x0, &fx) != SUCCESS)
            return ERROR_ENCRYPT;

        XOR(fx, rk[2*i], temp);
        XOR(x1, temp, x1);
        
        /* F - function */
        if(fFunction(algorithm, x2, &fx) != SUCCESS)
            return ERROR_ENCRYPT;

        XOR(fx, rk[2*i + 1], temp);
        XOR(x3, temp, x3);
        
        /* Round permutation */
        if(concatenate(x0, x1, x2, x3, &y_) != SUCCESS ||
           roundPermutation(algorithm, y_, y) != SUCCESS ||
           seperate(&x0, &x1, &x2, &x3, *y) != SUCCESS)
            return ERROR_ENCRYPT;
    }
    
    /* F - function */
    if(fFunction(algorithm, x0, &fx) != SUCCESS)
        return ERROR_ENCRYPT;
    XOR(fx, rk[2*ROUNDS - 2], temp);
    XOR(x1, temp, x1);
    
    /* F - function */
    if(fFunction(algorithm, x2, &fx) != SUCCESS)
        return ERROR_ENCRYPT;
    XOR(fx, rk[2*ROUNDS - 1], temp);
    XOR(x3, temp, x3);
    
    XOR(x0, wk[2], x0);
    XOR(x2, wk[3], x2);
    
    if(concatenate(x0, x1, x2, x3, y) != SUCCESS)
        return ERROR_ENCRYPT;

    return SUCCESS;
}

/********************************************************/
static int
p_igrFunction(piccolo *algorithm, int64_t *x, int64_t y, int16_t* wk, int16_t* rk)
{
    if(x == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    /* reseting whitening and round keys */
    int16_t iwk[4];
    iwk[0] = wk[2];
    iwk[1] = wk[3];
    iwk[2] = wk[0];
    iwk[3] = wk[1];
    
    int16_t irk[2*ROUNDS];
    int i = 0;
    for(; i < ROUNDS; i++){
        switch(i % 2){
            case 0: irk[2*i] = rk[2*ROUNDS - 2*i - 2];
                    irk[2*i + 1] = rk[2*ROUNDS - 2*i - 1]; break;
            case 1: irk[2*i] = rk[2*ROUNDS - 2*i - 1];
                    irk[2*i + 1] = rk[2*ROUNDS - 2*i - 2]; break;
            default: return ERROR_DECRYPT;
        }
    }

    /* decrypting with Gr - function */
    if(grFunction(algorithm, y, x, iwk, irk) != SUCCESS)
        return ERROR_DECRYPT;
    
    return SUCCESS;
}

/********************************************************/
static int
p_fFunction(piccolo *algorithm, int16_t x, int16_t *y)
{
    if(y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    
    int16_t mask = 0x000F;
    int8_t x0, x1, x2, x3;
    
    x3 = (x >> 0)  & mask;
    x2 = (x >> 4)  & mask;
    x1 = (x >> 8)  & mask;
    x0 = (x >> 12) & mask;

    int8_t temp = 0x00;
    int16_t y_ = 0x0000;
    
    /* first layer Sbox */
    sbox(algorithm, x0, &temp);
    y_ |= (int16_t)temp << 12;
    sbox(algorithm, x1, &temp);
    y_ |= (int16_t)temp << 8;
    sbox(algorithm, x2, &temp);
    y_ |= (int16_t)temp << 4;
    sbox(algorithm, x3, &temp);
    y_ |= (int16_t)temp << 0;
    
    int16_t x_ = 0x0000;
    /* diffusion with diffusion Matrix */
    if(diffusionFunction(algorithm, y_, &x_) != SUCCESS)
        return ERROR_UNKNOWN;

    x3 = (x_ >> 0)  & mask;
    x2 = (x_ >> 4)  & mask;
    x1 = (x_ >> 8)  & mask;
    x0 = (x_ >> 12) & mask;
    
    *y = 0x0000;
    
    /* second layer Sbox */
    sbox(algorithm, x0, &temp);
    *y |= (int16_t)temp << 12;
    sbox(algorithm, x1, &temp);
    *y |= (int16_t)temp << 8;
    sbox(algorithm, x2, &temp);
    *y |= (int16_t)temp << 4;
    sbox(algorithm, x3, &temp);
    *y |= (int16_t)temp << 0;
    
    
    return SUCCESS;
}

static const int8_t sbox_table[16] = {0xe, 0x4, 0xb, 0x2,
                                      0x3, 0x8, 0x0 ,0x9,
                                      0x1, 0xa, 0x7, 0xf,
                                      0x6, 0xc, 0x5, 0xd};

/********************************************************/
static int
p_sbox(piccolo *algorithm, int8_t x, int8_t *y)
{
    if(y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    int8_t mask = 0x0F;
    x &= mask;
    
    /* Sbox lookup */
    *y = sbox_table[x] & mask;

    return SUCCESS;
}

/* Author: Philipp Jovanovic
 * Date  : 25.04.2013
 * Title : piccolo
 * Function: gm() - galois field multiplication with 
 *                  reduction in GF(2^4)
 * Source: https://github.com/Daeinar/piccolo
 */
/********************************************************/
static int8_t
p_gm(piccolo *algorithm, int8_t a, int8_t b)
{
    int8_t g = 0;
    int i;
    for (i = 0; i < 4; i++) {
        if ( (b & 0x1) == 1 ) { g ^= a; }
        int8_t hbs = (a & 0x8);
        a <<= 0x1;
        if ( hbs == 0x8) { a ^= 0x13; }
        b >>= 0x1;
    }
    return g;
}

/********************************************************/
static int
p_diffusionFunction(piccolo *algorithm, int16_t x, int16_t *y)
{
    if(y == NULL)
        return ERROR_INVALID_ARGUMENTS;

    int8_t x0, x1, x2, x3;
    int16_t mask = 0x000F;
    
    x3 = (x >> 0)  & mask;
    x2 = (x >> 4)  & mask;
    x1 = (x >> 8)  & mask;
    x0 = (x >> 12) & mask;
    *y = 0x0000;
    
    /* diffusion with diffusion Matrix */
    *y |= ((gm(algorithm, M[0][0], x0) ^ gm(algorithm, M[0][1], x1) ^ gm(algorithm, M[0][2], x2) ^ gm(algorithm, M[0][3], x3)) & mask) << 12;
    *y |= ((gm(algorithm, M[1][0], x0) ^ gm(algorithm, M[1][1], x1) ^ gm(algorithm, M[1][2], x2) ^ gm(algorithm, M[1][3], x3)) & mask) << 8;
    *y |= ((gm(algorithm, M[2][0], x0) ^ gm(algorithm, M[2][1], x1) ^ gm(algorithm, M[2][2], x2) ^ gm(algorithm, M[2][3], x3)) & mask) << 4;
    *y |= ((gm(algorithm, M[3][0], x0) ^ gm(algorithm, M[3][1], x1) ^ gm(algorithm, M[3][2], x2) ^ gm(algorithm, M[3][3], x3)) & mask) << 0;
    
    return SUCCESS;
}

/********************************************************/
static int
p_roundPermutation(piccolo *algorithm, int64_t x, int64_t *y)
{
    if(y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    uint64_t temp = 0x0000000000000000;
    int64_t mask = 0x00000000000000FF;
    
    /* Perform permuation operation */
    *y = 0x0000000000000000;
    
    temp = (x >> (7 * PERMSIZE)) & mask;
    *y |= (temp << (1 * PERMSIZE));
    temp = (x >> (6 * PERMSIZE)) & mask;
    *y |= (temp << (4 * PERMSIZE));
    temp = (x >> (5 * PERMSIZE)) & mask;
    *y |= (temp << (7 * PERMSIZE));
    temp = (x >> (4 * PERMSIZE)) & mask;
    *y |= (temp << (2 * PERMSIZE));
    temp = (x >> (3 * PERMSIZE)) & mask;
    *y |= (temp << (5 * PERMSIZE));
    temp = (x >> (2 * PERMSIZE)) & mask;
    *y |= (temp << (0 * PERMSIZE));
    temp = (x >> (1 * PERMSIZE)) & mask;
    *y |= (temp << (3 * PERMSIZE));
    temp = (x >> (0 * PERMSIZE)) & mask;
    *y |= (temp << (6 * PERMSIZE));
        
    return SUCCESS;
}

/********************************************************/
static int
p_keySchedule(piccolo *algorithm, int64_t *k, int16_t *wk, int16_t *rk)
{
    if(k == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    int16_t k0 = 0x0000, k1 = 0x0000, k2 = 0x0000, k3 = 0x0000, k4 = 0x0000;
    int64_t mask = 0x000000000000FFFF;

    /* generating keys k0-k4 */
    k4 = (int16_t)(k[0] & mask);
    k3 = (int16_t)((k[0] >> 16) & mask);
    k2 = (int16_t)((k[0] >> 32) & mask);
    k1 = (int16_t)((k[0] >> 48) & mask);
    k0 = (int16_t)(k[1] & mask);

    /* generating whitening keys */
    int16_t lefthalf = 0xFF00, righthalf = 0x00FF;
    wk[0] = (k1 & righthalf);
    wk[0] |= (k0 & lefthalf);
    wk[1] = (k0 & righthalf);
    wk[1] |= (k1 & lefthalf);
    wk[2] = (k3 & righthalf);
    wk[2] |= (k4 & lefthalf);
    wk[3] = (k4 & righthalf);
    wk[3] |= (k3 & lefthalf);
    
    /* generating round keys */
    int16_t constants[2];
    int i = 0;
    for(; i < ROUNDS; i++){
        
        if(con2i(algorithm, i, constants) != SUCCESS)
            return ERROR_KEY_SCHEDULE;
        
        rk[2*i + 1] = constants[0];
        rk[2*i]     = constants[1];
        
        switch(i % 5){
            case 0:
            case 2: XOR(rk[2*i], k2, rk[2*i]);
                    XOR(rk[2*i + 1], k3, rk[2*i + 1]); break;
            case 1:
            case 4: XOR(rk[2*i], k0, rk[2*i]);
                    XOR(rk[2*i + 1], k1, rk[2*i + 1]); break;
            case 3: XOR(rk[2*i], k4, rk[2*i]);
                    XOR(rk[2*i + 1], k4, rk[2*i + 1]); break;
            default: return ERROR_KEY_SCHEDULE;
        }
    }
    
    return SUCCESS;
}

static const int16_t constants_table[ROUNDS][2] = {{0x293d, 0x071c}, {0x253e, 0x1f1a}, {0x213f, 0x1718},
                                                   {0x3d38, 0x2f16}, {0x3939, 0x2714}, {0x353a, 0x3f12},
                                                   {0x313b, 0x3710}, {0x0d34, 0x4f0e}, {0x0935, 0x470c},
                                                   {0x0536, 0x5f0a}, {0x0137, 0x5708}, {0x1d30, 0x6f06},
                                                   {0x1931, 0x6704}, {0x1532, 0x7f02}, {0x1133, 0x7700},
                                                   {0x6d2c, 0x8f3e}, {0x692d, 0x873c}, {0x652e, 0x9f3a},
                                                   {0x612f, 0x9738}, {0x7d28, 0xaf36}, {0x7929, 0xa734},
                                                   {0x752a, 0xbf32}, {0x712b, 0xb730}, {0x4d24, 0xcf2e},
                                                   {0x4925, 0xc72c}};

/********************************************************/
static int
p_con2i(piccolo *algorithm, int8_t i, int16_t *constants)
{
    if(constants == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    /* table lookup of constants con2i and con2i+1 */
    constants[0] = constants_table[i][0];
    constants[1] = constants_table[i][1];
    
    return SUCCESS;
}

/********************************************************/
void createPiccoloMaxPerformance(piccolo **algorithm)
{
    (*algorithm) = malloc(sizeof(piccolo));
    
    (*algorithm)->grFunction = p_grFunction;
    (*algorithm)->igrFunction = p_igrFunction;
    (*algorithm)->fFunction = p_fFunction;
    (*algorithm)->sbox = p_sbox;
    (*algorithm)->gm = p_gm;
    (*algorithm)->diffusionFunction = p_diffusionFunction;
    (*algorithm)->roundPermutation = p_roundPermutation;
    (*algorithm)->keySchedule = p_keySchedule;
    (*algorithm)->con2i = p_con2i;
}
