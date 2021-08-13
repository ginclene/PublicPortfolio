using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CustodiansOfOxford
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) Response.Redirect("Account/Login.aspx");
            cleanboxes.Visible = false;
            partyboxes.Visible = false;
            cleaningNotice.Visible = false;
            
        }

        //adds the service to the cart
        public void AddtoCart_Click(object sender, EventArgs e)
        {
            string id = SubID.Value;
            int idd = Int32.Parse(id);
            System.Diagnostics.Debug.WriteLine(SubID.Value);
            System.Diagnostics.Debug.WriteLine("activating the button");
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                if(r.serviceID == idd)
                {
                    int serviceid = r.serviceID;
                    string name = r.serName;
                    string img = r.serImage;
                    string type = r.serType;
                    string description = r.serDescription;
                    double cost = r.serBaseCost;
                    string BaseCost = cost.ToString();
                    float BaseCost2 = float.Parse(BaseCost);
                    int min = r.minLenOfService;
                    int max = r.maxLenOfService;
                    CartItem item = new CartItem(name, type, serviceid, description, img, BaseCost2, min, max);
                    Universal.list.Add(item);
                }
            }

        }

        // Loads all services from all services button
        protected void loadAllServices(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("made it to loadAllService");
            string capitalized = "All Services";
            string data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
                data += "<th>Base Cost ($)</th><th>Description</th><th>Select Service</th></tr></thead><tbody>";
                foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
                {   
                    data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serDescription + "</td><td>" +
                            "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";

            }
            lblData.Text = data + "</tbody></table>";
            cleanboxes.Visible = false;
            cleaningNotice.Visible = false;
        }

        //loads all services by default, not currently in use
        protected void loadAllServices()
        {
            string capitalized = "All Services";
            string data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
            data += "<th>Base Cost ($)</th><th>Description</th><th>Select Service</th></tr></thead><tbody>";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serDescription + "</td><td>" +
                       "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";

            }
            lblData.Text = data + "</tbody></table>";

        }

        //loads all cleaning services
        private void loadCleaningServices(String type)
        {
            string capitalized = char.ToUpper(type[0]) + type.Substring(1) + " Services";
            string data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
            data += "<th>Description</th><th>Base Cost ($)</th><th>Select Service</th></tr></thead><tbody>";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                if ((r.serType).Equals(type) || (r.serType).Equals("other"))
                {
                    data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serDescription + "</td><td>" + r.serBaseCost + "</td><td id='selectedDate_" + r.serviceID + "'></td><td>" +
                        "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";
                }
            }
            lblData.Text = "";
            cleanboxes.Visible = true;
            cleaningNotice.Visible = true;
        }

        //loads all party services
        private void loadPartyServices(String type)
        {
            string capitalized = char.ToUpper(type[0]) + type.Substring(1) + " Services";
            string data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
                data += "<th>Base Cost ($)</th><th>Description</th><th>Select Service</th></tr></thead><tbody>";
                foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
                {
                    if ((r.serType).Equals(type))
                    {
                        data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serDescription + "</td><td>" +
                        "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";
                }
                }
            lblData.Text = "";
            partyboxes.Visible = true;
        }

        //identifies if user is selecting cleaning or party services
        protected void btnGetAllServices_Click(object sender, EventArgs e)
        {
            Button whichButton = (Button)sender;
            string type = whichButton.ID;
            if (type.Equals("cleaning", StringComparison.OrdinalIgnoreCase))
            {
                loadCleaningServices(type);
            } else
            {
                loadPartyServices(type);
            }
        }

        //handles checkboxes for cleaning services
        protected void CheckRoom(object sender, EventArgs e)
        {
            CheckBox whichbox = (CheckBox)sender;
            string type = whichbox.ID;
            string capitalized = char.ToUpper(type[0]) + type.Substring(1) + " Services";
            string data = "";
            if (whichbox.Checked)
                {
                data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
                data += "<th>Base Cost ($)</th><th>Description</th><th>Select Service</th></tr></thead><tbody>";
                foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
                    {
                        if ((r.serName).Contains(type) || (r.serName).Equals(type, StringComparison.OrdinalIgnoreCase))
                        {
                            data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serDescription + "</td><td>" +
                                "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";
                    }
                    }
                    lblData.Text += data + "</tbody></table>";
                }
                else
            {
                if(lblData.Text.Contains(capitalized))
                {
                    string dataReplacer = "";
                    int checkfrom = lblData.Text.IndexOf(capitalized) + 1;
                    int removelength = lblData.Text.IndexOf("<h4>", checkfrom) - lblData.Text.IndexOf(capitalized) + 4;
                    if(removelength < 1)
                    {
                        removelength = lblData.Text.IndexOf("</table>", checkfrom) - lblData.Text.IndexOf(capitalized) + 8;
                    }
                    System.Diagnostics.Debug.WriteLine(lblData.Text);
                    string final = lblData.Text.Substring(lblData.Text.IndexOf(capitalized), removelength);
                    dataReplacer = lblData.Text.Remove(lblData.Text.IndexOf(capitalized), removelength);
                    lblData.Text = dataReplacer;
                }
            }
            cleanboxes.Visible = true;
            cleaningNotice.Visible = true;
        }

        //handles checkboxes for party services
        protected void CheckParty(object sender, EventArgs e)
        {
            CheckBox whichbox = (CheckBox)sender;
            string type = whichbox.ID;
            string capitalized = char.ToUpper(type[0]) + type.Substring(1) + " Services";
            string data = "";
            if (whichbox.Checked)
            {
                data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
                data += "<th>Base Cost ($)</th><th>Description</th><th>Select Service</th></tr></thead><tbody>";
                foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
                {
                    if ((r.serName).Contains(type) || (r.serName).Equals(type, StringComparison.OrdinalIgnoreCase))
                    {
                        data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serDescription + "</td><td>" +
                            "<button type='button' class='btn btn-default' id = " + r.serviceID + " runat = 'server' onclick = 'AddtoCart_Click(" + r.serviceID + ")'>Add to Cart </button> <p id='status" + r.serviceID + "'></p></td></tr>";
                    }
                }
                lblData.Text += data + "</tbody></table>";
            }
            else
            {
                if (lblData.Text.Contains(capitalized))
                {
                    string dataReplacer = "";
                    int checkfrom = lblData.Text.IndexOf(capitalized) + 1;
                    int removelength = lblData.Text.IndexOf("<h4>", checkfrom) - lblData.Text.IndexOf(capitalized) + 4;
                    if (removelength < 1)
                    {
                        removelength = lblData.Text.IndexOf("</table>", checkfrom) - lblData.Text.IndexOf(capitalized) + 8;
                    }
                    System.Diagnostics.Debug.WriteLine(lblData.Text);
                    string final = lblData.Text.Substring(lblData.Text.IndexOf(capitalized), removelength);
                    dataReplacer = lblData.Text.Remove(lblData.Text.IndexOf(capitalized), removelength);
                    lblData.Text = dataReplacer;
                }
            }
            partyboxes.Visible = true;
        }
    }
}
