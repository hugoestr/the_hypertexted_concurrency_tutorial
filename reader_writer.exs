defmodule CriticalResource do
  def start() do
    spawn(fn -> loop("initialize") end)
  end

  def loop(data) do
    receive do
      {:read, pid, name} ->
        MyLogger.log(:resource, name, :reading)
        send pid, {:current_text, data } 
        loop(data)
      {:write, name, data} ->
        MyLogger.log(:resource, name, :writing, data)
        loop(data)
    end
  end
end

defmodule Worker do
  def start(name, critical_resource) do
    spawn(fn -> loop(name, critical_resource) end)
  end

  def begin(pid) do
    send pid, :begin
  end

  def loop(name, resource) do
    receive do
      :begin ->
        MyLogger.log(:worker, name, :busy)
        busy()
        action = random_action()
        send self(), action 
        loop(name, resource)
      :read  ->
        MyLogger.log(:worker, name, :read)
        send resource, {:read, self(),  name}
        send self(), :begin
        loop(name, resource)
      :write  ->
        MyLogger.log(:worker, name, :write)
        send resource, {:write, name, "#{name}_data"}
        send self(), :begin
        loop(name, resource)
      {:current_text, text } ->
        MyLogger.log(:worker, name, :read_text, text)
        send self(), :begin
        loop(name, resource)
    end
  end

  def busy() do
    time = Enum.random(1..3) * 1000
    Process.sleep(time)
  end

  def random_action do
    Enum.random([:write, :read])
  end
end

defmodule MyLogger do
  def log(actor, id, action, data \\ "_") do
    entry = "#{actor}\t#{id}\t#{action}\t#{data}" 
    IO.puts entry
  end
end

# reader writer simulation.
# Have a resource that can be read by everyone but only written by
# one person.
#
# Previously the writing to files is a close approximation to this one.
# This is a simulation using actors
defmodule Simulation do
  def start() do
    header()

    resource = CriticalResource.start()

    (0..10)
    |> Enum.map(fn n -> Worker.start(n, resource) end)
    |> Enum.map(fn worker -> Worker.begin(worker) end)

    # Run the simulation for 30 seconds
    Process.sleep(30_000) 

    footer()
  end

  def header() do
    IO.puts "starting simulation"
  end
  
  def footer() do
    IO.puts "ending simulation"
  end
end

Simulation.start()
