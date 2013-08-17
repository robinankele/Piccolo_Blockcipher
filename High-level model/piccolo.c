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
 *  Created: 25 Apr 2013
 *  Last Change: 25 Apr 2013
 *
 *  @filename piccolo.c
 */

#include "errors.h"
#include "piccolo.h"
#include <string.h>
#include <stdio.h>

const int M[4][4] = {{2,3,1,1},
                     {1,2,3,1},
                     {1,1,2,3},
                     {3,1,1,2}};

/********************************************************/
int
encryptP(piccolo *pi, int64_t* plaintext, int64_t* key, int64_t* ciphertext)
{
    if(pi == NULL || plaintext == NULL || key == NULL || ciphertext == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    /* generate keys */
    int16_t wk[4];
    int16_t rk[2*ROUNDS];
    if(pi->keySchedule(pi, key, wk, rk) != SUCCESS)
        return ERROR_KEY_SCHEDULE;
    
    /* encrypt */
    if(pi->grFunction(pi, *plaintext, ciphertext, wk, rk) != SUCCESS)
        return ERROR_ENCRYPT;
    
    return SUCCESS;
}

/********************************************************/
int
decryptP(piccolo *pi, int64_t* plaintext, int64_t* key, int64_t* ciphertext)
{
    if(pi == NULL || plaintext == NULL || key == NULL || ciphertext == NULL)
        return ERROR_INVALID_ARGUMENTS;

    /* generate keys */
    int16_t wk[4];
    int16_t rk[2*ROUNDS];
    if(pi->keySchedule(pi, key, wk, rk) != SUCCESS)
        return ERROR_KEY_SCHEDULE;
    
    /* decrypt */
    if(pi->igrFunction(pi, plaintext, *ciphertext, wk, rk) != SUCCESS)
        return ERROR_DECRYPT;
    
    return SUCCESS;
}

/********************************************************/
int
grFunction(piccolo *pi, int64_t x, int64_t *y, int16_t* wk, int16_t* rk)
{
    if(pi == NULL || y == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->grFunction(pi, x, y, wk, rk);
}

/********************************************************/
int
igrFunction(piccolo *pi, int64_t *x, int64_t y, int16_t* wk, int16_t* rk)
{
    if(pi == NULL || x == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->igrFunction(pi, x, y, wk, rk);
}

/********************************************************/
int
fFunction(piccolo *pi, int16_t x, int16_t *y)
{
    if(pi == NULL || y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->fFunction(pi, x, y);
}

/********************************************************/
int
sbox(piccolo *pi, int8_t x, int8_t *y)
{
    if(pi == NULL || y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->sbox(pi, x, y);
}

/********************************************************/
int8_t
gm(piccolo *pi, int8_t a, int8_t b)
{
    if(pi == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->gm(pi, a, b);
}

/********************************************************/
int
diffusionFunction(piccolo *pi, int16_t x, int16_t *y)
{
    if(pi == NULL || y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->diffusionFunction(pi, x, y);
}

/********************************************************/
int
roundPermutation(piccolo *pi, int64_t x, int64_t *y)
{
    if(pi == NULL || y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->roundPermutation(pi, x, y);
}

/********************************************************/
int
keySchedule(piccolo *pi, int64_t *k, int16_t *wk, int16_t *rk)
{
    if(pi == NULL || k == NULL || wk == NULL || rk == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->keySchedule(pi, k, wk, rk);
}

/********************************************************/
int
con2i(piccolo *pi, int8_t i, int16_t *constants)
{
    if(pi == NULL || constants == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    return pi->con2i(pi, i, constants);
}

/********************************************************/
int
concatenate(int16_t x0, int16_t x1, int16_t x2, int16_t x3, int64_t *y)
{
    if(y == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    *y = 0x0000000000000000;

    *y |= x3                  & 0xffff;
    *y |= ((int64_t)x2 << 16) & 0xffffffff;
    *y |= ((int64_t)x1 << 32) & 0xffffffffffff;
    *y |= ((int64_t)x0 << 48) & 0xffffffffffffffff;
    
    return SUCCESS;
}

/********************************************************/
int
seperate(int16_t *x0, int16_t *x1, int16_t *x2, int16_t *x3, int64_t y)
{
    if(x0 == NULL || x1 == NULL || x2 == NULL || x3 == NULL)
        return ERROR_INVALID_ARGUMENTS;
    
    *x3 = y;
    *x2 = (y >> 16);
    *x1 = (y >> 32);
    *x0 = (y >> 48);
    
    return SUCCESS;
}
