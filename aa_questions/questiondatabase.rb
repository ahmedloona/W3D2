require 'sqlite3'
require 'singleton'
require 'byebug'
class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize 
    super('questions.db')
    self.type_translation = true 
    self.results_as_hash = true
  end
end

class Question

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT 
        * 
      FROM 
        questions
    SQL
    data.map { |datum| Question.new(datum) }
  end


  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        * 
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    qs_by_author_id = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil unless qs_by_author_id.length > 0
    qs_by_author_id.map { |q_by_author_id| Question.new(q_by_author_id) }
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end


end












class User
  

  def self.find_by_id(author_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        * 
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end


  def self.find_by_name(fname, lname)
    selected_user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
       fname = ? AND lname = ?
    SQL
    return nil unless selected_user.length > 0
    User.new(selected_user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end


  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_author_id(@id)
  end
  

end


















class QuestionFollows


end




















class Reply

  def self.find_by_id(id)
    selected = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        replies
      WHERE
       id = ?
    SQL
    Reply.new(selected.first)
  end

  def self.find_by_parent_id(parent_id)
    # debugger
    selected = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    Reply.new(selected.first)
  end

  def self.find_by_author_id(author_id)
      selected_replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT 
          * 
        FROM
          replies
        WHERE
          author_id = ?
      SQL
      return nil unless selected_replies.length > 0
      selected_replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(question_id)
      replies_by_q_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT 
          *
        FROM
          replies
        WHERE
          question_id = ?
      SQL
      return nil unless replies_by_q_id.length > 0
      replies_by_q_id.map { |reply| Reply.new(reply) }
    end

    attr_accessor :body, :question_id, :body, :author_id, :parent_id

    def initialize(options)
      @id = options['id']
      @question_id = options['question_id']
      @body = options['body']
      @author_id = options['author_id']
      @parent_id = options['parent_id']
    end

    def author
      User.find_by_id(@author_id)
    end

    def question
      Question.find_by_id(@question_id)
    end

    def parent_reply
      Reply.find_by_id(@parent_id)
    end

    def child_replies
      debugger
      parent = @id
      Reply.find_by_parent_id(parent)
    end



end


















class QuestionLikes


end