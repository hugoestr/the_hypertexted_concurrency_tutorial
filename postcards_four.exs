# Postcards
# A simple simulation of humans sending postcards
#
# Four volunteers
#
# In file we are simulating four volunteers sending a batch
# of postcards. We generate addresses 

defmodule Volunteer do
  def send_postcards(addresses) do          
    addresses
    |> Enum.map(fn (x) -> prepare_postcard(x) end)
    |> Enum.map(fn (x) -> send_postcard(x) end)
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
end

defmodule Postcards do
  
  def run_simulation(addresses) do
    header()
    {:ok, start} = DateTime.now("Etc/UTC")

    send_batch(addresses)

    {:ok, stop} = DateTime.now("Etc/UTC")
    footer(start, stop)
  end

  def send_batch(addresses) do
    chunk = div(Enum.count(addresses), 4)
    parts  = Enum.chunk_every(addresses, chunk) 

    IO.puts "chunk is #{chunk}"
    IO.inspect addresses
    IO.inspect parts

    (1..4)
    |>Enum.map(fn n -> Volunteer.send_postcards(parts[n])  end)
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
