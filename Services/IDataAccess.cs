using System.Data;

namespace TransLedger.Services
{
    public interface IDataAccess
    {
        public DataSet Execute(string query);
        public DataSet ExecuteSP(string procedureName, Dictionary<string, object> parameters);
        public DataSet ExecuteSP2(string procedureName, Dictionary<string, object> parameters);
        public DataSet ExecuteSP(string procedureName);
    }
}
