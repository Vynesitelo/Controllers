namespace WebApplicationTestSU.Data
{
    public class Doctor
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public int CabinetId {get; set; }
        public Cabinet Cabinet {  get; set; }

        public int SpecializationId { get ; set; }
        public Specialization Specialization { get; set; }

        public int? UchastokId { get; set; }
        public Uchastok Uchastok { get; set; }
    }
}
