using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransLedger.Models;
using TransLedger.Services;

namespace TransLedger.Controllers
{
    [Authorize]
    [Route("registration")]
    public class RegistrationController : Controller
    {
        private readonly IDataAccess _dataAccess;

        public RegistrationController(IDataAccess dataAccess)
        {
            _dataAccess = dataAccess;
        }

        [HttpGet("company")]
        public IActionResult Company()
        {
            return View();
        }

        [HttpGet("party")]
        public IActionResult Party()
        {
            return View();
        }

        [HttpGet("broker")]
        public IActionResult Broker()
        {
            return View();
        }

        [HttpGet("vehicle")]
        public IActionResult Vehicle()
        {
            return View();
        }

        [HttpGet("driver")]
        public IActionResult Driver()
        {
            return View();
        }

        [HttpPost("company/register")]
        public IActionResult RegisterCompany(EntityAccountViewModel model)
        {
            try
            {
                if (model.ContactNo.ToString() == model.AlterNativeMobileNo.ToString())
                {
                    TempData["AlertType"] = "danger";
                    TempData["AlertMsg"] = "Contact Number and Alternative Mobile Can't be same.";

                    return Redirect("/registration/party");
                }

                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "COMPANY" },
                    { "@p_Name", model.Name },
                    { "@p_GSTIN", model.GSTIN },
                    { "@p_PAN", model.PAN },
                    { "@p_ContactName", model.ContactPersonName },
                    { "@p_ContactNo", model.ContactNo },
                    { "@p_AlterNativeMobileNo", model.AlterNativeMobileNo },
                    { "@p_Email", model.Email },
                    { "@p_RegistrationType", model.RegistrationType },
                    { "@p_Address", model.Address }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New company registered successffully";

                return Redirect("/registration/company");
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Company");
            }            
        }

        [HttpPost("party/register")]
        public IActionResult RegisterParty(EntityAccountViewModel model)
        {
            try
            {
                if (model.ContactNo.ToString() == model.AlterNativeMobileNo.ToString())
                {
                    TempData["AlertType"] = "danger";
                    TempData["AlertMsg"] = "Contact Number and Alternative Mobile Can't be same.";

                    return Redirect("/registration/party");
                }

                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "PARTY" },
                    { "@p_Name", model.Name },
                    { "@p_GSTIN", model.GSTIN },
                    { "@p_ContactName", model.ContactPersonName },
                    { "@p_ContactNo", model.ContactNo },
                    { "@p_AlterNativeMobileNo", model.AlterNativeMobileNo },
                    { "@p_Email", model.Email },
                    { "@p_Address", model.Address }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New party registered successffully";

                return Redirect("/registration/party");
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Party");
            }
        }

        [HttpPost("broker/register")]
        public IActionResult RegisterBroker(EntityAccountViewModel model)
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "BROKER" },
                    { "@p_Name", model.Name },
                    { "@p_AadharNumber", model.AadharNumber },
                    { "@p_PAN", model.PAN },
                    { "@p_ContactName", model.ContactPersonName },
                    { "@p_ContactNo", model.ContactNo },
                    { "@p_AlterNativeMobileNo", model.AlterNativeMobileNo },
                    { "@p_CommissionPercent", model.CommissionPercent },
                    { "@p_Address", model.Address }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New broker registered successffully";

                return Redirect("/registration/broker");
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Broker");
            }
        }

        [HttpPost("vehicle/register")]
        public IActionResult RegisterVehicle(EntityAccountViewModel model)
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "VEHICLE" },
                    { "@p_VehicleNumber", model.VehicleNumber },
                    { "@p_VehicleType", model.VehicleType },
                    { "@p_CapacityInTons", model.CapacityInTons },
                    { "@p_PermitType", model.PermitType },
                    { "@p_PermitNumber", model.PermitNumber },
                    { "@p_PermitExpiryDate", model.PermitExpiryDate },
                    { "@p_InsurancePolicyNumber", model.InsurancePolicyNumber },
                    { "@p_InsuranceExpiryDate", model.InsuranceExpiryDate },
                    { "@p_OwnerName", model.OwnerName },
                    { "@p_AadharNumber", model.AadharNumber },
                    { "@p_PAN", model.PAN },
                    { "@p_Address", model.Address }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New vehicle registered successffully";

                return Redirect("/registration/vehicle");
            }
            catch (Exception ex)
            {
                ViewBag.Step = 3;
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Vehicle");
            }
        }

        [HttpPost("driver/register")]
        public IActionResult RegisterDriver(EntityAccountViewModel model)
        {
            try
            {
                Dictionary<string, Object> parameters = new Dictionary<string, object>()
                {
                    { "@p_Action", "CREATE" },
                    { "@p_EntityAccountType", "DRIVER" },
                    { "@p_Name", model.Name },
                    { "@p_AadharNumber", model.AadharNumber },
                    { "@p_LicenseNumber", model.LicenseNumber },
                    { "@p_ContactNo", model.ContactNo },
                    { "@p_AlterNativeMobileNo", model.AlterNativeMobileNo },
                    { "@p_Address", model.Address }
                };

                _dataAccess.ExecuteSP("pr_EntityAccount", parameters);

                TempData["AlertType"] = "success";
                TempData["AlertMsg"] = "New driver registered successffully";

                return Redirect("/registration/driver");
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "danger";
                TempData["AlertMsg"] = ex.Message;
                return View("Driver");
            }
        }
    }
}
