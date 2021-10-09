declare module "phoenix_live_view" {
  import type { Socket } from "phoenix";
  export class LiveSocket {
    constructor(path: string, socket: typeof Socket, params: unknown);

    connect(): void;
  }
}

interface Window {
  userToken: string;
}

interface Tag {
  name: string;
}

interface Recipe {
  id: string;
  title: string;
  description: string | null;
  tags: Tag[];
}
