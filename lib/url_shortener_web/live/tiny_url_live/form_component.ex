defmodule UrlShortenerWeb.TinyUrlLive.FormComponent do
  use UrlShortenerWeb, :live_component

  alias UrlShortener.TinyUrls

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tiny_url records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="tiny_url-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :url}} type="text" label="url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tiny url</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tiny_url: tiny_url} = assigns, socket) do
    changeset = TinyUrls.change_tiny_url(tiny_url)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tiny_url" => tiny_url_params}, socket) do
    changeset =
      socket.assigns.tiny_url
      |> TinyUrls.change_tiny_url(tiny_url_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tiny_url" => tiny_url_params}, socket) do
    save_tiny_url(socket, socket.assigns.action, tiny_url_params)
  end

  defp save_tiny_url(socket, :edit, tiny_url_params) do
    case TinyUrls.update_tiny_url(socket.assigns.tiny_url, tiny_url_params) do
      {:ok, _tiny_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tiny url updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tiny_url(socket, :new, tiny_url_params) do
    case tiny_url_params |> url_from_params() |> TinyUrls.create_tiny_url() do
      {:ok, _tiny_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tiny url created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp url_from_params(%{"url" => url}) do
    url
  end
end
