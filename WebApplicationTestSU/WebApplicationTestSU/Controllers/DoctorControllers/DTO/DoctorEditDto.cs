namespace WebApplicationTestSU.Controllers.DoctorControllers.DTO
{
    public class DoctorEditDto
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public int CabinetId { get; set; } // Ссылка на кабинет
        public int SpecializationId { get; set; } // Ссылка на специализацию
        public int? UchastokId { get; set; } // Ссылка на участок (nullable, если не участковый врач)
    }
}
