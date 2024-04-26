# Demo-WorkshopAWS-Using-Terraform

I will build infrastructure based on this workshop which I have made to submit to mission 1 of my First Cloud Journey Program.
- Link to the workshop: [Workshop](https://thnbao22.github.io/)

- Some AWS services I use in this workshop include VPC, EC2, S3, and Gateway Endpoint that supports private connection to S3 Bucket.

- Architecture:
![ConnectPrivate](images/Project.png)

- So I have completely done coding infrastructure for the architecture in the workshop.
- I will soon complete the demo of this project.

# Demo

1. Before deploying infrastructure, you need to access to your AWS account and create an access/secret key 

![ConnectPrivate](images/1.png)

![ConnectPrivate](images/2.png)

2. Clone this repository
```
git clone https://github.com/thnbao22/Demo-WorkshopAWS-Using-Terraform.git
```

3. After cloning this repository, please open the project in Visual Studio Code and navigate to the **terraform** folder using the **cd** command on the terminal of Visual Studio Code

![ConnectPrivate](images/3.png)

4. After successfully navigating to the **terraform** folder, you can run the following command
```
terraform init 
```

![ConnectPrivate](images/4.png)

5. After you run the command successfully, you can see there are some folders appear in the **terraform** folder

![ConnectPrivate](images/5.png)

6. You can access the AWS Management Console, search for EC2 and create a key pair.

![ConnectPrivate](images/6.png)

7. You also need to create an access/secret key and include it in the file **main.tf** in the **terraform** folder

![ConnectPrivate](images/7.png)

8. Navigate to the **terraform** folder, using the command below to preview the changes that Terraform plans to make to your infrastructure.
```
terraform plan
```

![ConnectPrivate](images/8.png)

9. You can see some resources will be created.

![ConnectPrivate](images/9.png)

10. Then, you can use this command to executes the actions proposed in a Terraform plan.

```
terraform apply -auto-approve
```

![ConnectPrivate](images/10.png)

11. After you run the command, you will see some resources are being created.

![ConnectPrivate](images/11.png)

12. VPC:

![ConnectPrivate](images/12.png)

13. Subnets

![ConnectPrivate](images/13.png)

14. Route Tables

![ConnectPrivate](images/14.png)

- Subnet associations of Route Table Private
  
![ConnectPrivate](images/15.png)

- Routes

![ConnectPrivate](images/16.png)


- Subnet associations of Route Table Public
  
![ConnectPrivate](images/18.png)

- Routes

![ConnectPrivate](images/17.png)

15. Security Groups

![ConnectPrivate](images/19.png)

- Inbound rules

![ConnectPrivate](images/20.png)

16. Internet Gateway

![ConnectPrivate](images/22.png)

17. NAT gateway

![ConnectPrivate](images/23.png)

18. S3 Gateway Endpoint

![ConnectPrivate](images/24.png)

19. S3 Bucket

![ConnectPrivate](images/26.png)

20. EC2 Server

![ConnectPrivate](images/26.png)

27. Then you can follow the workshop to perform some actions between EC2 and S3. Know how EC2 can privately connect to S3.

28. After finishing the workshop, you can automatically delete the resource by using the following command.
```
terraform destroy -auto-approve
```

![ConnectPrivate](images/27.png)

29. After running the command, you can see that the resources have been completely deleted.

![ConnectPrivate](images/28.png)