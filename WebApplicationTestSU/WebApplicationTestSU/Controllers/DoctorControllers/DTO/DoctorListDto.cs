namespace WebApplicationTestSU.Controllers.DoctorControllers.DTO
{
    public class DoctorListDto
    {
        public int Id { get; set; }
        public string FullName { get; set; } // ФИО врача
        public string CabinetNumber { get; set; } // Номер кабинета
        public string SpecializationName { get; set; } // Название специализации
        public string UchastokNumber { get; set; } // Номер участка (если есть)
    }
}
