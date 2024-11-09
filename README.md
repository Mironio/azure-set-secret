# Azure Key Vault Secrets Setter

This project provides a script to set secrets in Azure Key Vault from JSON or environment files.

## Files

- **keyvaults.json**: Contains mapping of environments to Key Vault names.
- **secrets.json**: Contains secrets in JSON format.
- **secrets.env**: Contains secrets in environment variable format.
- **set_secrets.sh**: Bash script to set secrets in Azure Key Vault.

## Usage

1. Login to Azure:

   ```bash
   az login
   az account set --subscription <your-subscription-id>
   ```

2. Make the script executable:

   ```bash
   chmod +x set_secrets.sh
   ```

3. Run the script:

   ```bash
   ./set_secrets.sh
   ```

## Requirements

- `keyvaults.json`: File containing a mapping of environments to Key Vault names.
- `secrets.json`: File containing the secrets in JSON format (if using JSON mode).
- `secrets.env`: File containing the secrets in environment variable format (if using env mode).
- `jq`: Command-line tool for processing JSON (if using JSON mode).
- `az`: CLI tool for interacting with Azure Key Vault.

## Configuration

Edit the `keyvaults.json` file to include your Key Vault names for different environments:

```json
{
  "dev": "kv......hygl6yd8",
  "tst": "kv......h8bvbmgyvvip0lr",
  "acc": "kv......lavbb32h1y2yde6"
}
```

Create a `secrets.json` file with your secrets:

```json
{
  "MySecret_11": "Value3"
}
```

Or create a `secrets.env` file:
```
MYSECRET_5=test
```
