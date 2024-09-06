

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApplicationTestSU.Data;

namespace WebApplicationTestSU.Controllers.PacientControllers.DTO
{
    [Route("api/[controller]")]
    [ApiController]
    public class PacientCotrollers : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public PacientCotrollers(ApplicationDbContext context)
        {
            _context = context;
        }

        // Получение списка пациентов с сортировкой и пагинацией
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Pacient>>> GetPacients(
            string sortBy = "Surname",
            int page = 1,
            int pageSize = 10)
        {
            var query = _context.Pacients.Include(p => p.Uchastok).AsQueryable();

            //Сортировка
            query = sortBy switch
            {
                "Surname" => query.OrderBy(p => p.Surname),
                "Name" => query.OrderBy(p => p.Name),
                "DateOfBirth" => query.OrderBy(p => p.DateOfBirth),
                _ => query.OrderBy(p => p.Surname),
            };

            //Пагинация
            var pacients = await query.Skip((page - 1) * pageSize)
                .Take(pageSize).Select(p => new PacientListDto
                {
                    Id = p.Id,
                    Surname = p.Surname,
                    Name = p.Name,
                    Patronymic = p.Patronymic,
                    Address = p.Address,
                    DateOfBirth = p.DateOfBirth,
                    Gender = p.Gender,
                    UchastokNumber = p.Uchastok.Number
                }).ToListAsync();

            return Ok(pacients);
        }

        //Получение пациента по ID для редактирования
        [HttpGet("{id}")]
        public async Task<ActionResult<PacientEditDto>> GetPacient(int id)
        {
            var pacient = await _context.Pacients.FirstOrDefaultAsync(p => p.Id == id);

            if (pacient == null)
            {
                return NotFound();
            }

            var pacientEditDto = new PacientEditDto
            {
                Id = pacient.Id,
                Name = pacient.Name,
                Surname = pacient.Surname,
                Patronymic = pacient.Patronymic,
                Address = pacient.Address,
                DateOfBirth = pacient.DateOfBirth,
                Gender = pacient.Gender,
                UchastokId = pacient.UchastokId
            };

            return Ok(pacientEditDto);
        }

        //Добавление нового пациента
        [HttpPost]
        public async Task<ActionResult> AddPacient(PacientEditDto pacientDto)
        {
            var pacient = new Pacient
            {
                Name = pacientDto.Name,
                Surname = pacientDto.Surname,
                Patronymic = pacientDto.Patronymic,
                Address = pacientDto.Address,
                DateOfBirth = pacientDto.DateOfBirth,
                Gender = pacientDto.Gender,
                UchastokId = pacientDto.UchastokId
            };

            _context.Pacients.Add(pacient);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetPacient), new { id = pacient.Id }, pacient);
        }

        //Обновление пациента
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePacient(int id, PacientEditDto pacientDto)
        {
            if (id != pacientDto.Id)
            {
                return BadRequest();
            }

            var pacient = await _context.Pacients.FindAsync(id);
            if (pacient == null)
            {
                return NotFound();
            }

            pacient.Surname = pacientDto.Surname;
            pacient.Name = pacientDto.Name;
            pacient.Patronymic = pacientDto.Patronymic;
            pacient.Address = pacientDto.Address;
            pacient.DateOfBirth = pacientDto.DateOfBirth;
            pacient.Gender = pacientDto.Gender;
            pacient.UchastokId = pacientDto.UchastokId;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        //Удаление пациента
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePacient(int id)
        {
            var pacinet = await _context.Pacients.FindAsync(id);
            if (pacinet == null)
            {
                return NotFound();
            }

            _context.Pacients.Remove(pacinet);
            await _context.SaveChangesAsync();

            return NoContent();
        }

    }
}
