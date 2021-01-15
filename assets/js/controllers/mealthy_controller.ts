import gql from "graphql-tag";
import { Controller } from "stimulus";

import client from "../appollo";

const fields = `
  id
  title
  description
  tags {
    name
  }
`;

const LIST_RECIPES_QUERY = gql`
  query {
    recipes {
      ${fields}
    }
  }
`;

const SEARCH_RECIPES_QUERY = gql`
  query ($q: String!) {
    search_recipes (q: $q) {
      ${fields}
    }
  }
`;

const CREATE_RECIPE_QUERY = gql`
  mutation ($title: String!, $description: String) {
    create_recipe (title: $title, description: $description) {
      ${fields}
    }
  }
`;

const UPDATE_RECIPE_QUERY = gql`
  mutation($id: ID!, $title: String!, $description: String) {
    update_recipe(id: $id, title: $title, description: $description) {
      id
    }
  }
`;

const DELETE_RECIPE_QUERY = gql`
  mutation($id: ID!) {
    delete_recipe(id: $id) {
      id
    }
  }
`;

export default class extends Controller {
  qTarget: HTMLInputElement;

  loadingTarget: Element;

  wrapperTarget: Element;

  titleTarget: HTMLInputElement;

  descriptionTarget: HTMLInputElement;

  static targets = ["q", "loading", "wrapper", "title", "description"];

  initialize() {
    this.element.id == "recipes-controller" && this._list();
  }

  search() {
    if (!this.qTarget.value) return;

    const $recipes = this.element.querySelector(".recipes");
    $recipes?.remove();

    this.loadingTarget.classList.remove("hidden");

    client
      .query({
        query: SEARCH_RECIPES_QUERY,
        variables: { q: this.qTarget.value },
      })
      .then(({ data: { search_recipes } }) => {
        this.loadingTarget.classList.add("hidden");
        this._insert(search_recipes);
      });
  }

  create() {
    if (!this.titleTarget.value) return;

    client
      .mutate({
        mutation: CREATE_RECIPE_QUERY,
        variables: {
          title: this.titleTarget.value,
          description: this.descriptionTarget.value,
        },
      })
      .then(({ data: { create_recipe } }) => {
        this.titleTarget.value = "";
        this.descriptionTarget.value = "";

        let $row = this.element.querySelector(".row:last-child");
        if ($row) {
          if ($row.childElementCount == 2) {
            $row = document.createElement("div");
            $row.className = "row";
          }

          $row.appendChild(this._template(create_recipe));

          const $recipes = this.element.querySelector(".recipes");
          $recipes?.appendChild($row);
        }
      });
  }

  update(event: Event) {
    client.mutate({
      mutation: UPDATE_RECIPE_QUERY,
      variables: {
        id: (<HTMLButtonElement>event.target).dataset["id"],
        title: this.titleTarget.value,
        description: this.descriptionTarget.value,
      },
    });
  }

  delete(event: Event) {
    client
      .mutate({
        mutation: DELETE_RECIPE_QUERY,
        variables: { id: (<HTMLButtonElement>event.target).dataset["id"] },
      })
      .then(() => (location.href = "/mealthy/recipes"));
  }

  _list() {
    client
      .query({ query: LIST_RECIPES_QUERY })
      .then(({ data: { recipes } }) => {
        this.loadingTarget.classList.add("hidden");
        this._insert(recipes);
      })
      .catch((error) => console.error(error));
  }

  _insert(recipes: Recipe[]) {
    const $recipes = document.createElement("div");
    $recipes.className = "recipes";

    for (let i = 0; i < recipes.length; i = i + 2) {
      const $row = document.createElement("div");
      $row.className = "row";
      $row.appendChild(this._template(recipes[i]));
      recipes[i + 1] && $row.appendChild(this._template(recipes[i + 1]));

      $recipes.appendChild($row);
    }

    this.wrapperTarget.appendChild($recipes);
  }

  _template(recipe: Recipe): HTMLDivElement {
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
