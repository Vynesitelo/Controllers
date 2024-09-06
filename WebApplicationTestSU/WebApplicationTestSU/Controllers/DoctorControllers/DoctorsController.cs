using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using WebApplicationTestSU.Controllers.DoctorControllers.DTO;
using WebApplicationTestSU.Data;

namespace WebApplicationTestSU.Controllers.DoctorControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DoctorsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public DoctorsController(ApplicationDbContext context)
        {
            _context = context;
        }

        //Получение списка врачей с сортировкой и пагинацией
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DoctorListDto>>> GetDoctors(
            string sortBy = "Fullname",
            int page = 1,
            int pageSize = 10)
        {
            var query = _context.Doctors
                .Include(d => d.Cabinet)
                .Include(d => d.Specialization)
                .Include(d => d.Uchastok)
                .AsQueryable();

            //Сортировка 
            query = sortBy switch
            {
                "FullName" => query.OrderBy(d => d.FullName),
                "Specialization" => query.OrderBy(d => d.Specialization.Name),
                _ => query.OrderBy(d => d.FullName),
            };

            //Пагинация 
            var doctors = await query.Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(d => new DoctorListDto
                {
                    Id = d.Id,
                    FullName = d.FullName,
                    CabinetNumber = d.Cabinet.Number,
                    SpecializationName = d.Specialization.Name,
                    UchastokNumber = d.Uchastok != null ? d.Uchastok.Number : null
                })
                .ToListAsync();
            
            return Ok(doctors);
        }

        //Получение врача по ID для редактирования
        [HttpGet("{id}")]
        public async Task<ActionResult<DoctorEditDto>> GetDoctor(int id)
        {
            var doctor = await _context.Doctors.FirstOrDefaultAsync(d => d.Id == id);

            if(doctor == null)
            {
                return NotFound();
            }

            var doctorEditDto = new DoctorEditDto
            {
                Id = doctor.Id,
                FullName = doctor.FullName,
                CabinetId = doctor.CabinetId,
                SpecializationId = doctor.SpecializationId,
                UchastokId = doctor.UchastokId,
            };

            return Ok(doctorEditDto);
        }

        //Добавление нового врача
        [HttpPost]
        public async Task<ActionResult> AddDroctor(DoctorEditDto doctorDto)
        {
            var doctor = new Doctor
            {
                FullName = doctorDto.FullName,
                CabinetId = doctorDto.CabinetId,
                SpecializationId = doctorDto.SpecializationId,
                UchastokId = doctorDto.UchastokId
            };
            
            _context.Doctors.Add(doctor);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetDoctor), new {id = doctor.Id}, doctor);
        }

        //Обновление врача 
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateDoctor(int id, DoctorEditDto doctorDto)
        {
            if (id != doctorDto.Id)
            {
                return BadRequest();
            }

            var doctor = await _context.Doctors.FindAsync(id);
            if (doctor == null) { return NotFound(); }

            doctor.FullName = doctorDto.FullName;
            doctor.CabinetId = doctorDto.CabinetId;
            doctor.SpecializationId = doctorDto.SpecializationId;
            doctor.UchastokId = doctorDto?.UchastokId;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        //Удаление врача
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteDoctor(int id)
        {
            var doctor = await _context.Doctors.FindAsync(id);
            if (doctor == null)
            {
                return NotFound();
            }

            _context.Doctors.Remove(doctor);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
