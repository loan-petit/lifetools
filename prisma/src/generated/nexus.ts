/**
 * This file was automatically generated by GraphQL Nexus
 * Do not make changes to this file directly
 */

import * as Context from "../context"
import * as photon from "@prisma/photon"



declare global {
  interface NexusGenCustomOutputProperties<TypeName extends string> {
    crud: NexusPrisma<TypeName, 'crud'>
    model: NexusPrisma<TypeName, 'model'>
  }
}

declare global {
  interface NexusGen extends NexusGenTypes {}
}

export interface NexusGenInputs {
  BooleanFilter: { // input type
    equals?: boolean | null; // Boolean
    not?: boolean | null; // Boolean
  }
  DailyRoutineEventCreateInput: { // input type
    endTime: number; // Int!
    id?: string | null; // ID
    name: string; // String!
    owner: NexusGenInputs['UserCreateOneWithoutOwnerInput']; // UserCreateOneWithoutOwnerInput!
    startTime: number; // Int!
  }
  DailyRoutineEventCreateManyWithoutDailyRoutineInput: { // input type
    connect?: NexusGenInputs['DailyRoutineEventWhereUniqueInput'][] | null; // [DailyRoutineEventWhereUniqueInput!]
    create?: NexusGenInputs['DailyRoutineEventCreateWithoutOwnerInput'][] | null; // [DailyRoutineEventCreateWithoutOwnerInput!]
  }
  DailyRoutineEventCreateWithoutOwnerInput: { // input type
    endTime: number; // Int!
    id?: string | null; // ID
    name: string; // String!
    startTime: number; // Int!
  }
  DailyRoutineEventScalarWhereInput: { // input type
    AND?: NexusGenInputs['DailyRoutineEventScalarWhereInput'][] | null; // [DailyRoutineEventScalarWhereInput!]
    endTime?: NexusGenInputs['IntFilter'] | null; // IntFilter
    id?: NexusGenInputs['StringFilter'] | null; // StringFilter
    name?: NexusGenInputs['StringFilter'] | null; // StringFilter
    NOT?: NexusGenInputs['DailyRoutineEventScalarWhereInput'][] | null; // [DailyRoutineEventScalarWhereInput!]
    OR?: NexusGenInputs['DailyRoutineEventScalarWhereInput'][] | null; // [DailyRoutineEventScalarWhereInput!]
    startTime?: NexusGenInputs['IntFilter'] | null; // IntFilter
  }
  DailyRoutineEventUpdateInput: { // input type
    endTime?: number | null; // Int
    id?: string | null; // ID
    name?: string | null; // String
    owner?: NexusGenInputs['UserUpdateOneRequiredWithoutDailyRoutineInput'] | null; // UserUpdateOneRequiredWithoutDailyRoutineInput
    startTime?: number | null; // Int
  }
  DailyRoutineEventUpdateManyDataInput: { // input type
    endTime?: number | null; // Int
    id?: string | null; // ID
    name?: string | null; // String
    startTime?: number | null; // Int
  }
  DailyRoutineEventUpdateManyWithWhereNestedInput: { // input type
    data: NexusGenInputs['DailyRoutineEventUpdateManyDataInput']; // DailyRoutineEventUpdateManyDataInput!
    where: NexusGenInputs['DailyRoutineEventScalarWhereInput']; // DailyRoutineEventScalarWhereInput!
  }
  DailyRoutineEventUpdateManyWithoutOwnerInput: { // input type
    connect?: NexusGenInputs['DailyRoutineEventWhereUniqueInput'][] | null; // [DailyRoutineEventWhereUniqueInput!]
    create?: NexusGenInputs['DailyRoutineEventCreateWithoutOwnerInput'][] | null; // [DailyRoutineEventCreateWithoutOwnerInput!]
    delete?: NexusGenInputs['DailyRoutineEventWhereUniqueInput'][] | null; // [DailyRoutineEventWhereUniqueInput!]
    deleteMany?: NexusGenInputs['DailyRoutineEventScalarWhereInput'][] | null; // [DailyRoutineEventScalarWhereInput!]
    disconnect?: NexusGenInputs['DailyRoutineEventWhereUniqueInput'][] | null; // [DailyRoutineEventWhereUniqueInput!]
    set?: NexusGenInputs['DailyRoutineEventWhereUniqueInput'][] | null; // [DailyRoutineEventWhereUniqueInput!]
    update?: NexusGenInputs['DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput'][] | null; // [DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput!]
    updateMany?: NexusGenInputs['DailyRoutineEventUpdateManyWithWhereNestedInput'][] | null; // [DailyRoutineEventUpdateManyWithWhereNestedInput!]
    upsert?: NexusGenInputs['DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput'][] | null; // [DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput!]
  }
  DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput: { // input type
    data: NexusGenInputs['DailyRoutineEventUpdateWithoutOwnerDataInput']; // DailyRoutineEventUpdateWithoutOwnerDataInput!
    where: NexusGenInputs['DailyRoutineEventWhereUniqueInput']; // DailyRoutineEventWhereUniqueInput!
  }
  DailyRoutineEventUpdateWithoutOwnerDataInput: { // input type
    endTime?: number | null; // Int
    id?: string | null; // ID
    name?: string | null; // String
    startTime?: number | null; // Int
  }
  DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput: { // input type
    create: NexusGenInputs['DailyRoutineEventCreateWithoutOwnerInput']; // DailyRoutineEventCreateWithoutOwnerInput!
    update: NexusGenInputs['DailyRoutineEventUpdateWithoutOwnerDataInput']; // DailyRoutineEventUpdateWithoutOwnerDataInput!
    where: NexusGenInputs['DailyRoutineEventWhereUniqueInput']; // DailyRoutineEventWhereUniqueInput!
  }
  DailyRoutineEventWhereUniqueInput: { // input type
    id?: string | null; // ID
  }
  DateTimeFilter: { // input type
    equals?: any | null; // DateTime
    gt?: any | null; // DateTime
    gte?: any | null; // DateTime
    in?: any[] | null; // [DateTime!]
    lt?: any | null; // DateTime
    lte?: any | null; // DateTime
    not?: any | null; // DateTime
    notIn?: any[] | null; // [DateTime!]
  }
  GoalCreateInput: { // input type
    date: any; // DateTime!
    id?: string | null; // ID
    isCompleted?: boolean | null; // Boolean
    name: string; // String!
    owner: NexusGenInputs['UserCreateOneWithoutOwnerInput']; // UserCreateOneWithoutOwnerInput!
  }
  GoalCreateManyWithoutGoalsInput: { // input type
    connect?: NexusGenInputs['GoalWhereUniqueInput'][] | null; // [GoalWhereUniqueInput!]
    create?: NexusGenInputs['GoalCreateWithoutOwnerInput'][] | null; // [GoalCreateWithoutOwnerInput!]
  }
  GoalCreateWithoutOwnerInput: { // input type
    date: any; // DateTime!
    id?: string | null; // ID
    isCompleted?: boolean | null; // Boolean
    name: string; // String!
  }
  GoalScalarWhereInput: { // input type
    AND?: NexusGenInputs['GoalScalarWhereInput'][] | null; // [GoalScalarWhereInput!]
    date?: NexusGenInputs['DateTimeFilter'] | null; // DateTimeFilter
    id?: NexusGenInputs['StringFilter'] | null; // StringFilter
    isCompleted?: NexusGenInputs['BooleanFilter'] | null; // BooleanFilter
    name?: NexusGenInputs['StringFilter'] | null; // StringFilter
    NOT?: NexusGenInputs['GoalScalarWhereInput'][] | null; // [GoalScalarWhereInput!]
    OR?: NexusGenInputs['GoalScalarWhereInput'][] | null; // [GoalScalarWhereInput!]
  }
  GoalUpdateInput: { // input type
    date?: any | null; // DateTime
    id?: string | null; // ID
    isCompleted?: boolean | null; // Boolean
    name?: string | null; // String
    owner?: NexusGenInputs['UserUpdateOneRequiredWithoutGoalsInput'] | null; // UserUpdateOneRequiredWithoutGoalsInput
  }
  GoalUpdateManyDataInput: { // input type
    date?: any | null; // DateTime
    id?: string | null; // ID
    isCompleted?: boolean | null; // Boolean
    name?: string | null; // String
  }
  GoalUpdateManyWithWhereNestedInput: { // input type
    data: NexusGenInputs['GoalUpdateManyDataInput']; // GoalUpdateManyDataInput!
    where: NexusGenInputs['GoalScalarWhereInput']; // GoalScalarWhereInput!
  }
  GoalUpdateManyWithoutOwnerInput: { // input type
    connect?: NexusGenInputs['GoalWhereUniqueInput'][] | null; // [GoalWhereUniqueInput!]
    create?: NexusGenInputs['GoalCreateWithoutOwnerInput'][] | null; // [GoalCreateWithoutOwnerInput!]
    delete?: NexusGenInputs['GoalWhereUniqueInput'][] | null; // [GoalWhereUniqueInput!]
    deleteMany?: NexusGenInputs['GoalScalarWhereInput'][] | null; // [GoalScalarWhereInput!]
    disconnect?: NexusGenInputs['GoalWhereUniqueInput'][] | null; // [GoalWhereUniqueInput!]
    set?: NexusGenInputs['GoalWhereUniqueInput'][] | null; // [GoalWhereUniqueInput!]
    update?: NexusGenInputs['GoalUpdateWithWhereUniqueWithoutOwnerInput'][] | null; // [GoalUpdateWithWhereUniqueWithoutOwnerInput!]
    updateMany?: NexusGenInputs['GoalUpdateManyWithWhereNestedInput'][] | null; // [GoalUpdateManyWithWhereNestedInput!]
    upsert?: NexusGenInputs['GoalUpsertWithWhereUniqueWithoutOwnerInput'][] | null; // [GoalUpsertWithWhereUniqueWithoutOwnerInput!]
  }
  GoalUpdateWithWhereUniqueWithoutOwnerInput: { // input type
    data: NexusGenInputs['GoalUpdateWithoutOwnerDataInput']; // GoalUpdateWithoutOwnerDataInput!
    where: NexusGenInputs['GoalWhereUniqueInput']; // GoalWhereUniqueInput!
  }
  GoalUpdateWithoutOwnerDataInput: { // input type
    date?: any | null; // DateTime
    id?: string | null; // ID
    isCompleted?: boolean | null; // Boolean
    name?: string | null; // String
  }
  GoalUpsertWithWhereUniqueWithoutOwnerInput: { // input type
    create: NexusGenInputs['GoalCreateWithoutOwnerInput']; // GoalCreateWithoutOwnerInput!
    update: NexusGenInputs['GoalUpdateWithoutOwnerDataInput']; // GoalUpdateWithoutOwnerDataInput!
    where: NexusGenInputs['GoalWhereUniqueInput']; // GoalWhereUniqueInput!
  }
  GoalWhereUniqueInput: { // input type
    id?: string | null; // ID
  }
  IntFilter: { // input type
    equals?: number | null; // Int
    gt?: number | null; // Int
    gte?: number | null; // Int
    in?: number[] | null; // [Int!]
    lt?: number | null; // Int
    lte?: number | null; // Int
    not?: number | null; // Int
    notIn?: number[] | null; // [Int!]
  }
  StringFilter: { // input type
    contains?: string | null; // String
    endsWith?: string | null; // String
    equals?: string | null; // String
    gt?: string | null; // String
    gte?: string | null; // String
    in?: string[] | null; // [String!]
    lt?: string | null; // String
    lte?: string | null; // String
    not?: string | null; // String
    notIn?: string[] | null; // [String!]
    startsWith?: string | null; // String
  }
  UserCreateOneWithoutOwnerInput: { // input type
    connect?: NexusGenInputs['UserWhereUniqueInput'] | null; // UserWhereUniqueInput
    create?: NexusGenInputs['UserCreateWithoutDailyRoutineInput'] | null; // UserCreateWithoutDailyRoutineInput
  }
  UserCreateWithoutDailyRoutineInput: { // input type
    createdAt?: any | null; // DateTime
    email: string; // String!
    goals?: NexusGenInputs['GoalCreateManyWithoutGoalsInput'] | null; // GoalCreateManyWithoutGoalsInput
    id?: string | null; // ID
    password: string; // String!
  }
  UserCreateWithoutGoalsInput: { // input type
    createdAt?: any | null; // DateTime
    dailyRoutine?: NexusGenInputs['DailyRoutineEventCreateManyWithoutDailyRoutineInput'] | null; // DailyRoutineEventCreateManyWithoutDailyRoutineInput
    email: string; // String!
    id?: string | null; // ID
    password: string; // String!
  }
  UserUpdateInput: { // input type
    createdAt?: any | null; // DateTime
    dailyRoutine?: NexusGenInputs['DailyRoutineEventUpdateManyWithoutOwnerInput'] | null; // DailyRoutineEventUpdateManyWithoutOwnerInput
    email?: string | null; // String
    goals?: NexusGenInputs['GoalUpdateManyWithoutOwnerInput'] | null; // GoalUpdateManyWithoutOwnerInput
    id?: string | null; // ID
    password?: string | null; // String
  }
  UserUpdateOneRequiredWithoutDailyRoutineInput: { // input type
    connect?: NexusGenInputs['UserWhereUniqueInput'] | null; // UserWhereUniqueInput
    create?: NexusGenInputs['UserCreateWithoutDailyRoutineInput'] | null; // UserCreateWithoutDailyRoutineInput
    update?: NexusGenInputs['UserUpdateWithoutDailyRoutineDataInput'] | null; // UserUpdateWithoutDailyRoutineDataInput
    upsert?: NexusGenInputs['UserUpsertWithoutDailyRoutineInput'] | null; // UserUpsertWithoutDailyRoutineInput
  }
  UserUpdateOneRequiredWithoutGoalsInput: { // input type
    connect?: NexusGenInputs['UserWhereUniqueInput'] | null; // UserWhereUniqueInput
    create?: NexusGenInputs['UserCreateWithoutGoalsInput'] | null; // UserCreateWithoutGoalsInput
    update?: NexusGenInputs['UserUpdateWithoutGoalsDataInput'] | null; // UserUpdateWithoutGoalsDataInput
    upsert?: NexusGenInputs['UserUpsertWithoutGoalsInput'] | null; // UserUpsertWithoutGoalsInput
  }
  UserUpdateWithoutDailyRoutineDataInput: { // input type
    createdAt?: any | null; // DateTime
    email?: string | null; // String
    goals?: NexusGenInputs['GoalUpdateManyWithoutOwnerInput'] | null; // GoalUpdateManyWithoutOwnerInput
    id?: string | null; // ID
    password?: string | null; // String
  }
  UserUpdateWithoutGoalsDataInput: { // input type
    createdAt?: any | null; // DateTime
    dailyRoutine?: NexusGenInputs['DailyRoutineEventUpdateManyWithoutOwnerInput'] | null; // DailyRoutineEventUpdateManyWithoutOwnerInput
    email?: string | null; // String
    id?: string | null; // ID
    password?: string | null; // String
  }
  UserUpsertWithoutDailyRoutineInput: { // input type
    create: NexusGenInputs['UserCreateWithoutDailyRoutineInput']; // UserCreateWithoutDailyRoutineInput!
    update: NexusGenInputs['UserUpdateWithoutDailyRoutineDataInput']; // UserUpdateWithoutDailyRoutineDataInput!
  }
  UserUpsertWithoutGoalsInput: { // input type
    create: NexusGenInputs['UserCreateWithoutGoalsInput']; // UserCreateWithoutGoalsInput!
    update: NexusGenInputs['UserUpdateWithoutGoalsDataInput']; // UserUpdateWithoutGoalsDataInput!
  }
  UserWhereUniqueInput: { // input type
    email?: string | null; // String
    id?: string | null; // ID
  }
}

export interface NexusGenEnums {
}

export interface NexusGenRootTypes {
  AuthPayload: { // root type
    expiresIn: number; // Int!
    token: string; // String!
    user: NexusGenRootTypes['User']; // User!
  }
  DailyRoutineEvent: photon.DailyRoutineEvent;
  Goal: photon.Goal;
  Mutation: {};
  Query: {};
  User: photon.User;
  String: string;
  Int: number;
  Float: number;
  Boolean: boolean;
  ID: string;
  DateTime: any;
}

export interface NexusGenAllTypes extends NexusGenRootTypes {
  BooleanFilter: NexusGenInputs['BooleanFilter'];
  DailyRoutineEventCreateInput: NexusGenInputs['DailyRoutineEventCreateInput'];
  DailyRoutineEventCreateManyWithoutDailyRoutineInput: NexusGenInputs['DailyRoutineEventCreateManyWithoutDailyRoutineInput'];
  DailyRoutineEventCreateWithoutOwnerInput: NexusGenInputs['DailyRoutineEventCreateWithoutOwnerInput'];
  DailyRoutineEventScalarWhereInput: NexusGenInputs['DailyRoutineEventScalarWhereInput'];
  DailyRoutineEventUpdateInput: NexusGenInputs['DailyRoutineEventUpdateInput'];
  DailyRoutineEventUpdateManyDataInput: NexusGenInputs['DailyRoutineEventUpdateManyDataInput'];
  DailyRoutineEventUpdateManyWithWhereNestedInput: NexusGenInputs['DailyRoutineEventUpdateManyWithWhereNestedInput'];
  DailyRoutineEventUpdateManyWithoutOwnerInput: NexusGenInputs['DailyRoutineEventUpdateManyWithoutOwnerInput'];
  DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput: NexusGenInputs['DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput'];
  DailyRoutineEventUpdateWithoutOwnerDataInput: NexusGenInputs['DailyRoutineEventUpdateWithoutOwnerDataInput'];
  DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput: NexusGenInputs['DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput'];
  DailyRoutineEventWhereUniqueInput: NexusGenInputs['DailyRoutineEventWhereUniqueInput'];
  DateTimeFilter: NexusGenInputs['DateTimeFilter'];
  GoalCreateInput: NexusGenInputs['GoalCreateInput'];
  GoalCreateManyWithoutGoalsInput: NexusGenInputs['GoalCreateManyWithoutGoalsInput'];
  GoalCreateWithoutOwnerInput: NexusGenInputs['GoalCreateWithoutOwnerInput'];
  GoalScalarWhereInput: NexusGenInputs['GoalScalarWhereInput'];
  GoalUpdateInput: NexusGenInputs['GoalUpdateInput'];
  GoalUpdateManyDataInput: NexusGenInputs['GoalUpdateManyDataInput'];
  GoalUpdateManyWithWhereNestedInput: NexusGenInputs['GoalUpdateManyWithWhereNestedInput'];
  GoalUpdateManyWithoutOwnerInput: NexusGenInputs['GoalUpdateManyWithoutOwnerInput'];
  GoalUpdateWithWhereUniqueWithoutOwnerInput: NexusGenInputs['GoalUpdateWithWhereUniqueWithoutOwnerInput'];
  GoalUpdateWithoutOwnerDataInput: NexusGenInputs['GoalUpdateWithoutOwnerDataInput'];
  GoalUpsertWithWhereUniqueWithoutOwnerInput: NexusGenInputs['GoalUpsertWithWhereUniqueWithoutOwnerInput'];
  GoalWhereUniqueInput: NexusGenInputs['GoalWhereUniqueInput'];
  IntFilter: NexusGenInputs['IntFilter'];
  StringFilter: NexusGenInputs['StringFilter'];
  UserCreateOneWithoutOwnerInput: NexusGenInputs['UserCreateOneWithoutOwnerInput'];
  UserCreateWithoutDailyRoutineInput: NexusGenInputs['UserCreateWithoutDailyRoutineInput'];
  UserCreateWithoutGoalsInput: NexusGenInputs['UserCreateWithoutGoalsInput'];
  UserUpdateInput: NexusGenInputs['UserUpdateInput'];
  UserUpdateOneRequiredWithoutDailyRoutineInput: NexusGenInputs['UserUpdateOneRequiredWithoutDailyRoutineInput'];
  UserUpdateOneRequiredWithoutGoalsInput: NexusGenInputs['UserUpdateOneRequiredWithoutGoalsInput'];
  UserUpdateWithoutDailyRoutineDataInput: NexusGenInputs['UserUpdateWithoutDailyRoutineDataInput'];
  UserUpdateWithoutGoalsDataInput: NexusGenInputs['UserUpdateWithoutGoalsDataInput'];
  UserUpsertWithoutDailyRoutineInput: NexusGenInputs['UserUpsertWithoutDailyRoutineInput'];
  UserUpsertWithoutGoalsInput: NexusGenInputs['UserUpsertWithoutGoalsInput'];
  UserWhereUniqueInput: NexusGenInputs['UserWhereUniqueInput'];
}

export interface NexusGenFieldTypes {
  AuthPayload: { // field return type
    expiresIn: number; // Int!
    token: string; // String!
    user: NexusGenRootTypes['User']; // User!
  }
  DailyRoutineEvent: { // field return type
    endTime: number; // Int!
    id: string; // ID!
    name: string; // String!
    owner: NexusGenRootTypes['User']; // User!
    startTime: number; // Int!
  }
  Goal: { // field return type
    date: any; // DateTime!
    id: string; // ID!
    isCompleted: boolean; // Boolean!
    name: string; // String!
    owner: NexusGenRootTypes['User']; // User!
  }
  Mutation: { // field return type
    createOneDailyRoutineEvent: NexusGenRootTypes['DailyRoutineEvent']; // DailyRoutineEvent!
    createOneGoal: NexusGenRootTypes['Goal']; // Goal!
    deleteOneDailyRoutineEvent: NexusGenRootTypes['DailyRoutineEvent'] | null; // DailyRoutineEvent
    deleteOneGoal: NexusGenRootTypes['Goal'] | null; // Goal
    deleteOneUser: NexusGenRootTypes['User'] | null; // User
    signin: NexusGenRootTypes['AuthPayload']; // AuthPayload!
    signup: NexusGenRootTypes['AuthPayload']; // AuthPayload!
    updateOneDailyRoutineEvent: NexusGenRootTypes['DailyRoutineEvent'] | null; // DailyRoutineEvent
    updateOneGoal: NexusGenRootTypes['Goal'] | null; // Goal
    updateOneUser: NexusGenRootTypes['User'] | null; // User
  }
  Query: { // field return type
    dailyRoutineEvent: NexusGenRootTypes['DailyRoutineEvent'] | null; // DailyRoutineEvent
    dailyRoutineEvents: NexusGenRootTypes['DailyRoutineEvent'][]; // [DailyRoutineEvent!]!
    goal: NexusGenRootTypes['Goal'] | null; // Goal
    goals: NexusGenRootTypes['Goal'][]; // [Goal!]!
    me: NexusGenRootTypes['AuthPayload']; // AuthPayload!
    user: NexusGenRootTypes['User'] | null; // User
    users: NexusGenRootTypes['User'][]; // [User!]!
  }
  User: { // field return type
    dailyRoutine: NexusGenRootTypes['DailyRoutineEvent'][]; // [DailyRoutineEvent!]!
    goals: NexusGenRootTypes['Goal'][]; // [Goal!]!
    id: string; // ID!
  }
}

export interface NexusGenArgTypes {
  Mutation: {
    createOneDailyRoutineEvent: { // args
      data: NexusGenInputs['DailyRoutineEventCreateInput']; // DailyRoutineEventCreateInput!
    }
    createOneGoal: { // args
      data: NexusGenInputs['GoalCreateInput']; // GoalCreateInput!
    }
    deleteOneDailyRoutineEvent: { // args
      where: NexusGenInputs['DailyRoutineEventWhereUniqueInput']; // DailyRoutineEventWhereUniqueInput!
    }
    deleteOneGoal: { // args
      where: NexusGenInputs['GoalWhereUniqueInput']; // GoalWhereUniqueInput!
    }
    deleteOneUser: { // args
      where: NexusGenInputs['UserWhereUniqueInput']; // UserWhereUniqueInput!
    }
    signin: { // args
      email: string; // String!
      password: string; // String!
    }
    signup: { // args
      email: string; // String!
      password: string; // String!
      passwordConfirmation: string; // String!
    }
    updateOneDailyRoutineEvent: { // args
      data: NexusGenInputs['DailyRoutineEventUpdateInput']; // DailyRoutineEventUpdateInput!
      where: NexusGenInputs['DailyRoutineEventWhereUniqueInput']; // DailyRoutineEventWhereUniqueInput!
    }
    updateOneGoal: { // args
      data: NexusGenInputs['GoalUpdateInput']; // GoalUpdateInput!
      where: NexusGenInputs['GoalWhereUniqueInput']; // GoalWhereUniqueInput!
    }
    updateOneUser: { // args
      data: NexusGenInputs['UserUpdateInput']; // UserUpdateInput!
      where: NexusGenInputs['UserWhereUniqueInput']; // UserWhereUniqueInput!
    }
  }
  Query: {
    dailyRoutineEvent: { // args
      where: NexusGenInputs['DailyRoutineEventWhereUniqueInput']; // DailyRoutineEventWhereUniqueInput!
    }
    dailyRoutineEvents: { // args
      after?: string | null; // ID
      before?: string | null; // ID
      first?: number | null; // Int
      last?: number | null; // Int
      skip?: number | null; // Int
    }
    goal: { // args
      where: NexusGenInputs['GoalWhereUniqueInput']; // GoalWhereUniqueInput!
    }
    goals: { // args
      after?: string | null; // ID
      before?: string | null; // ID
      first?: number | null; // Int
      last?: number | null; // Int
      skip?: number | null; // Int
    }
    user: { // args
      where: NexusGenInputs['UserWhereUniqueInput']; // UserWhereUniqueInput!
    }
    users: { // args
      after?: string | null; // ID
      before?: string | null; // ID
      first?: number | null; // Int
      last?: number | null; // Int
      skip?: number | null; // Int
    }
  }
  User: {
    dailyRoutine: { // args
      after?: string | null; // ID
      before?: string | null; // ID
      first?: number | null; // Int
      last?: number | null; // Int
      skip?: number | null; // Int
    }
    goals: { // args
      after?: string | null; // ID
      before?: string | null; // ID
      first?: number | null; // Int
      last?: number | null; // Int
      skip?: number | null; // Int
    }
  }
}

export interface NexusGenAbstractResolveReturnTypes {
}

export interface NexusGenInheritedFields {}

export type NexusGenObjectNames = "AuthPayload" | "DailyRoutineEvent" | "Goal" | "Mutation" | "Query" | "User";

export type NexusGenInputNames = "BooleanFilter" | "DailyRoutineEventCreateInput" | "DailyRoutineEventCreateManyWithoutDailyRoutineInput" | "DailyRoutineEventCreateWithoutOwnerInput" | "DailyRoutineEventScalarWhereInput" | "DailyRoutineEventUpdateInput" | "DailyRoutineEventUpdateManyDataInput" | "DailyRoutineEventUpdateManyWithWhereNestedInput" | "DailyRoutineEventUpdateManyWithoutOwnerInput" | "DailyRoutineEventUpdateWithWhereUniqueWithoutOwnerInput" | "DailyRoutineEventUpdateWithoutOwnerDataInput" | "DailyRoutineEventUpsertWithWhereUniqueWithoutOwnerInput" | "DailyRoutineEventWhereUniqueInput" | "DateTimeFilter" | "GoalCreateInput" | "GoalCreateManyWithoutGoalsInput" | "GoalCreateWithoutOwnerInput" | "GoalScalarWhereInput" | "GoalUpdateInput" | "GoalUpdateManyDataInput" | "GoalUpdateManyWithWhereNestedInput" | "GoalUpdateManyWithoutOwnerInput" | "GoalUpdateWithWhereUniqueWithoutOwnerInput" | "GoalUpdateWithoutOwnerDataInput" | "GoalUpsertWithWhereUniqueWithoutOwnerInput" | "GoalWhereUniqueInput" | "IntFilter" | "StringFilter" | "UserCreateOneWithoutOwnerInput" | "UserCreateWithoutDailyRoutineInput" | "UserCreateWithoutGoalsInput" | "UserUpdateInput" | "UserUpdateOneRequiredWithoutDailyRoutineInput" | "UserUpdateOneRequiredWithoutGoalsInput" | "UserUpdateWithoutDailyRoutineDataInput" | "UserUpdateWithoutGoalsDataInput" | "UserUpsertWithoutDailyRoutineInput" | "UserUpsertWithoutGoalsInput" | "UserWhereUniqueInput";

export type NexusGenEnumNames = never;

export type NexusGenInterfaceNames = never;

export type NexusGenScalarNames = "Boolean" | "DateTime" | "Float" | "ID" | "Int" | "String";

export type NexusGenUnionNames = never;

export interface NexusGenTypes {
  context: Context.Context;
  inputTypes: NexusGenInputs;
  rootTypes: NexusGenRootTypes;
  argTypes: NexusGenArgTypes;
  fieldTypes: NexusGenFieldTypes;
  allTypes: NexusGenAllTypes;
  inheritedFields: NexusGenInheritedFields;
  objectNames: NexusGenObjectNames;
  inputNames: NexusGenInputNames;
  enumNames: NexusGenEnumNames;
  interfaceNames: NexusGenInterfaceNames;
  scalarNames: NexusGenScalarNames;
  unionNames: NexusGenUnionNames;
  allInputTypes: NexusGenTypes['inputNames'] | NexusGenTypes['enumNames'] | NexusGenTypes['scalarNames'];
  allOutputTypes: NexusGenTypes['objectNames'] | NexusGenTypes['enumNames'] | NexusGenTypes['unionNames'] | NexusGenTypes['interfaceNames'] | NexusGenTypes['scalarNames'];
  allNamedTypes: NexusGenTypes['allInputTypes'] | NexusGenTypes['allOutputTypes']
  abstractTypes: NexusGenTypes['interfaceNames'] | NexusGenTypes['unionNames'];
  abstractResolveReturn: NexusGenAbstractResolveReturnTypes;
}


declare global {
  interface NexusGenPluginTypeConfig<TypeName extends string> {
  }
  interface NexusGenPluginFieldConfig<TypeName extends string, FieldName extends string> {
  }
  interface NexusGenPluginSchemaConfig {
  }
}