﻿using WebApplicationTestSU.Data;

namespace WebApplicationTestSU.Controllers.PacientControllers.DTO
{
    public class PacientListDto
    {
        public int Id { get; set; }
        public string Surname { get; set; }
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public string Address { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string UchastokNumber { get; set; } //Номер участка
    }
}
