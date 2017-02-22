*Pre-requisites*


##### Pipeline uses an org named *test* space *con-test* to push test apps bind them to platform services
###### Make sure either those are created or replace the script with proper details
```javascript
cf co test
cf t -o test
cf create-space con-test
```

##### Replace the user in the smoke-test.sh script who's assigned atleast a *space-developer* role and change the system domain name

