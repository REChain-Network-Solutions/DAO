<style>
  img {
    border: none;
    -ms-interpolation-mode: bicubic;
    max-width: 100%;
  }

  body {
    background-color: #f6f6f6;
    font-family: sans-serif;
    -webkit-font-smoothing: antialiased;
    font-size: 14px;
    line-height: 1.4;
    margin: 0;
    padding: 0;
    -ms-text-size-adjust: 100%;
    -webkit-text-size-adjust: 100%;
  }

  table {
    border-collapse: separate;
    width: 100%;
  }

  table td {
    font-family: sans-serif;
    font-size: 14px;
    vertical-align: top;
  }

  .body {
    background-color: #f6f6f6;
    width: 100%;
  }

  .container {
    display: block;
    margin: 0 auto !important;
    max-width: 580px;
    padding: 10px;
    width: 580px;
  }

  .content {
    box-sizing: border-box;
    display: block;
    margin: 0 auto;
    max-width: 580px;
    padding: 10px;
  }

  .main {
    background: #ffffff;
    border-radius: 3px;
    width: 100%;
  }

  .wrapper {
    box-sizing: border-box;
    padding: 30px;
  }

  .content-block {
    padding-bottom: 10px;
    padding-top: 10px;
  }

  .footer {
    clear: both;
    margin-top: 10px;
    text-align: center;
    width: 100%;
  }

  .footer td,
  .footer p,
  .footer span,
  .footer a {
    color: #999999;
    font-size: 12px;
    text-align: center;
  }

  h1,
  h2,
  h3,
  h4 {
    color: #000000;
    font-family: sans-serif;
    font-weight: 400;
    line-height: 1.4;
    margin: 0;
    margin-bottom: 30px;
  }

  h1 {
    font-size: 26px;
    font-weight: 600;
    color: #222222;
    margin-bottom: 20px;
  }

  p,
  ul,
  ol {
    font-family: sans-serif;
    font-size: 14px;
    font-weight: normal;
    margin: 0;
    margin-bottom: 15px;
    color: #555555;
    line-height: 1.6;
  }

  a {
    color: #5e72e4;
    text-decoration: underline;
  }

  /* Buttons */
  .btn {
    box-sizing: border-box;
    width: 100%;
    margin: 20px 0;
  }

  .btn>tbody>tr>td {
    padding-bottom: 15px;
  }

  .btn table {
    width: auto;
  }

  .btn table td {
    background-color: #ffffff;
    border-radius: 5px;
    text-align: center;
  }

  .btn a {
    background-color: #ffffff;
    border: solid 1px #5e72e4;
    border-radius: 5px;
    box-sizing: border-box;
    color: #5e72e4;
    cursor: pointer;
    display: inline-block;
    font-size: 14px;
    font-weight: bold;
    margin: 0;
    padding: 12px 30px;
    text-decoration: none;
    text-transform: capitalize;
  }

  .btn-primary table td {
    background-color: #5e72e4;
  }

  .btn-primary a {
    background-color: #5e72e4;
    border-color: #5e72e4;
    color: #ffffff;
  }

  /* Utilities */
  .align-center {
    text-align: center;
  }

  .align-right {
    text-align: right;
  }

  .align-left {
    text-align: left;
  }

  .preheader {
    color: transparent;
    display: none;
    height: 0;
    max-height: 0;
    max-width: 0;
    opacity: 0;
    overflow: hidden;
    visibility: hidden;
    width: 0;
  }

  hr {
    border: 0;
    border-bottom: 1px solid #eeeeee;
    margin: 24px 0;
  }

  /* Logo header (above white card) */
  .email-header {
    text-align: center;
    padding: 30px 0 10px;
  }

  .email-header a {
    text-decoration: none;
  }

  .email-header img {
    max-height: 50px;
    width: auto;
    max-width: 200px;
  }

  .email-header .site-name {
    font-size: 24px;
    font-weight: 700;
    color: #5e72e4;
    font-family: sans-serif;
  }

  /* Accent bar at top of card */
  .header-bar {
    background-color: #5e72e4;
    height: 4px;
    border-radius: 3px 3px 0 0;
    padding: 0 !important;
    font-size: 0;
    line-height: 0;
  }

  /* Verification / 2FA code display */
  .code-block {
    background-color: #f4f4f4;
    border-radius: 6px;
    padding: 24px;
    text-align: center;
    margin: 20px 0;
  }

  .code-block span {
    font-family: monospace, monospace;
    font-size: 32px;
    font-weight: bold;
    color: #333333;
    letter-spacing: 8px;
  }

  /* Notification / message highlight strip */
  .notification-box {
    background-color: #f9f9f9;
    border-left: 3px solid #5e72e4;
    border-radius: 0 4px 4px 0;
    padding: 15px;
    margin: 16px 0;
    color: #333333;
  }

  /* Contact form detail rows */
  .detail-table {
    width: 100%;
    border-collapse: collapse;
    margin: 16px 0;
  }

  .detail-table td {
    padding: 10px 12px;
    border-bottom: 1px solid #f0f0f0;
    font-size: 14px;
  }

  .detail-label {
    font-weight: 600;
    color: #444444;
    width: 35%;
    white-space: nowrap;
  }

  .detail-value {
    color: #555555;
  }

  .message-box {
    background-color: #f9f9f9;
    border-left: 3px solid #5e72e4;
    border-radius: 0 4px 4px 0;
    padding: 15px;
    margin: 16px 0;
    color: #333333;
    white-space: pre-wrap;
  }

  .highlight {
    color: #5e72e4;
    font-weight: bold;
  }

  .note {
    font-size: 12px;
    color: #999999;
    margin-top: 20px;
  }

  /* Responsive */
  @media only screen and (max-width: 620px) {
    table[class=body] h1 {
      font-size: 22px !important;
      margin-bottom: 10px !important;
    }

    table[class=body] p,
    table[class=body] ul,
    table[class=body] ol,
    table[class=body] td,
    table[class=body] span,
    table[class=body] a {
      font-size: 16px !important;
    }

    table[class=body] .wrapper {
      padding: 15px !important;
    }

    table[class=body] .content {
      padding: 0 !important;
    }

    table[class=body] .container {
      padding: 0 !important;
      width: 100% !important;
    }

    table[class=body] .main {
      border-left-width: 0 !important;
      border-radius: 0 !important;
      border-right-width: 0 !important;
    }

    table[class=body] .btn table {
      width: 100% !important;
    }

    table[class=body] .btn a {
      width: 100% !important;
    }
  }

  @media all {
    .ExternalClass {
      width: 100%;
    }

    .ExternalClass,
    .ExternalClass p,
    .ExternalClass span,
    .ExternalClass font,
    .ExternalClass td,
    .ExternalClass div {
      line-height: 100%;
    }

    .apple-link a {
      color: inherit !important;
      font-family: inherit !important;
      font-size: inherit !important;
      font-weight: inherit !important;
      line-height: inherit !important;
      text-decoration: none !important;
    }

    #MessageViewBody a {
      color: inherit;
      text-decoration: none;
      font-size: inherit;
      font-family: inherit;
      font-weight: inherit;
      line-height: inherit;
    }

    .btn-primary table td:hover {
      background-color: #4d61cf !important;
    }

    .btn-primary a:hover {
      background-color: #4d61cf !important;
      border-color: #4d61cf !important;
    }
  }
</style>