<%@ Page Title="Subscription" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Subscription.aspx.cs" Inherits="CustodiansOfOxford.Subscription" %>

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

        <div class="center">
            <h1>
                Custodian's Subscriptions
            </h1>
            
        </div>
    
    <div>
        <asp:Button ID="subscriptions" runat="server" Text="All Subscription Services" CssClass="btn btn-primary" OnClick="btnGetAllSubscriptions_Click" AutoPostBack="True"/>
        <br />
        <asp:GridView ID="subscriptionGrid" runat="server"></asp:GridView>
        <br />
        <asp:Label ID="lblData" runat="server" Text=""></asp:Label>
        
    </div>

    <div id="hiddenstuff">
        <asp:HiddenField runat="server" ID="SubID" Value="" />
        <asp:Button runat="server" ID="hiddenButton" ClientIDMode="Static" Text="" style="display:none;" OnClick="AddtoCart_Click" />
    </div>
    <script>
        var selectedID = null;
        function AddtoCart_Click(id) {
            var status = "status" + id;
            console.log("found cart function");
            console.log("the id is " + id);
            document.getElementById("<%=SubID.ClientID%>").value = id;
            document.getElementById("<%=hiddenButton.ClientID%>").click();
            document.getElementById(status).innerHTML = "Added to cart";
        }
        function saveServiceDate() {
            console.log("made it to saveServiceDate");
            $('#selectedDate_' + selectedID).html($('#selectdate').val());
            var date = $('#selectdate').val();
            console.log(date);
            $.ajax({
                type: "PUT",
                url: "About.aspx/About.aspx.cs/SaveOneDate",
                data: '{date: "' + date + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                failure: function (response) {
                    console.log("failure due to " + response.d);
                }
            });
        }
    </script>

</asp:Content>
