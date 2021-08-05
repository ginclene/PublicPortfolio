<%@ Page Title="Checkout" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Checkout.aspx.cs" Inherits="CustodiansOfOxford.Checkout" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src="Scripts/moment-with-locales.js"></script>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/moment.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/bootstrap-datetimepicker.js"></script>
    <link href="Content/bootstrap-datetimepicker.css" rel="stylesheet" />

<!DOCTYPE html>



    <style>
        .center {
            text-align = center;
            text-decoration = bold;
        }
    </style>
    <div class="center" id="title">
        <h1>Checkout</h1>
    </div>

    <div id="cartItems">
    <asp:Label ID="lblData" runat="server" Text=""></asp:Label>
        <asp:Label ID="total" runat="server" Text=""></asp:Label>
        
        </div>

    <div id="serName" style="text-align: center; font-weight: bold; font-size: 20px;"></div>
    <div id="picker" style="display: none"></div>
    <div id="selected-dates"></div>
    <div id="slots"></div>

    <div id="hiddenstuff">
        <asp:HiddenField runat="server" ID="SubID" Value="" />
        <asp:Button runat="server" ID="hiddenButton" ClientIDMode="Static" Text="" style="display:none;" OnClick="removeItem" AutoPostBack="True" />
    </div>

     <asp:Label ID="totalAmount" runat="server" Text=""></asp:Label>


   <button type="button" class = "btn btn-primary" id="payButton" style="display : none;" onclick="saveDate()">Pay on site</button>
    <div id="container" style="display : none;" onclick="saveDate()"></div>
      <!-- Links for the calendar  -->
    <link rel="stylesheet" href="mark-your-calendar.css" />
    <script src="mark-your-calendar.js"></script>
       <script>
           var arr = [];
           var amount = 0;
           var counter = 0;
           const schedule = [['Morning', 'Afternoon'], 
           ['Morning', 'Afternoon'], 
           ['Morning', 'Afternoon'],
           ['Morning', 'Afternoon'],
           ['Morning', 'Afternoon'],
           ['Morning', 'Afternoon'],
           ['Morning', 'Afternoon']
           ];
               (function ($) {
                   $('#picker').markyourcalendar({
                       availability: schedule,
                       onClick: function (ev, data) {
                           
                           // data is a list of datetimes
                           console.log(data);
                           var html = ``;
                           $.each(data, function () {
                               var d = this.split(' ')[0];
                               var t = this.split(' ')[1];
                               html += `<p>` + d + ` ` + t + `</p>`;
                           });
                           var dateTime = html
                           dateTime = dateTime.substring(3);
                           dateTime = dateTime.substring(0, dateTime.length - 4);

                           // Calling method checkDate in the back, passing to it the date + time
                           $.ajax({
                               type: "POST",
                               url: 'Checkout.aspx/checkDate',
                               data: '{date: "' + dateTime + '" }',
                               contentType: "application/json; charset=utf-8",
                               dataType: "json",
                               success: function (msg) {
                                   if (msg.d == -1) {
                                       $('#selected-dates').html("Please click slower");
                                       $('#slots').html("");
                                   } else {
                                       var slots = msg.d;
                                       console.log(slots);
                                       if (slots >= 3) {
                                           slots = "No available slots";
                                           $('#slots').html(slots + " ");
                                       } else {
                                           var helper = slots;
                                           helper = 3 - helper;
                                           slots = "Number of slots available: " + helper;
                                           $('#slots').html(slots + " ");
                                           $('#slots').append("<button type='button' class='btn btn-primary' id='confirmationButton' onclick='confirmDate()' value='" + name + "' >Confirm date </button>");

                                       }
                                       $('#selected-dates').html(dateTime);                                       
                                   }
                               },
                               error: function (e) {
                                   console.error(e);
                               }
                           });
            
                          

                       },
                       onClickNavigator: function (ev, instance) {
                           var arr = [
                               [['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon'],
                               ['Morning', 'Afternoon']
                               ]
                           ]
                           instance.setAvailability(arr[0]);
                       }
                   });
               })(jQuery);


           function showName(name) {
               document.getElementById("picker").style.display = "block";
               document.getElementById("serName").innerHTML = name;

           }

        

           function confirmDate() {
               let serName = document.getElementById("serName").innerHTML;
               let costOfService = document.getElementById(serName + " cost").innerHTML;
               amount += Number(costOfService);
               amount = amount * 100;
               Math.round(amount);
               amount = amount / 100;
               let arr2 = [];
               document.getElementById("MainContent_totalAmount").innerHTML = amount;
               let helper = document.getElementById("selected-dates").innerHTML;
               let time = helper.substring(11); 
               let date = helper.substring(0, 10);
               arr2[0] = date;
               arr2[1] = time;
               arr2[2] = document.getElementById("serName").innerHTML;
               arr.push(arr2);
               document.getElementById('confirmationButton').style.backgroundColor = "green";
               document.getElementById("confirmationButton").innerHTML= "Date Confirmed";
               document.getElementById("confirmationButton").disabled = true;
               document.getElementById("payButton").style.display = "block";
               document.getElementById("container").style.display = "block";

               document.getElementById("picker").style.display = "none";
               let value = document.getElementById("serName").innerHTML
               document.getElementById(value).disabled = true;
               counter = counter + 1;

           }

           function saveDate() {
               
               $.ajax({
                   type: "POST",
                   url: 'Checkout.aspx/saveDate',
                   data: '{arr: "' + arr + '" }',
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   success: function (msg) {
                       console.log("Are ya winning son?")
                       
                   },
                   error: function (e) {
                       console.error(e);
                   }
               });

           }

           function removeItem(id) {
               console.log("found cart function");
               console.log("the id is " + id);
               document.getElementById("<%=SubID.ClientID%>").value = id;
               document.getElementById("<%=hiddenButton.ClientID%>").click();
           }
       </script>
    <script async src="https://pay.google.com/gp/p/js/pay.js" onload="onGooglePayLoaded()"></script>
       <script>
           /**
            * Define the version of the Google Pay API referenced when creating your
            * configuration
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#PaymentDataRequest|apiVersion in PaymentDataRequest}
            */
           const baseRequest = {
               apiVersion: 2,
               apiVersionMinor: 0
           };

           /**
            * Card networks supported by your site and your gateway
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#CardParameters|CardParameters}
            * @todo confirm card networks supported by your site and gateway
            */
           const allowedCardNetworks = ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"];

           /**
            * Card authentication methods supported by your site and your gateway
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#CardParameters|CardParameters}
            * @todo confirm your processor supports Android device tokens for your
            * supported card networks
            */
           const allowedCardAuthMethods = ["PAN_ONLY", "CRYPTOGRAM_3DS"];

           /**
            * Identify your gateway and your site's gateway merchant identifier
            *
            * The Google Pay API response will return an encrypted payment method capable
            * of being charged by a supported gateway after payer authorization
            *
            * @todo check with your gateway on the parameters to pass
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#gateway|PaymentMethodTokenizationSpecification}
            */
           const tokenizationSpecification = {
               type: 'PAYMENT_GATEWAY',
               parameters: {
                   'gateway': 'example',
                   'gatewayMerchantId': 'exampleGatewayMerchantId'
               }
           };

           /**
            * Describe your site's support for the CARD payment method and its required
            * fields
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#CardParameters|CardParameters}
            */
           const baseCardPaymentMethod = {
               type: 'CARD',
               parameters: {
                   allowedAuthMethods: allowedCardAuthMethods,
                   allowedCardNetworks: allowedCardNetworks
               }
           };

           /**
            * Describe your site's support for the CARD payment method including optional
            * fields
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#CardParameters|CardParameters}
            */
           const cardPaymentMethod = Object.assign(
               {},
               baseCardPaymentMethod,
               {
                   tokenizationSpecification: tokenizationSpecification
               }
           );

           /**
            * An initialized google.payments.api.PaymentsClient object or null if not yet set
            *
            * @see {@link getGooglePaymentsClient}
            */
           let paymentsClient = null;

           /**
            * Configure your site's support for payment methods supported by the Google Pay
            * API.
            *
            * Each member of allowedPaymentMethods should contain only the required fields,
            * allowing reuse of this base request when determining a viewer's ability
            * to pay and later requesting a supported payment method
            *
            * @returns {object} Google Pay API version, payment methods supported by the site
            */
           function getGoogleIsReadyToPayRequest() {
               return Object.assign(
                   {},
                   baseRequest,
                   {
                       allowedPaymentMethods: [baseCardPaymentMethod]
                   }
               );
           }

           /**
            * Configure support for the Google Pay API
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#PaymentDataRequest|PaymentDataRequest}
            * @returns {object} PaymentDataRequest fields
            */
           function getGooglePaymentDataRequest() {
               const paymentDataRequest = Object.assign({}, baseRequest);
               paymentDataRequest.allowedPaymentMethods = [cardPaymentMethod];
               paymentDataRequest.transactionInfo = getGoogleTransactionInfo();
               paymentDataRequest.merchantInfo = {
                   // @todo a merchant ID is available for a production environment after approval by Google
                   // See {@link https://developers.google.com/pay/api/web/guides/test-and-deploy/integration-checklist|Integration checklist}
                   // merchantId: '01234567890123456789',
                   merchantName: 'Custodians Of Oxford'
               };

               paymentDataRequest.callbackIntents = ["PAYMENT_AUTHORIZATION"];

               return paymentDataRequest;
           }

           /**
            * Return an active PaymentsClient or initialize
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/client#PaymentsClient|PaymentsClient constructor}
            * @returns {google.payments.api.PaymentsClient} Google Pay API client
            */
           function getGooglePaymentsClient() {
               if (paymentsClient === null) {
                   paymentsClient = new google.payments.api.PaymentsClient({
                       environment: 'TEST',
                       paymentDataCallbacks: {
                           onPaymentAuthorized: onPaymentAuthorized
                       }
                   });
               }
               return paymentsClient;
           }

           /**
            * Handles authorize payments callback intents.
            *
            * @param {object} paymentData response from Google Pay API after a payer approves payment through user gesture.
            * @see {@link https://developers.google.com/pay/api/web/reference/response-objects#PaymentData object reference}
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/response-objects#PaymentAuthorizationResult}
            * @returns Promise<{object}> Promise of PaymentAuthorizationResult object to acknowledge the payment authorization status.
            */
           function onPaymentAuthorized(paymentData) {
               return new Promise(function (resolve, reject) {
                   // handle the response
                   processPayment(paymentData)
                       .then(function () {
                           resolve({ transactionState: 'SUCCESS' });
                       })
                       .catch(function () {
                           resolve({
                               transactionState: 'ERROR',
                               error: {
                                   intent: 'PAYMENT_AUTHORIZATION',
                                   message: 'Insufficient funds, try again. Next attempt should work.',
                                   reason: 'PAYMENT_DATA_INVALID'
                               }
                           });
                       });
               });
           }

           /**
            * Initialize Google PaymentsClient after Google-hosted JavaScript has loaded
            *
            * Display a Google Pay payment button after confirmation of the viewer's
            * ability to pay.
            */
           function onGooglePayLoaded() {
               const paymentsClient = getGooglePaymentsClient();
               paymentsClient.isReadyToPay(getGoogleIsReadyToPayRequest())
                   .then(function (response) {
                       if (response.result) {
                           addGooglePayButton();
                       }
                   })
                   .catch(function (err) {
                       // show error in developer console for debugging
                       console.error(err);
                   });
           }

           /**
            * Add a Google Pay purchase button alongside an existing checkout button
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#ButtonOptions|Button options}
            * @see {@link https://developers.google.com/pay/api/web/guides/brand-guidelines|Google Pay brand guidelines}
            */
           function addGooglePayButton() {
               const paymentsClient = getGooglePaymentsClient();
               const button =
                   paymentsClient.createButton({ onClick: onGooglePaymentButtonClicked });
               document.getElementById('container').appendChild(button);
           }

           /**
            * Provide Google Pay API with a payment amount, currency, and amount status
            *
            * @see {@link https://developers.google.com/pay/api/web/reference/request-objects#TransactionInfo|TransactionInfo}
            * @returns {object} transaction info, suitable for use as transactionInfo property of PaymentDataRequest
            */
           function getGoogleTransactionInfo() {
               var cost = document.getElementById('MainContent_totalAmount').textContent;
               return {
                   countryCode: 'US',
                   currencyCode: "USD",
                   totalPriceStatus: "ESTIMATED",
                   totalPrice: cost,
                   totalPriceLabel: "Total"
               };
           }


           /**
            * Show Google Pay payment sheet when Google Pay payment button is clicked
            */
           function onGooglePaymentButtonClicked() {
               const paymentDataRequest = getGooglePaymentDataRequest();
               paymentDataRequest.transactionInfo = getGoogleTransactionInfo();

               const paymentsClient = getGooglePaymentsClient();
               paymentsClient.loadPaymentData(paymentDataRequest);
           }

           let attempts = 0;
           /**
            * Process payment data returned by the Google Pay API
            *
            * @param {object} paymentData response from Google Pay API after user approves payment
            * @see {@link https://developers.google.com/pay/api/web/reference/response-objects#PaymentData|PaymentData object reference}
            */
           function processPayment(paymentData) {
               return new Promise(function (resolve, reject) {
                   setTimeout(function () {
                       // @todo pass payment token to your gateway to process payment
                       paymentToken = paymentData.paymentMethodData.tokenizationData.token;

                       if (attempts++ % 2 == 0) {
                           reject(new Error('Every other attempt fails, next one should succeed'));
                       } else {
                           resolve({});
                       }
                   }, 500);
               });
           }
       </script>
       <script>
</script>

     </asp:Content>
    
