using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Content;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class AnnualStats:ContentItem
    {
        public string Name { get; set; }
        private string[] Months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        public int[] MonthData { get; set; }
        //TODO: Update with dictionary usage its late and brain is taking easy route
        public override void Fill(IDataReader dr)
        {
            MonthData = new int[12];
            Name = Null.SetNullString(dr["Name"]);
            for (int i = 0; i < Months.Length; i++)
            {
                MonthData[i] = Null.SetNullInteger(dr[Months[i]]);
            }
        }
    }
}