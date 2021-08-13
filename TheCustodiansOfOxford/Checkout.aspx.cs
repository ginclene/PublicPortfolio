using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using CustodiansOfOxford.Models;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Data.SqlClient;
using System.Net.Mail;
using System.IO;
using System.Net;


namespace CustodiansOfOxford
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            GetAllCartItems();
            
        }

        public void GetAllCartItems()
        {
            string capitalized = "My Cart";
            int countofItems = 0;
            float totalCost = 0.0f;
            string data = "<h4>" + capitalized + "</h4><br/><table width='200' class='table'><thead><tr><th></th><th>Service</th>";
            data += "<th>Cost ($)</th><th>Set Appointment</th><th></th></tr></thead><tbody>";
            foreach (CartItem item in Universal.list)
            {
                if (item is null)
                {
                }
                else if (item.subscription == true)
                {
                    System.Diagnostics.Debug.WriteLine("the image path is: " + item.imgPath);
                    System.Diagnostics.Debug.WriteLine(item.id);
                    countofItems++;
                    totalCost += item.weeklyCost;
                    string name = "\"" + item.name + "\"";
                    data += "<tr><td><img width='100' height='100' src='" + item.imgPath + "'" + " /></td>" +
                        "<td>" + item.name + "</td>" +
                        "<td id=\"" + item.name + " cost\">" + item.weeklyCost + "</td>" +
                        "<td>" + "<button type='button' class='btn btn-default' id = " + name + " runat = 'server' onclick='showName(" + name + ")'>Select Date </button></td>" +
                        "<td>" + "<button type='button' class='btn btn-danger' id = " + item.id + " runat = 'server' onclick='removeItem(" + item.id + ")' > Remove </button></td></tr>";
                }
                else if (item.subscription == false)
                {
                    countofItems++;
                    totalCost += item.basecost;
                    string name = "\"" + item.name + "\"";
                    data += "<tr><td><img width='100' height='100' src='" + item.imgPath + "'" + " /></td>" +
                        "<td>" + item.name + "</td>" +
                        "<td id=\"" + item.name + " cost\">" + item.basecost + "</td>" +
                        "<td>" + "<button type='button' class='btn btn-default' id = " + name + " runat = 'server' onclick='showName(" + name + ")' >Select Date </button></td>" +
                        "<td>" + "<button type='button' class='btn btn-danger' id = " + item.id + " runat = 'server' onclick='removeItem(" + item.id + ")' > Remove </button></td></tr>"; ;
                }
                System.Diagnostics.Debug.WriteLine(item.name + " cost");

            }
            lblData.Text = data + "</tbody></table>";
            total.Text = "Number of services: " + countofItems + " Total Cost: " + totalCost;
            
        }

            public void removeItem(object sender, EventArgs e)
        {
            string id = SubID.Value;
            int idd = Int32.Parse(id);

            foreach (CartItem item in Universal.list)
            {
                if(item.id == idd)
                {
                    Universal.list.Remove(item);
                    break;
                }
            }
        }

     
        
        [System.Web.Services.WebMethod]
        public static int checkDate(string date)
        {
            System.Diagnostics.Debug.WriteLine("Made it in count number 1");
            System.Diagnostics.Debug.WriteLine("Made it in count number 2");
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            int hiddenSlots;
            int counter = 0;
            int helper = 0;
            System.Diagnostics.Debug.WriteLine(date);
            string time;
            try
            {
               time = date.Substring(11);
            } catch (Exception e) {
                return -1;
            }
            date = date.Substring(0, 10);
            System.Diagnostics.Debug.WriteLine("Modified time, should have no time" + time);
            if(time.Equals("Morning"))
            {
                helper = 0; // 0 = morning
            } else
            {
                helper = 1;
            }

            string TimeOfDay = "";
            if(helper == 0)
            {
                TimeOfDay = "\'Morning\'";
            } else
            {
                TimeOfDay = "\'Afternoon\'";
            }
            
            System.Diagnostics.Debug.WriteLine("helper = " + helper);
            System.Diagnostics.Debug.WriteLine("We are checking: " + date + " at: " + TimeOfDay);
            using (SqlConnection connection = new SqlConnection(finalconnect))
            {
                string strQuery = "SELECT count(*) FROM tblDates WHERE serTime = " + TimeOfDay + " AND serDate = '" + date + "';";
                System.Diagnostics.Debug.WriteLine(strQuery);
                using (SqlCommand command = new SqlCommand(strQuery, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                  //  while (reader.HasRows)
                  //  {
                        System.Diagnostics.Debug.WriteLine("we found rows");
                        while (reader.Read())
                        {

                            int count = reader.GetInt32(0);
                            System.Diagnostics.Debug.WriteLine(count);
                            counter = count;
                        //    reader.NextResult();
                        }
                 //   }

                }
                connection.Close();
                connection.Dispose();

            }
            System.Diagnostics.Debug.WriteLine("the counter is: " + counter);
           return hiddenSlots = counter;
        }

        [System.Web.Services.WebMethod]
        public static void saveDate(Object arr)
        {
            System.Diagnostics.Debug.WriteLine("poop = " + arr.ToString() + " " + HttpContext.Current.User.Identity.Name);
            string[] date = arr.ToString().Split(',');
            string finalconnect = string.Empty;
            finalconnect = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(finalconnect))
                  {
                for(int i = 0; i < date.Length; i=i+3)
                {
                    string newdate = date[i];
                    string newTime = date[i + 1];
                    string serName = date[i + 2];
                    System.Diagnostics.Debug.WriteLine("date:" + newdate + " time:" + newTime + " serName:" + serName);
                    string strQuery = "INSERT INTO tblDates (serDate, serviceName, serTime, Email)" +
                   " VALUES (@serDate, @serName, @serTime, @Email)";
                    using (SqlCommand command = new SqlCommand(strQuery, connection))
                    {
                        command.Parameters.AddWithValue("@SerDate", newdate);
                        command.Parameters.AddWithValue("@SerName", serName);
                        command.Parameters.AddWithValue("@SerTime", newTime);
                        command.Parameters.AddWithValue("@Email", HttpContext.Current.User.Identity.Name);
                        connection.Open();
                        int result = command.ExecuteNonQuery();
                        if (result < 0)
                        {
                           System.Diagnostics.Debug.WriteLine("whats the problem bobby");
                        }
                    }
                    connection.Close();
                }
                connection.Dispose();

            }
         //  using (SqlConnection connection = new SqlConnection(finalconnect))
         //  {
         //      string strQuery = "INSERT INTO tblDates (serDate, serviceName, serTime, Email)" +
         //          " VALUES (@dateID, @serDate, @serviceName, @Email)";
         //      using (SqlCommand command = new SqlCommand(strQuery, connection))
         //  
         //      {
         //         // command.Parameters.AddWithValue("@SubName", SubName.Value);  
         //         // command.Parameters.AddWithValue("@subType", subscriptionType);
         //         // command.Parameters.AddWithValue("@subImage", subImg);
         //         // command.Parameters.AddWithValue("@subDescription", subDescription.Value);
         //         // command.Parameters.AddWithValue("@subWeeklyCost", Int32.Parse(weeklyCost.Value));
         //          connection.Open();
         //          int result = command.ExecuteNonQuery();
         //          if (result < 0)
         //          {
         //              System.Diagnostics.Debug.WriteLine("whats the problem bobby");
         //          }
         //
         //      }
         //      connection.Close();
         //      connection.Dispose();
        //    }
        

        }
    }

}
