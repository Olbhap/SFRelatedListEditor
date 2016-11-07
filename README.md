<a href="https://githubsfdeploy.herokuapp.com?owner=hicham-elmansouri/&repo=SFRelatedListEditor">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

## Overview

This app provides all the necessary lightning components to enable inline editing for related list.

## What is in the box

The app provides lightning components for the client side and a controller to handle metatdata and data manipulation in the backend.
The controller can handle any type of object (standard and custom as well). To achieve this, I massivelly used the Salesfroce Rest API mainly "sobject" API(s). 

## Lightning Components

### RelatedListDataGridsComponent

Display all the related lists. The list of related list is extracted from the object layout.
![alt text](https://cloud.githubusercontent.com/assets/7535971/20064242/4b87cb60-a50a-11e6-9f93-425d2ab6e065.PNG "Related Lists in read mode")

Then we switch to the edition mode:
![alt text](https://cloud.githubusercontent.com/assets/7535971/20064243/4b8a0ce0-a50a-11e6-8adb-a7f21a5e819e.PNG "Related Lists in write mode")

### RelatedListDataGridComponent

Display a specific related list based on the label. Using the label is more user friendly. 
The related list label can set from the app lightning builder.

Both components are availables in the lightning app builder. So just drag&drop and enjoy.
![alt text](https://cloud.githubusercontent.com/assets/7535971/20064241/4b8711d4-a50a-11e6-93a2-adbd40a93979.PNG "App Builder")

##Testing

The package contains Unit Tests for Apex classes and Static Resources for Rest MockUp.


