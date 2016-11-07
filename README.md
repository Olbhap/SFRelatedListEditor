## Overview

This app provides all the necessary lightning components to enable inline editing for related list.

## What is in the box

The app provides lightning components for the client side and a controller to handle metatdata and data manipulation in the backend.
The controller can handle any type of object (standard and custom as well). To achieve this, I massivelly used the Salesfroce Rest API mainly "sobject" API(s). 

## Lightning Components

### RelatedListDataGridsComponent

Display all the related lists. The list of related list is extracted from the object layout.
![alt text](https://cloud.githubusercontent.com/assets/7535971/20061303/a27e652e-a4ff-11e6-870b-719b706567bd.PNG "Related Lists in read mode")

Then we switch to the edition mode:
![alt text](https://cloud.githubusercontent.com/assets/7535971/20061301/a27dc6c8-a4ff-11e6-96ba-e2698f5474a1.PNG "Related Lists in write mode")

### RelatedListDataGridComponent

Display a specific related list based on the label. Using the label is more user friendly. 
The related list label can set from the app lightning builder.

Both components are availables in the lightning app builder. So just drag&drop and enjoy.
![alt text](https://cloud.githubusercontent.com/assets/7535971/20061302/a27de84c-a4ff-11e6-865c-2c5e637fa5d8.PNG "App Builder")

##Testing

The package contains Unit Tests for Apex classes and Static Resources for Rest MockUp.


