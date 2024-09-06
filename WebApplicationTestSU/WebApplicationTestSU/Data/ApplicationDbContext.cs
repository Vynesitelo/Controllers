using Microsoft.EntityFrameworkCore;
using System.Numerics;

namespace WebApplicationTestSU.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<Pacient> Pacients { get; set; }
        public DbSet<Doctor> Doctors { get; set; }
        public DbSet<Uchastok> Uchastki { get; set; }
        public DbSet<Specialization> Specializations { get; set; }
        public DbSet<Cabinet> Cabinets { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
    }
}
