import { z } from "zod";

export const userSchema = z.object({
  telegram: z.string(),
  address: z.string().regex(/0x[a-fA-F0-9]{40}/),
});
