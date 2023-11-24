// HTTP status codes as registered with IANA.
// See: https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
class HttpStatus {
  static const int continue_ = 100; // RFC 9110, 15.2.1
  static const int switchingProtocols = 101; // RFC 9110, 15.2.2
  static const int processing = 102; // RFC 2518, 10.1
  static const int earlyHints = 103; // RFC 8297

  static const int ok = 200; // RFC 9110, 15.3.1
  static const int created = 201; // RFC 9110, 15.3.2
  static const int accepted = 202; // RFC 9110, 15.3.3
  static const int nonAuthoritativeInfo = 203; // RFC 9110, 15.3.4
  static const int noContent = 204; // RFC 9110, 15.3.5
  static const int resetContent = 205; // RFC 9110, 15.3.6
  static const int partialContent = 206; // RFC 9110, 15.3.7
  static const int multiStatus = 207; // RFC 4918, 11.1
  static const int alreadyReported = 208; // RFC 5842, 7.1
  static const int imUsed = 226; // RFC 3229, 10.4.1

  static const int multipleChoices = 300; // RFC 9110, 15.4.1
  static const int movedPermanently = 301; // RFC 9110, 15.4.2
  static const int found = 302; // RFC 9110, 15.4.3
  static const int seeOther = 303; // RFC 9110, 15.4.4
  static const int notModified = 304; // RFC 9110, 15.4.5
  static const int useProxy = 305; // RFC 9110, 15.4.6
  static const int unused306 = 306; // RFC 9110, 15.4.7 (Unused)
  static const int temporaryRedirect = 307; // RFC 9110, 15.4.8
  static const int permanentRedirect = 308; // RFC 9110, 15.4.9

  static const int badRequest = 400; // RFC 9110, 15.5.1
  static const int unauthorized = 401; // RFC 9110, 15.5.2
  static const int paymentRequired = 402; // RFC 9110, 15.5.3
  static const int forbidden = 403; // RFC 9110, 15.5.4
  static const int notFound = 404; // RFC 9110, 15.5.5
  static const int methodNotAllowed = 405; // RFC 9110, 15.5.6
  static const int notAcceptable = 406; // RFC 9110, 15.5.7
  static const int proxyAuthRequired = 407; // RFC 9110, 15.5.8
  static const int requestTimeout = 408; // RFC 9110, 15.5.9
  static const int conflict = 409; // RFC 9110, 15.5.10
  static const int gone = 410; // RFC 9110, 15.5.11
  static const int lengthRequired = 411; // RFC 9110, 15.5.12
  static const int preconditionFailed = 412; // RFC 9110, 15.5.13
  static const int requestEntityTooLarge = 413; // RFC 9110, 15.5.14
  static const int requestURITooLong = 414; // RFC 9110, 15.5.15
  static const int unsupportedMediaType = 415; // RFC 9110, 15.5.16
  static const int requestedRangeNotSatisfiable = 416; // RFC 9110, 15.5.17
  static const int expectationFailed = 417; // RFC 9110, 15.5.18
  static const int teapot = 418; // RFC 9110, 15.5.19 (Unused)
  static const int misdirectedRequest = 421; // RFC 9110, 15.5.20
  static const int unprocessableEntity = 422; // RFC 9110, 15.5.21
  static const int locked = 423; // RFC 4918, 11.3
  static const int failedDependency = 424; // RFC 4918, 11.4
  static const int tooEarly = 425; // RFC 8470, 5.2.
  static const int upgradeRequired = 426; // RFC 9110, 15.5.22
  static const int preconditionRequired = 428; // RFC 6585, 3
  static const int tooManyRequests = 429; // RFC 6585, 4
  static const int requestHeaderFieldsTooLarge = 431; // RFC 6585, 5
  static const int unavailableForLegalReasons = 451; // RFC 7725, 3

  static const int internalServerError = 500; // RFC 9110, 15.6.1
  static const int notImplemented = 501; // RFC 9110, 15.6.2
  static const int badGateway = 502; // RFC 9110, 15.6.3
  static const int serviceUnavailable = 503; // RFC 9110, 15.6.4
  static const int gatewayTimeout = 504; // RFC 9110, 15.6.5
  static const int httpVersionNotSupported = 505; // RFC 9110, 15.6.6
  static const int variantAlsoNegotiates = 506; // RFC 2295, 8.1
  static const int insufficientStorage = 507; // RFC 4918, 11.5
  static const int loopDetected = 508; // RFC 5842, 7.2
  static const int notExtended = 510; // RFC 2774, 7
  static const int networkAuthenticationRequired = 511; // RFC 6585, 6
}

// StatusText returns a text for the HTTP status code. It returns the empty
// string if the code is unknown.
String statusText(int code) {
  switch (code) {
    case HttpStatus.continue_:
      return 'Continue';
    case HttpStatus.switchingProtocols:
      return 'Switching Protocols';
    case HttpStatus.processing:
      return 'Processing';
    case HttpStatus.earlyHints:
      return 'Early Hints';
    case HttpStatus.ok:
      return 'OK';
    case HttpStatus.created:
      return 'Created';
    case HttpStatus.accepted:
      return 'Accepted';
    case HttpStatus.nonAuthoritativeInfo:
      return 'Non-Authoritative Information';
    case HttpStatus.noContent:
      return 'No Content';
    case HttpStatus.resetContent:
      return 'Reset Content';
    case HttpStatus.partialContent:
      return 'Partial Content';
    case HttpStatus.multiStatus:
      return 'Multi-Status';
    case HttpStatus.alreadyReported:
      return 'Already Reported';
    case HttpStatus.imUsed:
      return 'IM Used';
    case HttpStatus.multipleChoices:
      return 'Multiple Choices';
    case HttpStatus.movedPermanently:
      return 'Moved Permanently';
    case HttpStatus.found:
      return 'Found';
    case HttpStatus.seeOther:
      return 'See Other';
    case HttpStatus.notModified:
      return 'Not Modified';
    case HttpStatus.useProxy:
      return 'Use Proxy';
    case HttpStatus.temporaryRedirect:
      return 'Temporary Redirect';
    case HttpStatus.permanentRedirect:
      return 'Permanent Redirect';
    case HttpStatus.badRequest:
      return 'Bad Request';
    case HttpStatus.unauthorized:
      return 'Unauthorized';
    case HttpStatus.paymentRequired:
      return 'Payment Required';
    case HttpStatus.forbidden:
      return 'Forbidden';
    case HttpStatus.notFound:
      return 'Not Found';
    case HttpStatus.methodNotAllowed:
      return 'Method Not Allowed';
    case HttpStatus.notAcceptable:
      return 'Not Acceptable';
    case HttpStatus.proxyAuthRequired:
      return 'Proxy Authentication Required';
    case HttpStatus.requestTimeout:
      return 'Request Timeout';
    case HttpStatus.conflict:
      return 'Conflict';
    case HttpStatus.gone:
      return 'Gone';
    case HttpStatus.lengthRequired:
      return 'Length Required';
    case HttpStatus.preconditionFailed:
      return 'Precondition Failed';
    case HttpStatus.requestEntityTooLarge:
      return 'Request Entity Too Large';
    case HttpStatus.requestURITooLong:
      return 'Request URI Too Long';
    case HttpStatus.unsupportedMediaType:
      return 'Unsupported Media Type';
    case HttpStatus.requestedRangeNotSatisfiable:
      return 'Requested Range Not Satisfiable';
    case HttpStatus.expectationFailed:
      return 'Expectation Failed';
    case HttpStatus.teapot:
      return "I'm a teapot";
    case HttpStatus.misdirectedRequest:
      return 'Misdirected Request';
    case HttpStatus.unprocessableEntity:
      return 'Unprocessable Entity';
    case HttpStatus.locked:
      return 'Locked';
    case HttpStatus.failedDependency:
      return 'Failed Dependency';
    case HttpStatus.tooEarly:
      return 'Too Early';
    case HttpStatus.upgradeRequired:
      return 'Upgrade Required';
    case HttpStatus.preconditionRequired:
      return 'Precondition Required';
    case HttpStatus.tooManyRequests:
      return 'Too Many Requests';
    case HttpStatus.requestHeaderFieldsTooLarge:
      return 'Request Header Fields Too Large';
    case HttpStatus.unavailableForLegalReasons:
      return 'Unavailable For Legal Reasons';
    case HttpStatus.internalServerError:
      return 'Internal Server Error';
    case HttpStatus.notImplemented:
      return 'Not Implemented';
    case HttpStatus.badGateway:
      return 'Bad Gateway';
    case HttpStatus.serviceUnavailable:
      return 'Service Unavailable';
    case HttpStatus.gatewayTimeout:
      return 'Gateway Timeout';
    case HttpStatus.httpVersionNotSupported:
      return 'HTTP Version Not Supported';
    case HttpStatus.variantAlsoNegotiates:
      return 'Variant Also Negotiates';
    case HttpStatus.insufficientStorage:
      return 'Insufficient Storage';
    case HttpStatus.loopDetected:
      return 'Loop Detected';
    case HttpStatus.notExtended:
      return 'Not Extended';
    case HttpStatus.networkAuthenticationRequired:
      return 'Network Authentication Required';
    default:
      return '';
  }
}
