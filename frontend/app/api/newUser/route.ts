import "dotenv/config";
import { usersTable } from "../../db/schema";
import { db } from "../../db";
import { z } from "zod";

const newUserSchema = z.object({
  telegram: z.string(),
  address: z.string().regex(/0x[a-fA-F0-9]{40}/),
});

export async function POST(req: Request) {
  try {
    const newUser = newUserSchema.safeParse(await req.json());

    if (!newUser.success) throw new Error("400");

    await db.insert(usersTable).values(newUser.data);

    return Response.json({ success: true });
  } catch (e) {
    if ((e as Error).message.includes("400")) {
      console.error("Bad Request");
      return new Response("Bad Request", { status: 400 });
    }

    console.error(e);
    return new Response("Internal Server Error", {
      status: 500,
    });
  }
}
