import { GraphQLClient, gql } from "graphql-request";
import { Controller } from "@hotwired/stimulus";

const client = new GraphQLClient("/graphql");

const fields = gql`
  fragment RecipeFields on Recipe {
    id
    title
    description
    tags {
      name
    }
  }
`;

const LIST_RECIPES_QUERY = gql`
  ${fields}
  query {
    recipes {
      ...RecipeFields
    }
  }
`;

const SEARCH_RECIPES_QUERY = gql`
  ${fields}
  query ($q: String!) {
    search_recipes(q: $q) {
      ...RecipeFields
    }
  }
`;

const CREATE_RECIPE_QUERY = gql`
  ${fields}
  mutation ($title: String!, $description: String) {
    create_recipe(title: $title, description: $description) {
      ...RecipeFields
    }
  }
`;

const UPDATE_RECIPE_QUERY = gql`
  mutation ($id: ID!, $title: String!, $description: String) {
    update_recipe(id: $id, title: $title, description: $description) {
      id
    }
  }
`;

const DELETE_RECIPE_QUERY = gql`
  mutation ($id: ID!) {
    delete_recipe(id: $id) {
      id
    }
  }
`;

export default class extends Controller {
  declare readonly qTarget: HTMLInputElement;

  declare readonly loadingTarget: Element;

  declare readonly wrapperTarget: Element;

  declare readonly titleTarget: HTMLInputElement;

  declare readonly descriptionTarget: HTMLInputElement;

  static targets = ["q", "loading", "wrapper", "title", "description"];

  initialize(): void {
    this.element.id == "recipes-controller" && this.#list();
  }

  search(): void {
    if (!this.qTarget.value) return;

    const $recipes = this.element.querySelector(".recipes");
    $recipes?.remove();

    this.loadingTarget.classList.remove("hidden");

    client
      .request(SEARCH_RECIPES_QUERY, { q: this.qTarget.value })
      .then(({ search_recipes }) => {
        this.loadingTarget.classList.add("hidden");
        this.#insert(search_recipes);
      });
  }

  create(): void {
    if (!this.titleTarget.value) return;

    client
      .request(CREATE_RECIPE_QUERY, {
        title: this.titleTarget.value,
        description: this.descriptionTarget.value,
      })
      .then(({ create_recipe }) => {
        this.titleTarget.value = "";
        this.descriptionTarget.value = "";

        let $row = this.element.querySelector(".row:last-child");
        if ($row) {
          if ($row.childElementCount == 2) {
            $row = document.createElement("div");
            $row.className = "row";
          }

          $row.appendChild(this.#template(create_recipe));

          const $recipes = this.element.querySelector(".recipes");
          $recipes?.appendChild($row);
        }
      });
  }

  update(event: Event): void {
    client.request(UPDATE_RECIPE_QUERY, {
      id: (<HTMLButtonElement>event.target).dataset["id"],
      title: this.titleTarget.value,
      description: this.descriptionTarget.value,
    });
  }

  delete(event: Event): void {
    client
      .request(DELETE_RECIPE_QUERY, {
        id: (<HTMLButtonElement>event.target).dataset["id"],
      })
      .then(() => (location.href = "/mealthy/recipes"));
  }

  #list(): void {
    client.request(LIST_RECIPES_QUERY).then(({ recipes }) => {
      this.loadingTarget.classList.add("hidden");
      this.#insert(recipes);
    });
  }

  #insert(recipes: Recipe[]): void {
    const $recipes = document.createElement("div");
    $recipes.className = "recipes";

    for (let i = 0; i < recipes.length; i = i + 2) {
      const $row = document.createElement("div");
      $row.className = "row";
      $row.appendChild(this.#template(recipes[i]));
      recipes[i + 1] && $row.appendChild(this.#template(recipes[i + 1]));

      $recipes.appendChild($row);
    }

    this.wrapperTarget.appendChild($recipes);
  }

  #template(recipe: Recipe): HTMLDivElement {
    const $recipe = document.createElement("div");
    $recipe.className = "column";
    $recipe.innerHTML = `
      <h4><a href="/mealthy/recipes/${recipe.id}/edit">${recipe.title}</a></h4>
      <small>${recipe.tags.map(({ name }) => name).join(", ")}</small>
      <p>${recipe.description || ""}</p>
    `;

    return $recipe;
  }
}
