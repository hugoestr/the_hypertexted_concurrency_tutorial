defmodule Fork do
  def start(name) do
    spawn(fn -> loop(name, false, :no_one) end)
  end

  def pick(pid, philosopher) do
    send pid, {:pick, self(), philosopher}

    receive do
      :ok -> true
      :busy -> false
    end
  end

  def drops(pid, philosopher) do
    send pid, {:drop, philosopher}
  end

  def loop(name, locked?, user) do
    receive do
      {:pick, response, philosopher} ->
          IO.puts "Processing :pick request from #{name} for #{philosopher}"

          case locked? do
            false ->
              IO.puts "#{name} is now locked for #{philosopher}"
              send response, :ok
              loop(name, true, philosopher)
            true ->
              IO.puts "#{name} is currently locked for #{user}"
              send response, :busy
              loop(name, locked?, user)
          end
      {:drop, philosopher} ->
          IO.puts "Processing :drop request for :#{philosopher}"

          if locked?  && user == philosopher do
            IO.puts "Dropping #{name} for #{philosopher}"
            loop(name, false, :no_one)
          else
            loop(name, locked?, user)
          end

    end
  end
end


defmodule Philosopher do
  def start(name, f1, f2) do
    spawn(fn -> loop(name, f1, f2) end)
  end

  def begin(pid) do
    send pid, :ponder
  end

  defp loop(name, f1, f2) do
    receive do
      :ponder -> 
        IO.puts "#{name} is pondering"
        busy()
        send self(), :eat
        loop(name, f1, f2)
      :eat -> 
        IO.puts "#{name} is trying to eat"

        lock_1 = Fork.pick(f1, name)
        lock_2 = Fork.pick(f2, name)

        if lock_1 && lock_2 do
          eats(name) 
        else
          IO.puts "<<<<<<<<<<<< #{name} couldn't eat"
        end
        
        Fork.drops(f1, name)
        Fork.drops(f2, name)

        send self(), :ponder
        loop(name, f1, f2)
    end
  end

  defp eats(name) do
    IO.puts "********** #{name} is eating"
    busy() 
    IO.puts "********** #{name} has stopped eathing"
  end

  defp busy() do
    think = Enum.random(1..30) * 100
    Process.sleep(think)
  end
end

defmodule Simulation do
  def start(timeout) do
    IO.puts "starting philosopher simulation"

    setup()
    |> Enum.map(fn philosopher  -> 
      Philosopher.begin(philosopher) end)

    Process.sleep(timeout)

    IO.puts "Ending philosopher simulation after #{timeout} milliseconds"
  end

  def setup() do
    forks = start_forks() 
    philosophers = start_philosophers(forks)

    philosophers
   end

  def start_forks() do
    f1 = Fork.start(:f1)
    f2 = Fork.start(:f2)
    f3 = Fork.start(:f3)
    f4 = Fork.start(:f4)
    f5 = Fork.start(:f5)

    [f1, f2, f3, f4, f5]
  end

  def start_philosophers([f1, f2, f3, f4, f5]) do
    plato = Philosopher.start(:plato, f1, f5)
    aristotle = Philosopher.start(:aristotle, f2, f1)
    spinoza = Philosopher.start(:spinoza, f3, f2)
    hegel = Philosopher.start(:hegel, f4, f3)
    kant = Philosopher.start(:kant, f5, f4)

    [plato, aristotle, spinoza, hegel, kant]
  end
end

seconds = 30
timeout = seconds  * 1000

Simulation.start(timeout)
