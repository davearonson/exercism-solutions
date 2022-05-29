defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable(init: 1) 
    end
  end
  @callback init(opts()) :: {:ok, opts()} | {:error, String.t()}
  @callback handle_frame(dot(), frame_number(), opts()) :: dot()
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation
  def handle_frame(dot, n, _opts) when rem(n, 4) > 0, do: dot
  def handle_frame(dot, n, _opts),
    do: %DancingDots.Dot{dot | opacity: dot.opacity / 2}
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  def init(opts = [velocity: v]) when is_number(v), do: {:ok, opts}

  def init(opts), do: {:error, "The :velocity option is required, and its value must be a number. Got: #{inspect(opts[:velocity])}"}

  def handle_frame(dot, frame_number, [velocity: v]) do
    %DancingDots.Dot{dot | radius: dot.radius + v * (frame_number - 1) }
  end
end
