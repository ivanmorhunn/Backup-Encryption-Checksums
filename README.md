<h1>Backup-Encryption-Checksums</h1>

<h2>Description</h2>
This is my semester project that I have with my CYBER 262. Our goal was to create a script that does certain things such as backing up files, encrypting files and checking their hash value. For my script I have option menu insted of creating 3 separate files I have combined them into a single file. The file has 6 menu items: Compress, Encrypt, Decrypt, Decompress, Checksum and Exit. 


<b>ATTENTION: THIS SCRIPT REQUIRES USER TO INSTALL AESCRYPT SOFTWARE TO DO ENCRYPTION OPERATIONS!</b>
Here's a link: https://www.aescrypt.com/download/
<h2>Requirements</h2>
 
- Backups are generated via Windows .bat file
- Once the backup is generated, the file needs to be named with the site that generated it and the date in YYYYMMDD format
- Then the file needs to be compressed and encrypted
- An additional .bat file is needed to decrypt and decompress the file when a database restore is necessary
- Another .bat file is needed to create a checksum (hash) for verification that any file run through it is unchanged and you’ll need to demonstrate that the hash works by modifying the file

<h2>Languages and Utilities Used</h2>

- <b>Windows Batch File</b>
- <b>AES Crypt (for encrypting files)</b>

