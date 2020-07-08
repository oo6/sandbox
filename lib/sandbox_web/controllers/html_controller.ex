defmodule SandboxWeb.HTMLController do
  use SandboxWeb, :controller

  @prefix to_string(:code.priv_dir(:sandbox)) <> "/static/html"
  @root @prefix <> "/root.html.eex"

  def show(conn, %{"path" => path}) do
    absolute_path = Enum.join([@prefix | path], "/")

    head_path = String.replace_suffix(absolute_path, ".html", "/head.html")
    head = get_content(head_path)

    body =
      if path == ["index.html"] do
        EEx.eval_file(@prefix <> "/index.html.eex", archive: get_archive())
      else
        get_content(absolute_path) ||
          get_content(String.replace_suffix(absolute_path, ".html", "/body.html"))
      end

    if body do
      html(conn, EEx.eval_file(@root, head: head, body: body))
    else
      conn
      |> put_view(SandboxWeb.ErrorView)
      |> render("404.html")
    end
  end

  defp get_content(path) do
    File.exists?(path) && File.read!(path)
  end

  defp get_archive() do
    Path.wildcard(@prefix <> "/**/*.html")
    |> Enum.reject(&String.ends_with?(&1, "body.html"))
    |> Enum.map(fn path ->
      [{_tag_name, attributes, _children_nodes}] =
        path
        |> get_content()
        |> Floki.parse_fragment!()
        |> Floki.find("meta[name=\"original-title\"]")

      title =
        case Enum.find(attributes, &(elem(&1, 0) == "content")) do
          {_, title} -> title
          _ -> nil
        end

      path =
        path
        |> String.replace_prefix(@prefix <> "/", "")
        |> String.replace_suffix("/head.html", ".html")

      %{path: path, title: title}
    end)
    |> Enum.reject(&(&1.path == "index.html"))
    |> Enum.group_by(&(&1.path |> String.split("/") |> List.first() |> String.to_integer()))
    |> Enum.sort_by(&elem(&1, 0), :desc)
  end
end
