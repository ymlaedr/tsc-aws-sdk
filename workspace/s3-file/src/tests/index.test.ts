import { describe, it, expect, vi, beforeEach } from "vitest";
import { uploadFile, downloadFile } from "../index";
import fs from "node:fs";
import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { mockClient } from "aws-sdk-client-mock";

vi.mock("node:fs");
vi.mock("@aws-sdk/client-s3");

/** WriteStreamのモックを作成 */
const mockWriteStream = {
  write: vi.fn(),
  end: vi.fn(),
} as unknown as fs.WriteStream;

/**
 * createWriteStream のモック化
 * @returns モック化した fs.createWriteStream
 */
const mockCreateWriteStream = () =>
  vi.mocked(fs.createWriteStream).mockImplementation(() => mockWriteStream);

const mockS3ClientSend = (returnContent) =>
  vi
    .mocked(S3Client.prototype.send)
    .mockImplementationOnce(async () => returnContent);

describe("S3 file transfer", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.restoreAllMocks();
  });

  it("should upload a file to S3", async () => {
    mockCreateWriteStream();

    /** テスト実行 */
    await uploadFile("local-file.txt", "remote-file.txt");

    /** アサーション */
    expect(fs.createReadStream).toHaveBeenCalledWith("local-file.txt");
  });

  it("should download a file from S3", async () => {
    const client = new S3Client({});
    const mock = mockClient(client);

    /** モックデータの準備 */
    const mockData = {
      $metadata: { httpStatusCode: 200 },
      Body: Buffer.from("test data"),
    };

    /** createWriteStream のモック化 */
    mockCreateWriteStream();
    /** S3Client.send のモック化 */
    const s3ClientSendMock = mockS3ClientSend(mockData);
    
    /** テスト実行 */
    await downloadFile("remote-file.txt", "downloaded-file.txt");

    /** アサーション */
    expect(fs.createWriteStream).toHaveBeenCalledWith("downloaded-file.txt");
  });
});
