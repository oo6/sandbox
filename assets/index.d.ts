declare module "phoenix_live_view" {
  export default class LiveSocket {
    constructor(path: string);

    connect(): void;
  }
}

interface Window {
  userToken: string;
}

interface Tag {
  name: string
}

interface Recipe {
  id: string
  title: string
  description: string | null
  tags: Tag[]
}
