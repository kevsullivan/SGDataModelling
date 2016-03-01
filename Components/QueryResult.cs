using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Content;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class QueryResult:ContentItem
    {
        public int QueryValue { get; set; }

        public override void Fill(IDataReader dr)
        {
            QueryValue = Null.SetNullInteger(dr["QueryResult"]);
        }
    }
}