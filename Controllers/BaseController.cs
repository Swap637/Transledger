using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace TransLedger.Controllers
{
    public class BaseController : Controller
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            TempData.Remove("AlertType");
            TempData.Remove("AlertMsg");

            base.OnActionExecuting(context);
        }
    }

}
