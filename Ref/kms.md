# aws-kms-demo
⚠️⚠️⚠️：尽量使用一个 KMS 进行练习 💰💰💰

## Basic

- Pre
    ```
  - KMS: AWS Key Management Service
  - CMK: Customer master keys
  Alias: s=aws --profile xxx --regon xxx
  ```

- KMS 是什么服务？能解决什么问题？
    ```
  AWS KMS 是一项托管式服务，让您能够轻松地创建和控制用于加密操作的密钥(即用于加密您的数据的加密密钥)
  该服务为您提供可用性高的密钥生成、存储、管理和审计解决方案，
  让您可以在自己的应用程序内加密您的数据或以数字方式对数据签名，
  并在 AWS 服务之间对数据的加密进行控制。
  ```

- 使用 KMS key 的方式有哪些？
    ```
  可用使用对称或非对称 CMK 加密、解密和重新加密数据，使用非对称 CMK 签署和验证消息，生成可导出的对称数据密钥和非对称数据密钥对，生成适合密码应用的随机数。

  对于如何使用 AWS KMS 加密数据，通常有三种情况。⚠️
  第一种情况，您可以利用存储在该服务中的 CMK，直接通过 AWS KMS API 加密和解密数据。
  第二种情况，您可以选择使用存储在该服务中的 CMK 通过 AWS 服务加密您的数据。在这种情况中，数据通过由 CMK 保护的数据密钥进行加密。
  第三种情况，您可以使用集成到 AWS KMS 的 AWS Encryption SDK 在您自己的应用程序中执行加密，与您的应用程序是否在 AWS 中运行无关。
  ```

- 可以对 KMS key 进行哪些操作？（至少 5 个）
    ```
    - 创建对称和非对称密钥，并且密钥材料只能在该服务内部使用。
    - 创建对称密钥，并且密钥材料在您控制下的自定义密钥存储中生成和使用*
    - 导入您自己的对称密钥材料以在该服务内部使用
    - 创建对称和非对称数据密钥对以在应用程序本地使用
    - 定义哪些 IAM 用户和角色可以管理密钥
    - 定义哪些 IAM 用户和角色可以使用密钥加密和解密数据
    - 选择每年自动轮换由该服务生成的密钥
    - 临时禁用密钥，使其不能被任何人使用
    - 重新启用已禁用的密钥
    - 计划删除不再使用的密钥
    - 通过检查 AWS CloudTrail 中的日志审计密钥的使用
  ```

#### 使用 CLI 进行练习
- 创建对称加密的 KMS key
    ```
  s kms create-key \
        --tags TagKey=Purpose,TagValue=Test \
        --description "Development test key, created by luna" 
  
  👆注意：create-key命令不允许您指定别名，要创建指向新 CMK的别名，请使用create-alias命令。👇
  alias: s kms create-alias --target-key-id=xxxx --alias-name=alias/luna-kms
  
  ⚠️ Alias name must begin with alias/ followed by a name, such as alias/ExampleAlias .
  ```

- 加密一段字符串
    ```
  s kms encrypt \
        --key-id alias/luna-kms \
        --plaintext "This is text before encryption, HAPPY FRIDAY" \
        --output text \
        --query CiphertextBlob \
        --cli-binary-format raw-in-base64-out

  --> output: 
  AQICAHjhlLEimr16gBoUhfrbd7oJhaam7z/AfsRDke+9XkLkBQHHODdYOHEm43orP1kkYuMbAAAAizCBiAYJKoZIhvcNAQcGoHsweQIBADB0BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGThKBC2qi+GFhNAKwIBEIBHXShar2RkszY4vust8CwDmARkv+s4ZU51Ett6EJIhD7VcGNVbnE0X7dJbd6UJPJ88Vfz1MVNiY0jkRc/7BdDUBmWmW8anjDI=
  AQICAHjhlLEimr16gBoUhfrbd7oJhaam7z/AfsRDke+9XkLkBQFIDBH22rUvy2xluHQLHzn7AAAAizCBiAYJKoZIhvcNAQcGoHsweQIBADB0BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDFxih+HgMx9nEBBrgwIBEIBHLgU39vHUu+ZFk3sAc2Ja/jicdr48G4tdEDGt+po0mO86iyWF1KVsn2Ebuun8DmxooaFXlUSfXyXfdOruPkt44pwuF4rXljk=
  ```

  ```
  s kms encrypt \
      --key-id  alias/luna-kms \
      --plaintext "VGhpcyBpcyB0ZXh0IGJlZm9yZSBlbmNyeXB0aW9uLCBIQVBQWSBGUklEQVk=" \
      --output text \
      --query CiphertextBlob | base64 \
      --decode > encryptedfile
  
  --> output: encryptedfile file
  ```

- 使用同一个 Key 重新加密同一段字符串，观察结果
    ```
  两次加密后的结果不一样
  ```

- 将加密后的字符串进行解密
    ```
  s kms decrypt \
        --key-id alias/luna-kms \
        --ciphertext-blob AQICAHjhlLEimr16gBoUhfrbd7oJhaam7z/AfsRDke+9XkLkBQHHODdYOHEm43orP1kkYuMbAAAAizCBiAYJKoZIhvcNAQcGoHsweQIBADB0BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGThKBC2qi+GFhNAKwIBEIBHXShar2RkszY4vust8CwDmARkv+s4ZU51Ett6EJIhD7VcGNVbnE0X7dJbd6UJPJ88Vfz1MVNiY0jkRc/7BdDUBmWmW8anjDI= \
        --output text \
        --query Plaintext | base64 -D
  
  --> output: This is text before encryption, HAPPY FRIDAY
  ```

  ```
  s kms decrypt \
        --ciphertext-blob fileb://encryptedfile \
        --key-id alias/luna-kms \
        --output text \
        --query Plaintext | base64 \
        --decode > decryptedfile
  
  --> ?? An error occurred (ValidationException) when calling the Decrypt operation: 1 validation error detected: Value at 'ciphertextBlob' failed to satisfy constraint: Member must have length greater than or equal to 1
  ```



## Advanced

- 使用 CloudFormation 创建 KMS RSA_4096 的 key
    ```
  🔎 cloudformation.yml
  ```

- 加密并解密一段字符串
    ```
  🔎 cloudformation.yml
  ```

- 将 KMS Key 与其他服务一同使用（Basic 里的对称加密 Key）
    ```
  加密 S3 文件:
  
  
  ```
  ```
  加密 parameter store 里的值: 
  
  ```
- 如何进行 Key rotation？
    ```
  刚创建出来的cmk是默认不开启rotation，可以通过console或者api来打开
  设置EnableKeyRotation为true即可。
  ```

- AWS 如何进行自动 Key rotation？
  ![auto](https://github.com/LunaTW/aws-kms-demo/blob/master/res/key-rotation-auto.png?raw=true)
    ```
  auto: (yearly)
  $ s kms enable-key-rotation --key-id alias/luna-kms
  
  ps: 
  $ s kms get-key-rotation-status --key-id alias/luna-kms 
  {
      "KeyRotationEnabled": true
  }
  - s kms disable-key-rotation --key-id alias/luna-kms 
  ```
  ![manually](https://github.com/LunaTW/aws-kms-demo/blob/master/res/key-rotation-manual.png?raw=true)
  ```
  manually: 
  $ aws kms update-alias --alias-name alias/TestCMK --target-key-id XXXXXXXXXXXX
  ```

  | KMS  | PRO | CONS | 
    | ----  | ----  | ---- |
  | auto | 1. 自动轮转  2. encrypted PINs with old key can also decrypted | relation 频率不能自定义    |
  | manually | 1. 更新频率可控 2. encrypted PINs with old key can also decrypted | 手动增加effort |


## Ref:
- [AWS Key Management Service 常见问题](https://aws.amazon.com/cn/kms/faqs/)
- [AWS CLI 参考中的 AWS KMS](https://docs.aws.amazon.com/zh_cn/cli/latest/reference/kms/index.html)
- [BASE64 encode & decode online](https://www.base64decode.org/)
- [Example](https://github.com/Ma-Jiajie/hello-kms)
- [轮换客户主密钥](https://docs.aws.amazon.com/zh_cn/kms/latest/developerguide/rotate-keys.html)