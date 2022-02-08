defmodule Sandbox.Repo.Migrations.NotifyMealthyRecipesChanges do
  use Ecto.Migration

  def up do
    execute """
    CREATE FUNCTION notify_mealthy_recipes_changes()
    RETURNS trigger AS $$
    DECLARE
      notice json;
    BEGIN
      notice = json_build_object(
        'operation', TG_OP,
        'record', row_to_json(NEW)
      );
      PERFORM pg_notify('mealthy_recipes_changed', notice::text);

      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql
    """

    execute """
    CREATE TRIGGER mealthy_recipes_changed
    AFTER INSERT OR UPDATE OR DELETE
    ON mealthy_recipes
    FOR EACH ROW
    EXECUTE PROCEDURE notify_mealthy_recipes_changes()
    """
  end

  def down do
    execute "DROP TRIGGER mealthy_recipes_changed ON mealthy_recipes"
    execute "DROP FUNCTION notify_mealthy_recipes_changes"
  end
end
