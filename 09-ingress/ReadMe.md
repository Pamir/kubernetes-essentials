<h2>Compare Ingress Controllers Performance with Azure DevOps Load Test</h2>

Let's see which Ingress Controller has better performance rather than others.
We will use Azure DevOps to testing performances of ingress controllers.
First we need to define load test scenarios on Azure DevOps.

This is sample scenario for nginx-ingress. 
![Load_Test_Scenario_Sample](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/nginx-ingress-loadtest.png)

After that we should add 2 more scenarios for traefik-ingress and contour-ingress.</br>
Then, let's run test and examine results.

<h4>Nginx Ingress Controller Load Test Summary</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/nginx-ingress-loadtest-1.PNG)

<h4>Nginx Ingress Controller Load Test Chart Details</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/nginx-ingress-loadtest-2.PNG)


<h4>Traefik Ingress Controller Load Test Summary</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/traefik-ingress-loadtest-1.PNG)

<h4>Traefik Ingress Controller Load Test Chart Details</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/traefik-ingress-loadtest-2.PNG)


<h4>Contour Ingress Controller Load Test Summary</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/contour-ingress-loadtest-1.PNG)

<h4>Contour Ingress Controller Load Test Chart Details</h4>

![nginx_Ingress_LoadTest_Summary](https://github.com/tayyip61/kubernetes/blob/master/loadtest-ss/contour-ingress-loadtest-2.PNG)

We can see the Average Response Times for each ingress controllers.</br>
According to test results, it is obvious which ingress controller type has best performance for load balancing.</br>
Traefik Ingress Controller has lowest average response time with 3.7 ms.</br>
Then, Nginx Ingress Conroller has the second lowest average response time with 4.1 ms.</br>
Finally, Contour Ingress Controller has the highest average response time with 4.4 ms.</br>

