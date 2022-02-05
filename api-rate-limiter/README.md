# API reate limiter

This is an often used challenge in coding interviews. It asks to implement a rate limiter on an API endpoint. Those are the requirements:

- limit the requests of a user to 3 requests every 2 minutes,
- assume there are no concurrent requests,
- assume there is one method `endpoint` that is called with every request and that returns `true` if for the given user the request is allowed in the given constraints and `false` if it is not
