# Postcards
# A simple simulation of humans sending postcards
#
# A single user
#
# In file we are simulating a single volunteer sending a bathch
# of postcards. We generate addresses 

defmodule Postcards do
  @moduledoc """
  This module simulates a worker writing postcards and sending
  them out. 
  """

  @doc """
  It runs the simulation

  Returns, nil

  ## Parameters
      - address, list of numbers

  """
  def run_simulation(addresses) do
    header()
    {:ok, start} = DateTime.now("Etc/UTC")

    send_batch(addresses)

    {:ok, stop} = DateTime.now("Etc/UTC")
    footer(start, stop)
  end

  @doc """
    It sends a batch of postcards

    ## Parameters
    - addresses, list of numbers simulating addresses
  """
  def send_batch(addresses) do
    addresses
    |> Enum.map(fn (x) -> prepare_postcard(x) end)
    |> Enum.map(fn (x) -> send_postcard(x) end)
  end

  @doc """
  Simulates a worker writing a postcard
  
  Returns: tuple {id, time, message}
  """
  def prepare_postcard(address) do
      time = time_spent()
      postcard_template(address, time)
  end

  @doc """
  Adds user address and custom message to template

  Returns: tuple {id, time, message}

  ## Paramters
  - address, number, simulating a full address
  - time, the simulated time that took a human to prepare the postcard
  """
  def postcard_template(address, time) do
    {address, time, "To: #{address}  Hello from Wisconsin!"}
  end

  @doc """
    Simulates a certain amount of time spent
    Returns: the seconds spent working on the postcard
  """
  def time_spent() do
    time =  Enum.random(1..5) * 100 
    :timer.sleep(time)
    time
  end

  @doc """
    Simulates sending a postcard
    Returns - nil

    ## Parameters
      - tuple, {address, time, message}
        - id, simulated address, in this case a single number
        - time, seconds spent 
        - message, text, message sent

    ## Notes
    Sending the postcard is simulated by printing it to standard output.
  """
  def send_postcard({address, time, message}) do
    IO.puts "#{address},\t#{time},\t#{message}"
  end

  @doc """
  Prints headers for the simulation report 
  Returns nil
  Side Effect: prints headers to standard output
  """
  def header() do
    IO.puts "Postcard Simluation started"
    IO.puts "Address\tTime\tMessage"
  end

  @doc """
  Prints footers for the simulation report 
  Returns nil
  Side Effect: prints footers to standard output

  # Parameters
  - start, in milliseconds, when the simulation started
  - stop, in milliseconds, when the simulation ended
  """
  def footer(start, stop) do
    duration = DateTime.diff(stop, start)
    IO.puts "Started at #{DateTime.to_iso8601(start)} Ended at #{DateTime.to_iso8601(stop)} Total time: #{duration}}"
  end
end

# And now we run the simulation
# We are simulating that each number is a different address for simplicity
amount = 100
addresses = 0..amount 

Postcards.run_simulation(addresses)
