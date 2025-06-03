# EFS Mounting Documentation for EC2 Instances

This document outlines the steps to mount Amazon Elastic File System (EFS) on an EC2 instance. It also covers troubleshooting and verification steps.

## Prerequisites:

1. **EFS Setup**: Ensure that the EFS file system is created in the AWS region where your EC2 instance resides.

2. **Security Groups**: Ensure that the necessary security groups for EFS and EC2 instances are configured to allow inbound traffic on port 2049 (NFS protocol).

3. **EC2 Instance**: Make sure the EC2 instance has the proper IAM role and necessary permissions to access EFS.

4. **Install Required Packages**: Ensure that amazon-efs-utils is installed on your EC2 instance to enable EFS mounting.

**Step 1**: **Install** `amazon-efs-utils`

On the EC2 instance, run the following command to install the EFS utilities:

```bash
sudo yum install -y amazon-efs-utils
```

**Step 2**: **Configure Security Group Rules
Security Groups for EC2 and EFS**:

- The EC2 instance's security group should allow outbound traffic to the EFS mount target on port 2049.

- The EFS mount target’s security group should allow inbound traffic from the EC2 security group on port 2049.

Example Commands:

To authorize inbound traffic on port 2049, run the following command:

```bash
sudo aws ec2 authorize-security-group-ingress \
    --group-id <EFS-Security-Group-ID> \
    --protocol tcp \
    --port 2049 \
    --source-group <EC2-Security-Group-ID> \
    --region <Region>
```

Replace `<EFS-Security-Group-ID>` and `<EC2-Security-Group-ID>` with the appropriate security group IDs.

**Step 3**: **Mount EFS**

**Mount Command**: Use the following command to mount the EFS filesystem to the desired directory (/media in this case):

```bash
sudo mount -t nfs4 -o nfsvers=4.1 fs-<EFS-File-System-ID>.efs.<Region>.amazonaws.com:/ /media
```

Replace `<EFS-File-System-ID>` with your actual EFS file system ID and `<Region>` with the AWS region (e.g., eu-west-2).

**Verify Mount**: After mounting, you can check the mounted filesystem using the `df -h` or `mount` command:

```bash
df -h
```

```bash
mount | grep efs
```

The output should show that EFS is mounted at /media and is using the correct filesystem.

**Step 4**: **Unmount EFS**

- If you need to unmount EFS from the EC2 instance:

```bash
sudo umount /media
```

**Step 5**: **Verify and Troubleshoot Mounting Issues**

1. **If the EFS mount shows as 127.0.0.1:/**: This can happen due to incorrect mount settings or DNS resolution issues. You can remount the file system using the FQDN:

```bash
sudo mount -t nfs4 -o nfsvers=4.1 fs-<EFS-File-System-ID>.efs.<Region>.amazonaws.com:/ /media
```

2. **Check EFS Logs**: If mounting continues to fail, check the logs for errors related to EFS mounting:

```bash
sudo tail -f /var/log/messages
```

3. **NFS Client Installation**: Ensure the nfs-utils package is installed on your EC2 instance:

```bash
sudo yum install -y nfs-utils
```

4. **Ensure Proper NFS Protocol**: EFS uses NFSv4, so make sure the client supports NFSv4. If there are issues with NFS versions, try specifying the NFS version explicitly:

```bash
sudo mount -t nfs4 -o nfsvers=4.1 fs-<EFS-File-System-ID>.efs.<Region>.amazonaws.com:/ /media
```

**Step 6**: **Automate Mounting with /etc/fstab**

To automatically mount EFS on boot, add the following line to /etc/fstab:

`
fs-<EFS-File-System-ID>.efs.<Region>.amazonaws.com:/ /media efs defaults,_netdev 0 0`

This ensures that the EFS mount persists across reboots.

## Troubleshooting:

**Timeout Errors**: If the mount attempt times out, ensure that the security groups are properly configured and that there is no firewall blocking port 2049.

**Permission Issues**: Ensure that the EC2 instance's IAM role has the required permissions to mount EFS (e.g., elasticfilesystem:DescribeMountTargets).
