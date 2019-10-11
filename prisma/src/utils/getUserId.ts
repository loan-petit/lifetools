import { verify } from "jsonwebtoken";
import { Context } from "../types";

export const JWT_SECRET =
  process.env.NODE_ENV === "production"
    ? process.env.JWT_SECRET
    : "prisma-secret";

interface Token {
  userId: string;
}

export function getUserId(context: Context) {
  const Authorization = context.request.get("Authorization");
  if (Authorization) {
    const token = Authorization.replace("Bearer ", "");
    const verifiedToken = verify(token, JWT_SECRET) as Token;
    return verifiedToken && verifiedToken.userId;
  }
}
