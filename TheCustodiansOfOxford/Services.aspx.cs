using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CustodiansOfOxford.dsTableAdapters;

namespace CustodiansOfOxford
{
    public partial class Services : System.Web.UI.Page
    {
        // Checks User and populates page
        protected void Page_Load(object sender, EventArgs e)
        {
         //   if (!User.IsInRole("Admin")) Response.Redirect("Default.aspx");
            ChangeName.Visible = false;
            ChangeDescription.Visible = false;
            ChangeType.Visible = false;
            ChangeMax.Visible = false;
            ChangeMin.Visible = false;
            ChangeImg.Visible = false;
            ChangeBaseCost.Visible = false;
            Confirmation.Visible = false;
            viewAllServiceNames();
            viewAllBookings();
        }

        // Function to handle adding a service
        protected void addService(object sender, EventArgs e)
        {
            // new service type
            string serviceType = "";
            if (Cleaning.Checked)
            {
                serviceType = "cleaning";
            }
            else if (Party.Checked)
            {
                serviceType = "party";
            }
            else
            {
                serviceType = "other";
            }

            // new service image
            string imageLocation = "pictures/" + serImage.Value;

            // insert new service into database
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string strQuery = "INSERT INTO tblService (serName, serType, serImage, serDescription, serBaseCost," +
                    " minLenOfService, maxLenOfService)" +
                    " VALUES (@ServiceName, @serviceType, @serImage, @serDescription, @baseCost, @minLength, @maxLength)";
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    command.Parameters.AddWithValue("@ServiceName", ServiceName.Value);
                    command.Parameters.AddWithValue("@serviceType", serviceType);
                    command.Parameters.AddWithValue("@serImage", imageLocation);
                    command.Parameters.AddWithValue("@serDescription", serDescription.Value);
                    command.Parameters.AddWithValue("@baseCost", Int32.Parse(baseCost.Value));
                    command.Parameters.AddWithValue("@minLength", Int32.Parse(minLength.Value));
                    command.Parameters.AddWithValue("@maxLength", Int32.Parse(maxLength.Value));
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    if (result < 0)
                    {
                        System.Diagnostics.Debug.WriteLine("whats the problem bobby");
                    }
                    
                }
                connection.Close();
                connection.Dispose();
            }
            string folderPath = Server.MapPath("~/pictures/");
            string fileName = serImage.Value;
            string imagePath = folderPath + fileName;
        }

        // function to handle deleting a service
        protected void deleteService(object sender, EventArgs e)
        {
            // retrieve selected service from dropdown
            string name = ServiceNameDropDown.SelectedValue;

            // remove selected service from database
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string strQuery = "Delete From tblService Where serName='" + name + "'";
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    // prints if error
                    if (result < 0)
                    {
                        System.Diagnostics.Debug.WriteLine("whats the problem bobby");
                    }       
                }
                connection.Close();
                connection.Dispose();
            }
        }

        // retrieves all service names from database
        protected void viewAllServiceNames()
        {
            string allServices = "";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                allServices = r.serName;
                ServiceNameDropDown.Items.Add(allServices);
                ServiceNameF.Items.Add(allServices);
            }
        }

        // retrieves a single selected service
        protected void viewSingleService(object sender, EventArgs e)
        {
            string name = ServiceNameDropDown.SelectedValue;
            string capitalized = char.ToUpper(name[0]) + name.Substring(1);
            string data = "";
            data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service name</th>";
            data += "<th>Base Cost ($)</th><th>Service Type</th><th>Service Description</th><th>Min Length</th><th>Max Length</th></tr></thead><tbody>";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                if ((r.serName).Equals(name, StringComparison.OrdinalIgnoreCase))
                {
                    data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serType + "</td><td>"
                        + r.serDescription + "</td><td>" + r.minLenOfService + "</td><td>" + r.maxLenOfService + "</td></tr>";
                }
            }
            ServiceRemovalSelection.Text += data + "</tbody></table>";
        }

        // prompts the user to confirm deletion
        protected void ConfirmDeletion(object sender, EventArgs e)
        {
            Confirmation.Visible = true;
        }

        // hides confirmation prompt on cancel
        protected void CancelDeletion(object sender, EventArgs e)
        {
            Confirmation.Visible = false;
        }

        // finds a service in the database
        protected void FindService(object sender, EventArgs e)
        {
            string name = ServiceNameF.SelectedValue;
            string capitalized = char.ToUpper(name[0]) + name.Substring(1);
            string data = "";
            data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service name</th>";
            data += "<th>Base Cost ($)</th><th>Service Type</th><th>Service Description</th><th>Min Length</th><th>Max Length</th></tr></thead><tbody>";
            foreach (ds.GetServicesRowRow r in (new dsTableAdapters.GetServicesRowTableAdapter()).GetData())
            {
                if ((r.serName).Equals(name, StringComparison.OrdinalIgnoreCase))
                {
                    data += "<tr><td><img width='100' height='100' src='" + r.serImage + "'" + r.serName + "' /></td><td>" + r.serName + "</td><td>" + r.serBaseCost + "</td><td>" + r.serType + "</td><td>"
                        + r.serDescription + "</td><td>" + r.minLenOfService + "</td><td>" + r.maxLenOfService + "</td></tr>";
                }
            }
            lblData.Text += data + "</tbody></table>";
        }

        // handles changing a service
        protected void ChangeSelection(object sender, EventArgs e)
        {
            string fieldToBeChanged = fieldchanged.SelectedValue;
            // displays selected field to be changed
            if(fieldToBeChanged.Equals("serName")) {
                ChangeName.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("serDescription"))
            {
                ChangeDescription.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("serBaseCost"))
            {
                ChangeBaseCost.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("minLenOfService"))
            {
                ChangeMin.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("maxLenOfService"))
            {
                ChangeMax.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("serImage"))
            {
                ChangeImg.Visible = true;
                servicefield.Text = "";
            } else if(fieldToBeChanged.Equals("serType"))
            {
                ChangeType.Visible = true;
                servicefield.Text = "";
            }
            ChangeButtonDiv.Visible = true;
        }

        // updates selected service
        protected void updateService(object sender, EventArgs e)
        {
            string NameOfServiceToBeChanged = ServiceNameF.SelectedValue;
            string FieldToBeChanged = fieldchanged.SelectedValue;
            string ValueToBeChanged;
            string strQuery = "";
            // updates selected field in database
            if (FieldToBeChanged.Equals("serName"))
            {
                ValueToBeChanged = NewName.Value;
                 strQuery = "Update tblService Set serName='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";
            }
            else if (FieldToBeChanged.Equals("serDescription"))
            {
                ValueToBeChanged = NewDescription.Value;
                 strQuery = "Update tblService Set serDescription='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";
            }
            else if(FieldToBeChanged.Equals("serBaseCost"))
            {
                ValueToBeChanged = NewCost.Value;
                 strQuery = "Update tblService Set serBaseCost='" + Int32.Parse(ValueToBeChanged) + "' Where serName='" + NameOfServiceToBeChanged + "'";
            }
            else if(FieldToBeChanged.Equals("minLenOfService"))
            {
                ValueToBeChanged = NewMin.Value;
                 strQuery = "Update tblService Set minLenOfService='" + Int32.Parse(ValueToBeChanged) + "' Where serName='" + NameOfServiceToBeChanged + "'";
            }
            else if(FieldToBeChanged.Equals("maxLenOfService"))
            {
                ValueToBeChanged = NewMax.Value;
                strQuery = "Update tblService Set maxLenOfService='" + Int32.Parse(ValueToBeChanged) + "' Where serName='" + NameOfServiceToBeChanged + "'";

            }
            else if(FieldToBeChanged.Equals("serImage"))
            {
                ValueToBeChanged = "~pictures/" + NewImage.Value;
                strQuery = "Update tblService Set serImage='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";

            }
            else if(FieldToBeChanged.Equals("serType"))
            {
                if (Cleaning.Checked)
                {
                    ValueToBeChanged = "cleaning";
                    strQuery = "Update tblService Set serType='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";

                }
                else if (Party.Checked)
                {
                    ValueToBeChanged = "party";
                    strQuery = "Update tblService Set serType='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";

                }
                else
                {
                    ValueToBeChanged = "other";
                    strQuery = "Update tblService Set serType='" + ValueToBeChanged + "' Where serName='" + NameOfServiceToBeChanged + "'";

                }
            }
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    if (result < 0)
                    {
                        System.Diagnostics.Debug.WriteLine("whats the problem bobby");
                    }
                }
                connection.Close();
                connection.Dispose();
            }
        }

        // adds subscription service to database
        protected void addSubscription(object sender, EventArgs e)
        {
            // sets types
            string subscriptionType = "";
            if (subCleaning.Checked)
            {
                subscriptionType = "cleaning";
            }
            else if (subParty.Checked)
            {
                subscriptionType = "party";
            }
            else
            {
                subscriptionType = "other";
            }
            // sets image
            string imageLocation = "pictures/" + serImage.Value;
            // adds to database
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string strQuery = "INSERT INTO subService (serName, serType, serImage, serDescription, serWeeklyCost)" +
                    " VALUES (@SubName, @subType, @subImage, @subDescription, @subWeeklyCost)";
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    command.Parameters.AddWithValue("@SubName", SubName.Value);
                    command.Parameters.AddWithValue("@subType", subscriptionType);
                    command.Parameters.AddWithValue("@subImage", subImg);
                    command.Parameters.AddWithValue("@subDescription", subDescription.Value);
                    command.Parameters.AddWithValue("@subWeeklyCost", Int32.Parse(weeklyCost.Value));
                    connection.Open();
                    int result = command.ExecuteNonQuery();
                    if (result < 0)
                    {
                        System.Diagnostics.Debug.WriteLine("whats the problem bobby");
                    }

                }
                connection.Close();
                connection.Dispose();
            }
            string folderPath = Server.MapPath("~/pictures/");
            string fileName = serImage.Value;
            string imagePath = folderPath + fileName;
        }

        // displays all service bookings
        protected void viewAllBookings()
        {
            // retrieves bookings from database
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string strQuery = "SELECT * FROM tblDates";
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    BookedGrid.DataSource = reader;
                    BookedGrid.DataBind();
                }
                connection.Close();
                connection.Dispose();
            }
        }

    }
}
