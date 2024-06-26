import { Injectable } from "@nestjs/common";
import { User } from "../../entity/entities/user";
import { DbService } from "../../infrastructure/db/db.service";
import { SNS } from "aws-sdk";
import { response } from "express";
import { HiHistory } from "../../entity/entities/hi-history";
import { randomUUID } from "crypto";
import * as dayjs from "dayjs";
import { TIMEZONE } from "../../utils";

@Injectable()
export class HiService {
  constructor(private dbService: DbService) {}
  async sendHi(
    sender: User | "system",
    receiver: User,
    systemMessage?: string
  ) {
    const sns = new SNS({ apiVersion: "2010-03-31" });

    const deviceTokens = await this.dbService.deviceTokens
      .find({
        userId: receiver._id,
      })
      .lean()
      .exec();

    const endpoints = await Promise.all(
      deviceTokens.map((dt) => {
        return sns
          .createPlatformEndpoint({
            PlatformApplicationArn:
              "arn:aws:sns:ap-northeast-1:862214078536:app/APNS_SANDBOX/hi",
            Token: dt.token,
          })
          .promise();
      })
    );

    const responses = await Promise.all(
      endpoints.map((ep) => {
        const params = {
          // MessageEvent: "json",
          TargetArn: ep.EndpointArn,
          Message:
            sender === "system" ? systemMessage : `Hi from ${sender.name}`,
        };
        return sns.publish(params).promise();
      })
    );

    const hiHistory: HiHistory = {
      _id: randomUUID(),
      senderUserId: sender === "system" ? sender : sender._id,
      receiverUserId: receiver._id,
      date: dayjs().tz(TIMEZONE).toDate(),
    };
    await this.dbService.hiHistories.create(hiHistory);
  }
}
