# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]  

class Student

  attr_accessor :name, :grade
  attr_reader :id
  @@all = []

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
    @@all << self
  end

  #creates the students table in the database 
  def self.create_table
    sql =  <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade TEXT
      )
      SQL
    DB[:conn].execute(sql) 
  end

  #a method that can drop that table
  def self.drop_table
    #create a variable sql
    #set it equal to the SQL statement that drops the students table. 
    #Execute that statement against the database using DB[:conn].execute(sql).

    sql =  <<-SQL 
      DROP TABLE students
      SQL
      DB[:conn].execute(sql) 

  end

  #save, that can save the data concerning an individual student object to the database.
  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) 
      VALUES (?, ?)
      SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  #creates a new instance of the student class and then saves it to the database
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student 
  end
  
end

# s = Student.create(name: "Josh", grade: "9th")
