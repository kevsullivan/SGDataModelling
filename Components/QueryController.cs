using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
//using DotNetNuke.Data;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Modules.SGDataModelling.Data;

namespace DotNetNuke.Modules.SGDataModelling.Components
{
    public class QueryController
    {
        public static QueryResult GetAgeAvg(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetAgeAvg(userId));
        }

        public static QueryResult GetNumberFriends(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFriends(userId));
        }

        public static QueryResult GetNumberFollowers(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberFollowers(userId));
        }

        public static QueryResult GetNumberUsers(int userId)
        {
            return CBO.FillObject<QueryResult>(DataProvider.Instance().GetNumberUsers());
        }
        /*
        public static int GetDateOfBirth(int userId)
        {
            return Convert.ToInt32(DataProvider.Instance().GetDateOfBirth(userId));
        }
        */
    }
}