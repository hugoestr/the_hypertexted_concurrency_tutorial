defmodule Learning do

  def listen() do
    receive do
      any -> IO.puts "back #{any}"
    end
  end

  def start() do
    spawn(fn -> send_message(self()) end)
  end

  def send_message(pid) do
    IO.puts "In the process #{inspect self()} and responding to #{inspect pid}"
    send pid, "Yo" 
  end

end

IO.puts "spawning from #{inspect self()}"
parent = self()
spawn(fn -> Learning.send_message(parent) end)
#Learning.start()

IO.puts "waiting"
receive do
      any -> IO.puts "back #{any}"
      after 1000 -> {:error, :timeout}
end

IO.puts "Script ended"
