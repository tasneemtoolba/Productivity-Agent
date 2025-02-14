import "dotenv/config";
import { tasksTable, usersTable } from "../../db/schema";
import { db } from "../../db";
import { handleError } from "@/app/utils/handleError";
import { type NextRequest } from "next/server";
import { eq } from "drizzle-orm";
import { userSchema } from "@/app/schemas/user.schema";

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

    if (user.length === 1) {
      return Response.json({ status: "success", user: user[0] });
    }

    return Response.json({ status: "unknown" });
  } catch (e) {
    return handleError(e as Error);
  }
}

export async function POST(req: Request) {
  try {
    const newUser = userSchema.safeParse(await req.json());

    if (!newUser.success) throw new Error("400");

    // TODO validate that telgram and wallet don't already exist

    await db.insert(usersTable).values({
      address: newUser.data.address.toLowerCase(),
      telegram: newUser.data.address.toLowerCase(),
    });

    return Response.json({ success: true });
  } catch (e) {
    return handleError(e as Error);
  }
}
