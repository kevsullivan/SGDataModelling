/*
' Copyright (c) 2016 kevsullivan.com
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
*/

using System;
using System.Data;
using System.Data.SqlClient;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Framework.Providers;
using Microsoft.ApplicationBlocks.Data;

namespace DotNetNuke.Modules.SGDataModelling.Data
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// SQL Server implementation of the abstract DataProvider class
    /// 
    /// This concreted data provider class provides the implementation of the abstract methods 
    /// from data dataprovider.cs
    /// 
    /// In most cases you will only modify the Public methods region below.
    /// </summary>
    /// -----------------------------------------------------------------------------
    public class SqlDataProvider : DataProvider
    {

        #region Private Members

        private const string ProviderType = "data";
        private const string ModuleQualifier = "SGDataModelling_";

        private readonly ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
        private readonly string _connectionString;
        private readonly string _providerPath;
        private readonly string _objectQualifier;
        private readonly string _databaseOwner;

        #endregion

        #region Constructors

        public SqlDataProvider()
        {

            // Read the configuration specific information for this provider
            Provider objProvider = (Provider)(_providerConfiguration.Providers[_providerConfiguration.DefaultProvider]);

            // Read the attributes for this provider

            //Get Connection string from web.config
            _connectionString = Config.GetConnectionString();

            if (string.IsNullOrEmpty(_connectionString))
            {
                // Use connection string specified in provider
                _connectionString = objProvider.Attributes["connectionString"];
            }

            _providerPath = objProvider.Attributes["providerPath"];

            _objectQualifier = objProvider.Attributes["objectQualifier"];
            if (!string.IsNullOrEmpty(_objectQualifier) && _objectQualifier.EndsWith("_", StringComparison.Ordinal) == false)
            {
                _objectQualifier += "_";
            }

            _databaseOwner = objProvider.Attributes["databaseOwner"];
            if (!string.IsNullOrEmpty(_databaseOwner) && _databaseOwner.EndsWith(".", StringComparison.Ordinal) == false)
            {
                _databaseOwner += ".";
            }

        }

        #endregion

        #region Properties

        public string ConnectionString
        {
            get
            {
                return _connectionString;
            }
        }

        public string ProviderPath
        {
            get
            {
                return _providerPath;
            }
        }

        public string ObjectQualifier
        {
            get
            {
                return _objectQualifier;
            }
        }

        public string DatabaseOwner
        {
            get
            {
                return _databaseOwner;
            }
        }

        // used to prefect your database objects (stored procedures, tables, views, etc)
        private string NamePrefix
        {
            get { return DatabaseOwner + ObjectQualifier + ModuleQualifier; }
        }

        #endregion

        #region Private Methods

        private static object GetNull(object field)
        {
            return Null.GetNull(field, DBNull.Value);
        }

        #endregion

        #region Public Methods

        //public override IDataReader GetItem(int itemId)
        //{
        //    return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "spGetItem", itemId);
        //}

        //public override IDataReader GetItems(int userId, int portalId)
        //{
        //    return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "spGetItemsForUser", userId, portalId);
        //}

        public override IDataReader GetAgeAvg(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix+"GetAgeAvg", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetNumberFriends(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberFriends", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetNumberFollowers(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberFollowers", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetNumberFriendsOver18(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberFriendsOver18", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetNumberFollowersOver18(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberFollowersOver18", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetUserCommunityPostsCount(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetUserCommunityPostsCount", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetUserForumPostsCount(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetUserForumPostsCount", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetCountRepliesFromFriends(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetCountRepliesFromFriends", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetCountRepliesFromFollowers(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetCountRepliesFromFollowers", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetCountRepliesFromNonConnected(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetCountRepliesFromNonConnected", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetDevMonthlyDownloads(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetDevMonthlyDownloads", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetDevGenreTrend(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetDevGenreTrend", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetUserGenreTrend(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetUserGenreTrend", new SqlParameter("@UserId", userId));
        }

        public override IDataReader GetUserGenreTrendLegal(int userId, int age)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetUserLegalGenreTrend", new SqlParameter("@UserId", userId), new SqlParameter("@Age", age));
        }

        public override IDataReader GetUserGenreTrendIllegal(int userId, int age)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetUserIllegalGenreTrend", new SqlParameter("@UserId", userId), new SqlParameter("@Age", age));
        }

        public override IDataReader GetAllUsersGenreTrend()
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetAllUsersGenreTrend");
        }

        public override IDataReader GetNumberUsers()
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberUsers");
        }

        public override IDataReader GetNumberUsersOver18()
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetNumberUsersOver18");
        }

        public override IDataReader GetRelationshipUsers()
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetRelationshipUsers");
        }

        public override IDataReader GetRelationshipLinks()
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetRelationshipLinks");
        }

        
        
        /*
        public override IDataReader GetDateOfBirth(int userId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, NamePrefix + "GetDateOfBirth", new SqlParameter("@UserId", userId));
        }
        */
        #endregion

    }

}