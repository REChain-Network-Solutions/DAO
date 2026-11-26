/**
 * sockets -> nodejs -> libs -> core -> exceptions
 * 
 * @package Sngine
 * @author Zamblek
 */

class BadRequestException extends Error {
  constructor(message) {
    super(message);
    this.name = 'BadRequestException';
  }
}

class ValidationException extends Error {
  constructor(message) {
    super(message);
    this.name = 'ValidationException';
  }
}

class AuthorizationException extends Error {
  constructor(message) {
    super(message);
    this.name = 'AuthorizationException';
  }
}

class PrivacyException extends Error {
  constructor(message) {
    super(message);
    this.name = 'PrivacyException';
  }
}

class NotFoundException extends Error {
  constructor(message) {
    super(message);
    this.name = 'NotFoundException';
  }
}

module.exports = {
  BadRequestException,
  ValidationException,
  AuthorizationException,
  PrivacyException,
  NotFoundException,
};
