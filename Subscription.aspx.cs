using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.SqlClient;


namespace CustodiansOfOxford
{
    public partial class Subscription : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) Response.Redirect("Account/Login.aspx");
        }
        public void AddtoCart_Click(object sender, EventArgs e)
        {
            string id = SubID.Value;
            int idd = Int32.Parse(id);
            System.Diagnostics.Debug.WriteLine(SubID.Value);
            System.Diagnostics.Debug.WriteLine("activating the button");
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string query = "SELECT * FROM subService Where serviceID = " + idd;
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.HasRows)
                    {

                        while (reader.Read())
                        {
                            int id2 = reader.GetInt32(0);
                            string name = reader.GetString(1);
                            string type = reader.GetString(2);
                            string imgepath = reader.GetString(3);

                            string description = reader.GetString(4);
                            double cost = reader.GetDouble(5);
                            string weeklyCost = cost.ToString();
                            float weeklyCost2 = float.Parse(weeklyCost);
                            System.Diagnostics.Debug.WriteLine("creating cart item...");
                            System.Diagnostics.Debug.WriteLine(id + " " + name + " " + type + " " + imgepath
                                + " " + description + " " + cost);
                            CartItem item = new CartItem(name, type, id2, description, imgepath, weeklyCost2);
                            System.Diagnostics.Debug.WriteLine("adding cart item to cart...");
                            Universal.list.Add(item);
                            System.Diagnostics.Debug.WriteLine("item added to cart");
                            System.Diagnostics.Debug.WriteLine("item with name: " + name + "was added to the cart with subscription status: " + item.subscription);

                        }
                    }
                }
                connection.Close();
                connection.Dispose();
                
            }
        }

        protected void btnGetAllSubscriptions_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("made it to button method");
            string title = "Subscription Services";
            string data = "<h4>" + title + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
            data += "<th>Description</th><th>Base Cost ($)</th><th> Select Service</th></tr></thead><tbody>";
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string query = "SELECT * FROM subService";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while(reader.HasRows)
                    {
                        
                        while(reader.Read())
                        {
                            int id = reader.GetInt32(0);
                            string name = reader.GetString(1);
                            string type = reader.GetString(2);
                            string imgepath = reader.GetString(3);
                            
                            string description = reader.GetString(4);
                            double cost = reader.GetDouble(5);
                            System.Diagnostics.Debug.WriteLine(id + " " + name + " " + type + " " + imgepath
                                + " " + description + " " + cost);
                            data += "<tr><td><img width='100' height='100' src='" + imgepath + "'" + name + "' /></td><td>" + name + "</td><td>"
                                + description + "</td><td>" + cost + "</td><td>" +
                            "<button type='button' class='btn btn-default' id = " + id + " runat = 'server' onclick = 'AddtoCart_Click(" + id + ")'>Add to Cart </button> <p id='status" + id + "'></p></td></tr>";  
                        }
                                              reader.NextResult();
                    }
                    lblData.Text = data + "</tbody></table>";
                }
                connection.Close();
                connection.Dispose();
            }
        }
        protected void SaveTheDates(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("the date is: we don't know");
            System.Diagnostics.Debug.WriteLine("$(`#datetimepicker5`).show();");
            string data = "";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                data += "id='selectedDate_" + r.serviceID + "'>" +
                    "<button type='button' class='btn btn-default' onclick='selectedID=" + r.serviceID + "; $(`#datetimepicker5`).show();' data-toggle='modal' data-target='#myModal' data-dismiss='modal'>Select Date</button></td></tr>";

            }

        }
        public void SaveOneDate(string date)
        {
            System.Diagnostics.Debug.WriteLine("made it to SaveOneDate");
            System.Diagnostics.Debug.WriteLine("the date is: " + date);
        }

        
    }
}