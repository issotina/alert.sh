# Alert.Sh

Alert.sh allows you to configure an additional job in your pipeline in order to have a desktop notification based on the status of your builds or deployments.
   
   In addition to notifications by slack, email or other that your provider offers you, use alert.sh to have desktop notifications (web push).


## Usage 

Download and run script using right parameters 

```shell
$ curl https://raw.githubusercontent.com/geeckmc/alert.sh/master/alert.sh | bash -s -- -t <token> -p <project_name> -s <build_status: 0|1|2 >
``` 

| Parameters    | Description                                                                                                        |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| -p [required] | Your project name. Used to personalize notification message                                                        |
| -t [required] | Your unique token used to identify your browser. You can get your token at <br/> https://alert.surge.sh            |
| -s            | Your build status (Int value).<ul> <li> 0 (Build Failed) </li>  <li>1 (Build Succes)  </li>  <li> 2 (Unknow) </li> |
| -l            | Your Applink.                                                                                                      |

## Example 

#### Gitlab CI

```yml
stages:
  - build
  - deploy
  - notify

alert_job:
  stage: notify
  script:
    - https://raw.githubusercontent.com/geeckmc/alert.sh/master/alert.sh | bash -s -- -t <token> -p AWESOME_PROJECT -s 0
  when: on_failure
```
![](https://raw.githubusercontent.com/geeckmc/alert.sh/master/succes_alert.png)

