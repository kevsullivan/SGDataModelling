using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Content;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class NetworkData:ContentItem
    {
        public string Key { get; set; }
        public string Value { get; set; }
               
        public override void Fill(IDataReader dr)
        {
            Key = Null.SetNullString(dr["rKey"]);
            Value = Null.SetNullString(dr["rValue"]);
        }
    }
}