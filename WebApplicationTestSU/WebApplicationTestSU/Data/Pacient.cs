namespace WebApplicationTestSU.Data
{
    public class Pacient
    {
        public int Id { get; set; }
        public string Surname { get; set; }
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public string Address { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string UchastokId { get; set; }
        public Uchastok Uchastok { get; set; }

    }
}
