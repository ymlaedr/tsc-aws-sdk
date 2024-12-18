import {
  S3Client,
  PutObjectCommand,
  GetObjectCommand,
} from "@aws-sdk/client-s3";
import fs from "node:fs";

const s3Client = new S3Client({ region: "ap-northeast-1" }); // ご自身のリージョンに置き換えてください
const bucketName = "s3-file"; // ご自身のバケット名に置き換えてください

// ファイルをS3にアップロードする関数
export const uploadFile = async (
  filePath: string,
  key: string
): Promise<void> => {
  const fileStream = fs.createReadStream(filePath);

  const params = {
    Bucket: bucketName,
    Key: key,
    Body: fileStream,
  };

  try {
    await s3Client.send(new PutObjectCommand(params));
    console.log(`File uploaded successfully.`);
  } catch (err: unknown) {
    console.error(err);
    throw err;
  }
};

// S3からファイルをダウンロードする関数
export const downloadFile = async (
  key: string,
  filePath: string
): Promise<void> => {
  const params = {
    Bucket: bucketName,
    Key: key,
  };

  try {
    const data = await s3Client.send(new GetObjectCommand(params));
    const file = fs.createWriteStream(filePath);
    console.log(typeof data.Body);
    file.write(data.Body);
    file.end();

    // data.Body?.pipe(file);
    console.log(`File downloaded successfully.`);
  } catch (err: unknown) {
    console.error(err);
    throw err;
  }
};
