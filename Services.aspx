<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Services.aspx.cs" Inherits="CustodiansOfOxford.Services" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src="Scripts/moment-with-locales.js"></script>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/moment.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/bootstrap-datetimepicker.js"></script>
    <link href="Content/bootstrap-datetimepicker.css" rel="stylesheet" />

    <!--
        Page for admins only to update services
        Can add, remove, and change services
    -->
    <h1>Services</h1>
    <br />

    <!-- Block to add new service -->    
    <div id="newService">
        <h2>Add a Service</h2> <br />
        <!-- New Service Name and Type -->
        <label for="ServiceName"> Service Name: </label>
        <input type="text" class="form-control" name="ServiceName" id="ServiceName" placeholder="Enter name of service" runat="server" />
        <input type="radio" name="serType" id="Cleaning" runat="server" value="Cleaning" />
        <label class="form-check-label" for="Cleaning"> Cleaning </label>
        <input type="radio" name="serType" id="Party" runat="server" value="Party" />
        <label class="form-check-label" for="Party"> Party </label>
        <input type="radio" name="serType" id="Other" runat="server" value="Other" />
        <label class="form-check-label" for="Other"> Other </label>
         <br />
        <!-- New Service Image -->
        <label for="serImage"> Image: </label>
        <input type="file" name="serImage" runat="server" id="serImage" />
        <br />
        <!-- New Service Description -->
        <input type="text" class="form-control" name="serDescription" id="serDescription" placeholder="Enter a Description of the service" runat="server" />
        <br />
        <!-- New Service Cost -->
        <label for="baseCost"> Base Cost: </label>
        <input type="number" name="baseCost" id="baseCost" runat="server" />
        <!-- New Service Time properties -->
        <label for="minLength"> Minimum time of service: </label>
        <input type="number" name ="minLength" id="minLength" runat="server" />
        <label for="maxLength"> Maximum time for service: </label>
        <input type="number" name ="maxLength" id="maxLength" runat="server" />
        <br />
        <!-- Submit Button -->
        <asp:Button ID="submit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="addService" />
    </div>
    <br />
    <br />
    <!-- Remove Service Block -->
    <div id="RemoveService">
        <h2> Remove a Service</h2><br />

        <!-- Select Service to be Removed -->
        Find the Service:
        <asp:DropDownList ID="ServiceNameDropDown" AutoPostBack="True" OnSelectedIndexChanged="viewSingleService" runat="server">
        </asp:DropDownList>
        <!-- Display Selected Services to be removed -- Can be Multiple -->
        <asp:Label ID="ServiceRemovalSelection" runat="server" Text=""></asp:Label>
        <!-- Submit Button -->
        <asp:Button ID="submitR" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="ConfirmDeletion" />
        <br />
    </div>
    <!-- Confirm Deletion Prompt After Submit -->
    <div id="Confirmation" runat="server">
        Confirm Deletion
        <asp:Button ID="Confirm" runat="server" Text="Yes" CssClass="btn btn-primary" OnClick="deleteService" />
        <asp:Button ID="Deny" runat="server" Text="No" CssClass="btn btn-primary" OnClick="CancelDeletion" />
    </div>
    <br />
    <br />
    <!-- Find Service to Change -->
    <div id="FindService">
       <h2> Change a Service </h2>

        Find the Service:
        <asp:DropDownList ID="ServiceNameF" AutoPostBack="True" OnSelectedIndexChanged="FindService" runat="server">
            
        </asp:DropDownList>
        <br />
        <asp:Label ID="lblData" runat="server" Text=""></asp:Label>
    </div>

    <!-- Select Attribute of Selected Service to be Changed -->
    <div id="ChangeService">

        Select the field you would like to change:
        <asp:DropDownList ID="fieldchanged" AutoPostBack="True" OnSelectedIndexChanged="ChangeSelection" runat="server">
            <asp:ListItem Selected="True" Value="serName"> Name </asp:ListItem>
            <asp:ListItem Value="serType"> Type </asp:ListItem>
            <asp:ListItem Value="serImage"> Image </asp:ListItem>
            <asp:ListItem Value="serDescription"> Description </asp:ListItem>
            <asp:ListItem Value="serBaseCost"> Base Cost </asp:ListItem>
            <asp:ListItem Value="minLenOfService"> Minimum Service Length </asp:ListItem>
            <asp:ListItem Value="maxLenOfService"> Maximum Service Length </asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="servicefield" runat="server" Text=""></asp:Label>
    </div>

    <!-- Change Selected Attribute -->
    <div id="ChangeName" runat="server">
        <label for='NewValue'> New Service Name: </label>
        <input type = 'text' class='form-control' name='ServiceNameC' id='NewName' placeholder='Enter new name of service' runat='server' />
    </div>
    <div id="ChangeType" runat="server">
        <input type='radio' name='serType' id='CleaningC' runat='server' value='Cleaning' />
        <label class='form-check-label' for='CleaningC'> Cleaning</label>
        <input type = "radio" name="serType" id="PartyC" runat="server" value="Party" />
        <label class="form-check-label" for="Party"> Party</label>
        <input type = "radio" name="serType" id="OtherC" runat="server" value="Other" />
        <label class="form-check-label" for="OtherC"> Other</label>
    </div>
    <div id="ChangeImg" runat="server">
        <label for='serImageC'> New Image: </label>
        <input type = 'file' name = 'serImageC' runat = 'server' id = 'NewImage' /> 
    </div>
    <div id="ChangeDescription" runat="server">
        <label for='NewValue'> New Service Description: </label>
        <input type = 'text' class='form-control' name='ServiceDescriptionC' id='NewDescription' placeholder='Enter new Description' runat='server' />
    </div>
    <div id="ChangeBaseCost" runat="server">
        <label for='NewValue'> New Base Cost: </label>
        <input type = 'number' name = 'baseCostC' id = 'NewCost' runat = 'server' /> 
    </div>
    <div id="ChangeMin" runat="server">
        <label for='NewValue'> New Minimum Length: </label>
        <input type = 'number' name = 'minLenC' id = 'NewMin' runat = 'server' /> 
    </div>
    <div id="ChangeMax" runat="server">
        <label for='maxLenC'> New Maximum Length: </label>
        <input type = 'number' name = 'maxLenC' id = 'NewMax' runat = 'server' /> 
    </div>
    <!-- Submit Changes -->
    <div id="ChangeButtonDiv" runat="server">
      <asp:Button ID="ChangeButton" runat="server" Text="Submit Changes" CssClass="btn btn-primary" OnClick="updateService" />
    </div>

    <br />
    <h1>Subscriptions</h1>

    <br />

    <!-- Add Subscription -->
    <h2>Add a Subscription</h2>
    <div id="newSubscription">
    <label for="SubName"> Service Name: </label>
        <input type="text" class="form-control" name="SubName" id="SubName" placeholder="Enter name of subscription" runat="server" />
        <input type="radio" name="subType" id="subCleaning" runat="server" value="Cleaning" />
        <label class="form-check-label" for="subCleaning"> Cleaning </label>
        <input type="radio" name="subType" id="subParty" runat="server" value="Party" />
        <label class="form-check-label" for="subParty"> Party </label>
        <input type="radio" name="subType" id="subOther" runat="server" value="Other" />
        <label class="form-check-label" for="subOther"> Other </label>
         <br />
        <label for="serImage"> Image: </label>
        <input type="file" name="subImage" runat="server" id="subImg" />
        <br />
        <input type="text" class="form-control" name="subDescription" id="subDescription" placeholder="Enter a Description of the subscription" runat="server" />
        <br />
        <label for="weeklyCost"> Weekly Cost: $</label>
        <input type="number" name="weeklyCost" id="weeklyCost" runat="server" />
        <asp:Button ID="subsubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="addSubscription" />
    </div>
    <br />
    <br />

    <!-- View Currently Booked Services -->
    <div id="bookedServices">
        <h1>Booked Services</h1>
        <asp:GridView ID="BookedGrid" runat="server"></asp:GridView>
    </div>
    
</asp:Content>
