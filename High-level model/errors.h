/** @brief Error definitions
 *
 *  This file contains the definitions of all errorcodes.
 *
 *  Authors: Robin Ankele <robin.ankele@student.tugraz.at>
 *
 *  Created: 3 Apr 2013
 *  Last Change: 3 Apr 2013
 *
 *  @filename errors.h
 */

#ifndef ERRORS_H
#define ERRORS_H

enum{
    SUCCESS = 0,
    ERROR_UNKNOWN,
    ERROR_ENCRYPT,
    ERROR_DECRYPT,
    ERROR_INVALID_ARGUMENTS,
    ERROR_INVALID_INPUT,
    ERROR_KEY_SCHEDULE
};

#endif /* ERRORS_H */
