require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end


  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students
      (id INTEGER Primary Key, name TEXT, grade TEXT)
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL

      DB[:conn].execute(sql)

  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)

  end

  def self.new_from_db(row)

    new_id = row[0]
    new_name = row[1]
    new_grade = row[2]


    new_student = Student.new(new_name, new_grade, new_id)


    new_student


  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students
      Values (?,?,?)
    SQL

    DB[:conn].execute(sql, @id, name, grade)

  end

  def save

    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students(name, grade)
      values(?,?)
    SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    student_rows = DB[:conn].execute(sql,name)
    #binding.pry

    Student.new_from_db(student_rows[0])


  end

end
