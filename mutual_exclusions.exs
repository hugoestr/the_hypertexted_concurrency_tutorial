defmodule CriticalResource do
  def start() do
    spawn(fn -> loop() end)
  end

  def loop() do
    receive do
      {:use, name, data} ->
        IO.puts "#{name}\t:using_critical_resource\t#{data}\t***"
        loop()
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
        IO.puts "#{name}\t:busy"
        busy()
        send self(), :use_critical_resource
        loop(name, resource)
      :use_critical_resource ->
        IO.puts "#{name}\t:try_to_use"
        send resource, {:use, name, "#{name}_data"}
        send self(), :begin
        loop(name, resource)
    end
  end

  def busy() do
    time = Enum.random(1..3) * 1000
    Process.sleep(time)
  end
end
defmodule Simulation do
  def start() do
    header()

    resource = CriticalResource.start()

    worker1 = Worker.start(:one, resource)
    worker2 = Worker.start(:two, resource)

    [worker1, worker2]
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
