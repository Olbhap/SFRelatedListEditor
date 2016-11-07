@isTest
global class RestAPIMockHttpResponseGenerator  implements HttpCalloutMock {    
    global HTTPResponse respond(HTTPRequest req) {        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();        
        mock.setHeader('Content-Type', 'application/json');
		mock.setStatusCode(200);

        String endPoint = req.getEndpoint();        
        //Get Layout Response
        if(endPoint.contains('sobjects/Account/describe/layouts')){
            mock.setStaticResource('TestAccountLayoutResponse');
        }
        
        //Get Describe Response
        else if(endPoint.contains('sobjects/Account/describe')){
            mock.setStaticResource('TestAccountDescribeResponse');
        }

        //Get Contacts Response
        else if(endPoint.contains('/Contacts')){
            mock.setStaticResource('TestAccountContactsResponse');            
        }
                
        else if(endPoint.contains('sobjects/Account')){
            mock.setStaticResource('TestAccountDetailsResponse');
        }
        
        else if (endPoint.contains('/tooling/query')){
            mock.setStaticResource('TestAccountDetailsResponse');
        }
        
        return mock.respond(req);
    }
}