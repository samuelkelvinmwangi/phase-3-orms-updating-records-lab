require_relative "../config/environment.rb"

class Student
attr_accessor :id=nil, :name, :grade

  def initialize(id, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  # creating table
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  # drop table
  def self.drop_table
  sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  # save table
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  # create
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  # new from db
  def self.new_from_db(row)
    id, name, grade = row
    Student.new(id, name, grade)
  end

  # find student
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *FROM students WHERE name = ? LIMIT 1
    SQL

    row = DB[:conn].execute(sql, name).first
    self.new_from_db(row) if row
  end

  # update
  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
