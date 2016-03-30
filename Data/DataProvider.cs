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

using System.Data;
using System;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Framework.Providers;


namespace DotNetNuke.Modules.SGDataModelling.Data
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// An abstract class for the data access layer
    /// 
    /// The abstract data provider provides the methods that a control data provider (sqldataprovider)
    /// must implement. You'll find two commented out examples in the Abstract methods region below.
    /// </summary>
    /// -----------------------------------------------------------------------------
    public abstract class DataProvider
    {

        #region Shared/Static Methods

        private static DataProvider provider;

        // return the provider
        public static DataProvider Instance()
        {
            if (provider == null)
            {
                const string assembly = "DotNetNuke.Modules.SGDataModelling.Data.SqlDataprovider,SGDataModelling";
                Type objectType = Type.GetType(assembly, true, true);

                provider = (DataProvider)Activator.CreateInstance(objectType);
                DataCache.SetCache(objectType.FullName, provider);
            }

            return provider;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate", Justification = "Not returning class state information")]
        public static IDbConnection GetConnection()
        {
            const string providerType = "data";
            ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(providerType);

            Provider objProvider = ((Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider]);
            string _connectionString;
            if (!String.IsNullOrEmpty(objProvider.Attributes["connectionStringName"]) && !String.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings[objProvider.Attributes["connectionStringName"]]))
            {
                _connectionString = System.Configuration.ConfigurationManager.AppSettings[objProvider.Attributes["connectionStringName"]];
            }
            else
            {
                _connectionString = objProvider.Attributes["connectionString"];
            }

            IDbConnection newConnection = new System.Data.SqlClient.SqlConnection();
            newConnection.ConnectionString = _connectionString.ToString();
            newConnection.Open();
            return newConnection;
        }

        #endregion

        #region Abstract methods

        //public abstract IDataReader GetItems(int userId, int portalId);

        //public abstract IDataReader GetItem(int itemId);        

        //Date if Birth Removed for now - Datamodelling should focus on retrieving numeric values for graphing only.
        //TODO: Extra Queries can be brought in and handled by new controllers/classes if required.
        //public abstract IDataReader GetDateOfBirth(int userId);

        public abstract IDataReader GetAgeAvg(int userId);

        public abstract IDataReader GetNumberFriends(int userId);

        public abstract IDataReader GetNumberFollowers(int userId);

        public abstract IDataReader GetNumberFriendsOver18(int userId);

        public abstract IDataReader GetNumberFollowersOver18(int userId);

        public abstract IDataReader GetUserCommunityPostsCount(int userId);

        public abstract IDataReader GetUserForumPostsCount(int userId);

        public abstract IDataReader GetCountRepliesFromFriends(int userId);

        public abstract IDataReader GetCountRepliesFromFollowers(int userId);

        public abstract IDataReader GetCountRepliesFromNonConnected(int userId);

        public abstract IDataReader GetDevMonthlyDownloads(int userId);

        public abstract IDataReader GetDevGenreTrend(int userId);

        public abstract IDataReader GetUserGenreTrend(int userId);

        public abstract IDataReader GetUserGenreTrendLegal(int userId, int age);

        public abstract IDataReader GetUserGenreTrendIllegal(int userId, int age);

        public abstract IDataReader GetAllUsersGenreTrend();

        public abstract IDataReader GetNumberUsers();

        public abstract IDataReader GetNumberUsersOver18();

        public abstract IDataReader GetRelationshipUsers();

        public abstract IDataReader GetRelationshipLinks();

        #endregion

    }

}