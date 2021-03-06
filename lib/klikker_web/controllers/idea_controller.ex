defmodule KlikkerWeb.IdeaController do
  use KlikkerWeb, :controller

  alias Klikker.Games
  alias Klikker.Games.Idea

  def index(conn, _params) do
    ideas = Games.list_ideas()
    render(conn, "index.html", ideas: ideas)
  end

  def new(conn, _params) do
    changeset = Games.change_idea(%Idea{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"idea" => idea_params}) do
    case Games.create_idea(idea_params) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Dankjewel voor je idee!")
        |> redirect(to: page_path(conn, :index))
        # |> redirect(to: idea_path(conn, :show, idea))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Dat klopt niet helemaal.")
        |> render(KlikkerWeb.PageView, :index, changeset: changeset)
        # render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Games.get_idea!(id)
    render(conn, "show.html", idea: idea)
  end

  def edit(conn, %{"id" => id}) do
    idea = Games.get_idea!(id)
    changeset = Games.change_idea(idea)
    render(conn, "edit.html", idea: idea, changeset: changeset)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Games.get_idea!(id)

    case Games.update_idea(idea, idea_params) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea updated successfully.")
        |> redirect(to: idea_path(conn, :show, idea))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", idea: idea, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Games.get_idea!(id)
    {:ok, _idea} = Games.delete_idea(idea)

    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end
end
