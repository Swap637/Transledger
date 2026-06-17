using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Diagnostics;
using System.Reflection;
using TransLedger.Models;
using TransLedger.Services;


namespace TransLedger.Controllers
{
    [Authorize]
    [Route("")]
    public class HomeController : Controller
    {
        private readonly IDataAccess _dataAccess;

        public HomeController(IDataAccess dataAccess)
        {
            _dataAccess = dataAccess;
        }

        [HttpGet("")]
        [HttpGet("index")]
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet("registration")]
        public IActionResult Registration()
        {
            return View();
        }

        [HttpGet("tripentry")]
        public IActionResult TripEntry()
        {
            Setdetails();
            return View();
        }
        public void Setdetails()
        {
            string query = "";
            try
            {
                query = @" SELECT VehicleNumber,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'VEHICLE'  
                           SELECT Name,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'PARTY'  
                           SELECT Name,EntityAccountId,ISNULL(CommissionPercent,0) CommissionPercent FROM tbl_EntityAccount WHERE EntityAccountType = 'BROKER' 
                           SELECT Name,EntityAccountId,ISNULL(CommissionPercent,0) CommissionPercent FROM tbl_EntityAccount WHERE EntityAccountType = 'DRIVER' ";

                DataSet ds = _dataAccess.Execute(query);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.VEHICLEList = ds.Tables[0];
                    ViewBag.PARTYList = ds.Tables[1];
                    ViewBag.BROKERList = ds.Tables[2];
                    ViewBag.DriverList = ds.Tables[3];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
        }
        [HttpPost("TripEntry")]
        public IActionResult TripEntry(TripEntryModel model)
        {
            try
            {
                Dictionary<string, object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Mode", 0 },
                    { "@p_VehicleNumber", model.VehicleNumber }, // Changed from PaymentType to your vehicle ID
                    { "@p_EntityAccountId", model.EntityAccountId },
                    { "@p_Amount", model.Amount },
                    { "@p_Date", model.Date },
                    { "@p_Remarks", model.Remarks },
                    { "@p_LoadingPoint", model.LoadingPoint },
                    { "@p_UnloadingPoint", model.UnloadingPoint },
                    { "@p_LRNumber", model.LRNumber },
                    { "@p_BookingPartyId", model.BookingPartyId },
                    { "@p_BrokerId", model.BrokerId }
                };

                _dataAccess.ExecuteSP("PR_TR_TripEntry", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "Trip Entry Saved Successfully!";
                Setdetails();
                return Json(new
                {
                    success = true,
                    message = "Trip Entry Saved Successfully!"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = "Database Error: " + ex.Message
                });
            }
        }

        [HttpPost("Home/getVehicaleDetails")]
        public IActionResult getVehicaleDetails(int selectedvehicalid)
        {
            try
            {
                Dictionary<string, object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Mode", 1 },
                    { "@p_VehicleNumber", selectedvehicalid },
                };

               DataSet ds =  _dataAccess.ExecuteSP("PR_TR_TripEntry", parameters);

                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    return Json(new
                    {
                        success = false,
                        message = "No data found"
                    });
                }

                return Json(new
                { 
                    VehicalOwnerName = ds.Tables[0].Rows[0]["OwnerName"].ToString(),
                    VehicalWeights = ds.Tables[0].Rows[0]["CapacityInTons"].ToString(),
                    VehicleMobileName = ds.Tables[0].Rows[0]["ContactNo"].ToString(),
                    success = true,
                    message = "Success"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }

        [HttpGet("paymententry")]
        public IActionResult PaymentEntry()
        {
            return View();
        }
        
        [HttpPost("paymententry")]
        public IActionResult PaymentEntry(PaymentEntryViewModel model)
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "MAKE-TRANSACTION" },
                    { "@p_PaymentType", model.PaymentType },
                    { "@p_EntityAccountId", model.EntityAccountId },
                    { "@p_Amount", model.Amount },
                    { "@p_PaymentDate", model.Date },
                    { "@p_ModeOfPayment", model.ModeOfPayment },
                    { "@p_ReferenceNumber", model.ReferenceNumber },
                    { "@p_Remarks", model.Remarks }
                };

                _dataAccess.ExecuteSP("pr_PaymentEntry", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "Payment entry save successfully.";

                return View();
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;

                return View(model);
            }
        }

        [HttpGet("ledger")]
        public IActionResult Ledger()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LEDGER" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_PaymentEntry", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }

            return View();
        }

        [HttpGet("accounts")]
        public IActionResult Accounts()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "ACCOUNT" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0){
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpPost("account/add")]
        public IActionResult AddAccounts(EntityAccountViewModel model)
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "ACCOUNT" },
                    { "@p_Name", model.Name },
                    { "@p_AccountType", model.AccountType },
                    { "@p_OpeningBalance", model.OpeningBalance },
                    { "@p_OpeningBalanceType", model.OpeningBalanceType }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New account added successffully";

                return Redirect("/accounts");
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Accounts");
            }
        }
        
        [HttpGet("company-list")]
        public IActionResult ListOfComapany()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "COMPANY" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpGet("party-list")]
        public IActionResult ListOfParty()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "PARTY" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpGet("broker-list")]
        public IActionResult ListOfBroker()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "BROKER" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpGet("vehicle-list")]
        public IActionResult ListOfVehicle()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "VEHICLE" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpGet("driver-list")]
        public IActionResult ListOfDriver()
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "GET-LIST" },
                    { "@p_EntityAccountType", "DRIVER" }
                };

                DataSet ds = _dataAccess.ExecuteSP("pr_EntityAccount", parameters);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ViewBag.List = ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
            }
            return View();
        }
        
        [HttpGet("transactions")]
        public IActionResult Transactions()
        {
            return View();
        }
        
        [HttpGet("getentitylist/{entityType}")]
        public JsonResult GetEntityList(string entityType)
        {
            string query = string.Empty;

            if (entityType.Equals("COMPANY") || entityType.Equals("PARTY") ||
                entityType.Equals("BROKER") || entityType.Equals("DRIVER"))
            {
                query = $"select EntityAccountId, Name EntityAccount From tbl_EntityAccount WHERE EntityAccountType = '{entityType}'";
            }
            else
            {
                query = $"select EntityAccountId, VehicleNumber EntityAccount From tbl_EntityAccount WHERE EntityAccountType = '{entityType}'";
            }

            DataSet ds = _dataAccess.Execute(query);
            
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                var result = ds.Tables[0].AsEnumerable()
                    .Select(row => new
                    {
                        EntityAccountId = row["EntityAccountId"],
                        EntityAccount = row["EntityAccount"]
                    });

                return Json(result);
            }

            return Json(new List<object>());
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
