# Postcards
# A simple simulation of humans sending postcards
#
# Four users
#
# In file we are simulating a single volunteer sending a batch
# of postcards. We generate addresses 

defmodule Postcards do
  def run_simulation(addresses) do
    header()
    {:ok, start} = DateTime.now("Etc/UTC")

    split_work(addresses)

    {:ok, stop} = DateTime.now("Etc/UTC")
    footer(start, stop)
  end

  def split_work(addresses) do
    parts = Enum.chunk_every(addresses, 25)

    (0..3)
    |> Enum.each(fn (n) -> 
      IO.puts "spawning #{n}" 
      pid = spawn(fn -> send_batch(Enum.at(parts, n)) end)  
      IO.write "spawned #{n} with pid "
      IO.inspect pid
      end)
  end
  
  def send_batch(addresses) do
    addresses
    |> Enum.map(fn (x) -> process_postcard(x) end)
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
    time =  Enum.random(1..5) * 100 
    :timer.sleep(time)
    time
  end

  def send_postcard({address, time, message}) do
    IO.puts "#{address},\t#{time},\t#{message}"
  end

  def header() do
    IO.puts "Postcard Simluation started"
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
