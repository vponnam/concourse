*Pre-requisites*


##### Pipeline uses an org named **test** space **con-test** to push test apps bind them to platform services
	```
	cf co test
	cf t -o test
	cf create-space con-test
	```

##### Replace the user in the smoke-test.sh script who's assigned atleast a space-developer role and change the domain name

