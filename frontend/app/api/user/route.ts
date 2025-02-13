import "dotenv/config";
import { usersTable } from "../../db/schema";
import { db } from "../../db";
import { z } from "zod";
import { handleError } from "@/app/utils/handleError";
import { type NextRequest } from "next/server";
import { eq } from "drizzle-orm";

const newUserSchema = z.object({
  telegram: z.string(),
  address: z.string().regex(/0x[a-fA-F0-9]{40}/),
});

export async function GET(req: NextRequest) {
  try {
    const searchParams = req.nextUrl.searchParams;
    const _address = searchParams.get("address");

    if (_address === null) throw new Error("400");

    const user = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.address, _address))
      .limit(1);

    return Response.json({
      linkedTelegram: typeof user[0]?.telegram === "string",
    });
  } catch (e) {
    return handleError(e as Error);
  }
}

export async function POST(req: Request) {
  try {
    const newUser = newUserSchema.safeParse(await req.json());

    if (!newUser.success) throw new Error("400");

    await db.insert(usersTable).values(newUser.data);

    return Response.json({ success: true });
  } catch (e) {
    return handleError(e as Error);
  }
}
