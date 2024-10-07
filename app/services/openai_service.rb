require "openai"

class OpenaiService
  OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAI_KEY")
    config.log_errors = true
  end

  def initialize
    @client = OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_KEY"),
      log_errors: true
    )
  end

  def get_assistant_info
    response = @client.assistants.retrieve(id: ENV.fetch("ASSISTANT_ID"))
    response
  end

  def get_interpritation(dream_text)
    begin
      thread_response = @client.threads.create
      thread_id = thread_response["id"]

      message_response = @client.messages.create(
        thread_id: thread_id,
        parameters: {
          role: "user",
          content: dream_text
        }
      )
      message_id = message_response["id"]
      run_response = @client.runs.create(
        thread_id: thread_id,
        parameters: {
          assistant_id: ENV.fetch("ASSISTANT_ID")
        }
      )

      loop do
        run_status = @client.runs.retrieve(id: run_response['id'], thread_id: thread_id)
        status = run_status['status']
        puts "Current run status: #{status}"

        case status
        when 'completed'
          puts "Run completed successfully."
          break
        when 'queued', 'in_progress'
          puts "Run is still in progress..."
          sleep(2)
        when 'failed', 'cancelled'
          raise "Run failed or was cancelled."
        else
          raise "Unexpected status: #{status}"
        end
      end
  
      messages_response = @client.messages.list(thread_id: thread_id)
      messages = messages_response["data"]
  
      assistant_response = messages.find { |msg| msg["role"] == "assistant" }
  
      if assistant_response
        interpretation = assistant_response["content"].map { |content_item|
          content_item.dig('text', 'value')
        }.join(" ")
        return interpretation
      else
        return nil
      end
    rescue => e
      puts "Error during interpretation: #{e.message}"
      return nil
    end
  end

  def how_many_tokens(dream_text)
    OpenAI.rough_token_count(dream_text)
  end
end
