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

    split_work(addresses)
    
    header()
    
    listen(Enum.count(addresses) - 1)
    
    {:ok, stop} = DateTime.now("Etc/UTC")

    footer(start, stop)
  end

  #listens for a certain amount of messages
  def listen(0), do: true 
  def listen(times) do
  
     receive do
        {:ok, message} -> 
            IO.puts message
            write_to_file(message)
            listen(times - 1)
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

  def split_work(addresses) do
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

    manager = self()
    IO.puts "splitting from #{inspect manager}"
    # The first thing we are going to do is to pass along our script's pid
    # so that they can communicate back when they are done.
    (0..3)
    |> Enum.each(fn (n) -> 
      IO.puts "spawning #{n}" 
      pid = spawn(fn -> send_batch(manager, Enum.at(parts, n)) end)  
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
    |> Enum.map(fn (message) -> send(pid, {:ok, message}) end)
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

# And now we run the simulation
# We are simulating that each number is a different address for simplicity
amount = 100
addresses = Enum.to_list(0..amount) 

Postcards.run_simulation(addresses)
