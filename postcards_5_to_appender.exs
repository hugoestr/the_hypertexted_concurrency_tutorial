# Postcards
# A simple simulation of humans sending postcards
#
# Four users
#
# In file we are simulating a single volunteer sending a batch
# of postcards. We generate addresses 

defmodule Postcards do
  def run_simulation(addresses) do
    {:ok, start} = DateTime.now("Etc/UTC")

    manager = self()
    
    appender = Appender.start(manager, Enum.count(addresses))
    split_work(appender, addresses)
    
    header()

    wait()
    #listen(appender, Enum.count(addresses) - 1)
    {:ok, stop} = DateTime.now("Etc/UTC")

    footer(start, stop)
    Appender.stop(appender)
  end

  def wait() do
    receive do
      {:done} -> IO.puts "done waiting"
      after
        32000 -> IO.puts  "timeout"
    end
  end

  #listens for a certain amount of messages
  def listen(_appender, 0), do: true 
  def listen(appender, times) do
  
     receive do
        {:ok, message} -> 
            IO.puts message
            send appender, {:append, message}
            listen(appender, times - 1)
        after
          33000 -> 
            IO.puts "It timed out after 33 seconds"
     end
  end

  def write_to_file(message) do
    path = "output.txt"
    content = "#{message}\n"
    IO.puts content 
    File.write!(path, content, [:append])
  end

  def split_work(appender, addresses) do
    parts = Enum.chunk_every(addresses, 25)


    # The actor model sends messages from one process to another
    # Each process has a mailbox. This mailbox is like a queue 
    # of messages. 
    # To be able to send messages back and forth, you need their 
    # name or address. That address is the Process Id or pid for short.
    #
    # The basic plan is to spawn new processes with and sending along
    # the pid of the manager. Then when they are done they should report
    # back the manager with the reports of what they did.

    # The first thing we are going to do is to pass along our script's pid
    # so that they can communicate back when they are done.
    (0..3)
    |> Enum.each(fn (n) -> 
      IO.puts "spawning #{n}" 
      pid = spawn(fn -> send_batch(appender, Enum.at(parts, n)) end)  
      IO.write "spawned #{n} with pid "
      IO.inspect pid
      end)
  end

  # The changes we make here is that we first accept the pid.
  # Then we add another map that will go through the processed
  # messages and send them back to the manager process.
  def send_batch(pid, addresses) do
    addresses
    |> Enum.map(fn (x) -> process_postcard(x) end)
    |> Enum.map(fn (message) -> send(pid, {:append, message}) end)
  end

  def process_postcard(address) do
    address
    |> prepare_postcard()
    |> send_postcard()
  end

  def prepare_postcard(address) do
      time = time_spent()
      postcard_template(address, time)
  end

  def postcard_template(address, time) do
    {address, time, "To: #{address}  Hello from Wisconsin!"}
  end

  def time_spent() do
    time =  Enum.random(1..3) * 100 
    :timer.sleep(time)
    time
  end

  # We change it to make a string
  def send_postcard({address, time, message}) do
    "#{address},\t#{time},\t#{message}"
  end

  def header() do
    IO.write "Postcard Simluation started running at pid: "
    IO.inspect self()
    IO.puts "Address\tTime\tMessage"
  end

  def footer(start, stop) do
    duration = DateTime.diff(stop, start)
    IO.puts "Started at #{DateTime.to_iso8601(start)} Ended at #{DateTime.to_iso8601(stop)} Total time: #{duration}}"
  end
end

defmodule Appender do
  def start(manager, n) do
    IO.puts "starting appending service"
    spawn(fn -> loop(manager, n) end)
  end

  def stop(pid) do
    IO.puts "stopping appending service"
    send pid, {:stop, ""}
  end

  def loop(manager, 1) do
    send manager, {:done} 
  end

  def loop(manager, n) do
    receive do
      {:append, message} -> 
        write_to_file(message)
        IO.puts "N is now #{n - 1}"
        loop(manager, n - 1)
      {:stop, _message} ->
        IO.puts "stopping appending service"
    end
  end 
  
  def write_to_file(message) do
    path = "output.txt"
    content = "#{message}\n"
    IO.puts content 
    File.write!(path, content, [:append])
  end
end

# And now we run the simulation
# We are simulating that each number is a different address for simplicity
amount = 100
addresses = Enum.to_list(0..amount) 

Postcards.run_simulation(addresses)
