<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="CustodiansOfOxford.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src="Scripts/moment-with-locales.js"></script>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/moment.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/bootstrap-datetimepicker.js"></script>
    <link href="Content/bootstrap-datetimepicker.css" rel="stylesheet" />

    <h2>Services</h2>
    <br />
    <!--3 primary buttons to view services-->
    <div>
        <asp:Button ID="cleaning" runat="server" Text="Cleaning Services" CssClass="btn btn-primary" OnClick="btnGetAllServices_Click" />
        <asp:Button ID="party" runat="server" Text="Party Services" CssClass="btn btn-primary" OnClick="btnGetAllServices_Click" />
        <asp:Button ID="all" runat ="server" Text="All Services" CssClass="btn btn-primary" OnClick="loadAllServices" />
        
        <br />
            <!--checkboxes for cleaning services-->
        <div id="cleanboxes" runat="server">
        <asp:CheckBox ID="Bedroom" runat="server" Text="Bedrooms" OnCheckedChanged="CheckRoom" AutoPostBack="True"/>
        <asp:CheckBox ID="Kitchen" runat="server" Text="Kitchens" OnCheckedChanged="CheckRoom" AutoPostBack="True" />
        <asp:CheckBox ID="Living" runat="server" Text="Living Rooms" OnCheckedChanged="CheckRoom" AutoPostBack="True" />
        <asp:CheckBox ID="Bath" runat="server" Text="Bathrooms" OnCheckedChanged="CheckRoom" AutoPostBack="True"/>
        <asp:CheckBox ID="Office" runat="server" Text="Offices" OnCheckedChanged="CheckRoom" AutoPostBack="True"/>
        </div>
        <!--checkboxes for party services-->
        <div id="partyboxes" runat="server">
        <asp:CheckBox ID="Giant" runat="server" Text="GIANT stuff" OnCheckedChanged="CheckParty"  AutoPostBack="True"/>
        <asp:CheckBox ID="ball" runat="server" Text="Balls" OnCheckedChanged="CheckParty" AutoPostBack="True" />
        <asp:CheckBox ID="machine" runat="server" Text="Machines" OnCheckedChanged="CheckParty" AutoPostBack="True" />
        <asp:CheckBox ID="Laser" runat="server" Text="Lasers" OnCheckedChanged="CheckParty" AutoPostBack="True" />
        <asp:CheckBox ID="Sack" runat="server" Text="Sacks" OnCheckedChanged="CheckParty" AutoPostBack="True" />

        </div>
        <br />
        <!--All services will be stored in here-->
        <asp:Label ID="lblData" runat="server" Text=""></asp:Label>
    </div>
    <br />
    <br />
    <!--cleaning notice for cleaning services-->
    <div id="cleaningNotice" runat="server">
        <p>
            Please notice the difference between the top bullet points that say <strong>“General Clean”</strong> and the <strong>“Deeper Level Items Done by Request”</strong> bullet points. If you are looking for a deeper level cleaning this will require extra time, but will also insure your home sparkles when we are finished! Depending on the level of service you want, and your budget, we come up with an approximate range of labor hours that your home will need.
        </p>
        <br />
        <p>
            Whether you are signing up for a one time clean or recurring services, we prefer to do a complimentary in home site visit. From there we build a customized estimate that we will refer to as a “Spec Sheet”. This information will go over each area of your home and will explain what needs to be cleaned and how long the area is estimated to take. It will also go over things like a preferred day of the week, if you are morning or afternoon sensitive, entry information, where we take the trash out if you have any product sensitives and much more! All this information will get typed up, saved in your system, and emailed over to you for review prior to your scheduled clean.
        </p>
        <br />
        <p>
            <strong><u>If you are signing up for a one time clean -</u></strong> We will save your customized Spec Sheet on file. Any time you are looking to get another one time clean or potentially get on our recurring schedule, we can easily access your home information and send you a fairy!
        </p>
        <br />
        <p>
            <strong><u>If you are signing up for recurring services -</u></strong> We save your Spec Sheet on file and give it to your preferred fairy team before each clean to use as a reference. There are many benefits to signing up for recurring services as opposed to just one time cleans periodically. The two main benefits are you getting priority when you need to reschedule your recurring visit for whatever reason over call in clients, you also get the same fairy each time of services. As your custodians get to know you and your home, the service quality improves over time!
        </p>
        <br />
        <p>
            <strong>The initial clean will likely take a little longer than subsequent cleans after that. This is for several reason, but mainly two:</strong>
            <ol>
                <li>Normally it takes our staff a clean or two to fully accustomed to your home. We rely heavily on feedback from our customers when we are first starting our new relationship. Having open communication up front ensures your expectations are not only met but hopefully exceeded!
                </li>
                <li>After the initial cleaning, when we come back to clean again there should not be nearly as much build up as the first visit. As time goes on and your custodians get to know your home, your required hours may continue to decrease and ultimately cost you less.
                </li>
            </ol>
            If you want to have deeper level items done each time of service, please mention that to the office so we can incorporate it in your estimate. If you do not need it done every time, we encourage you to add on a deeper level clean on a quarterly basis. 
        </p>
    </div>


    
    <div id="hiddenstuff">
        <asp:HiddenField runat="server" ID="SubID" Value="" />
        <asp:Button runat="server" ID="hiddenButton" ClientIDMode="Static" Text="" style="display:none;" OnClick="AddtoCart_Click" />
    </div>

    <script>
        function AddtoCart_Click(id) {
            var status = "status" + id;
            console.log("found cart function");
            console.log("the id is " + id);
            document.getElementById("<%=SubID.ClientID%>").value = id;
            document.getElementById("<%=hiddenButton.ClientID%>").click();
            document.getElementById(status).innerHTML = "Added to cart";
        }
        
    </script>



</asp:Content>
