using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;

namespace TransLedger.Services
{
    public class DataAccess : IDataAccess
    {
        private readonly string _connectionString;

        public DataAccess(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("ConString");
        }

        /// <summary>
        /// Execute SQL query and return DataSet
        /// </summary>
        public DataSet Execute(string query)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    using (SqlDataAdapter adapter = new SqlDataAdapter(query, conn))
                    {
                        adapter.Fill(ds);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message, ex);
                }
            }

            return ds;
        }

        /// <summary>
        /// Execute stored procedure with parameters
        /// </summary>
        public DataSet ExecuteSP(string procedureName, Dictionary<string, object> parameters)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(procedureName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                cmd.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
                            }
                        }

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(ds);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message, ex);
                }
            }

            return ds;
        }

        /// <summary>
        /// Execute stored procedure without parameters
        /// </summary>
        public DataSet ExecuteSP(string procedureName)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(procedureName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(ds);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message, ex);
                }
            }

            return ds;
        }

        /// <summary>
        /// Execute stored procedure with output parameters
        /// </summary>
        public DataSet ExecuteSP2(string procedureName, Dictionary<string, object> parameters)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(procedureName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                SqlParameter sqlParam = new SqlParameter(param.Key, param.Value ?? DBNull.Value);

                                if (param.Value == null)
                                {
                                    sqlParam.Value = DBNull.Value;
                                    sqlParam.Direction = ParameterDirection.Input;
                                }

                                cmd.Parameters.Add(sqlParam);
                            }
                        }

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(ds);
                        }

                        foreach (SqlParameter param in cmd.Parameters)
                        {
                            if (param.Direction == ParameterDirection.Output ||
                                param.Direction == ParameterDirection.InputOutput)
                            {
                                parameters[param.ParameterName] = param.Value;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message, ex);
                }
            }

            return ds;
        }
    }
}
