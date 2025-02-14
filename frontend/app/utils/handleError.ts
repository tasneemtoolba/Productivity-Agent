export function handleError(e: Error) {
  if ((e as Error).message.includes("400")) {
    console.error("Bad Request");
    return new Response("Bad Request", { status: 400 });
  }

  console.error(e);
  return new Response("Internal Server Error", {
    status: 500,
  });
}
