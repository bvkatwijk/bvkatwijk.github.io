The effectiveness of your build pipelines is very important. The value that a trustworthy pipeline can give you is a significant increase of developer speed, a decrease in production incidents and
a culture where a team can experiment.

There are a few aspects that determine quality of a CI/CD process

### It should work
Let's start simple. The most basic rule is that a pipeline should run, meaning that there are no faults in the runtime or setup of the pipelines themselves. If this is not the case, 

### Completeness
A pipeline is not just a place where a few checks happen. It can be useful to think of it as a one-way gate. If the code passes through, it is accepted and will continue to production. If it is not, it will not go to production. For every project, the criteria of what constitutes a passed or failed build are a little bit different.

While this sounds simple, it is often not the reality. Frequently pipelines contain steps that always pass. Steps that fail sometimes are restarted until they succeed. Sometimes there are checks that are not relevant for production shipping.

Eliminating unnecessary or unreliable work in CI/CD is not only a speed upgrade, it increases the reliability and utility of your pipelines.

### Accuracy
The build can have two outcomes, green or red, pass or fail. 
For every project, the criteria of what constitutes a passed or failed build are a little bit different. 
If you get this right, the pipeline becomes trustworthy enough to increase developer velocity. Developers can try out new things and be confident that the CI/CD systems will give solid feedback

### Speed

### Insightful
A pipeline needs to provide data in a way that you can use it. 
Can you clearly see the steps that were executed? 
Can you extract how long each test lasted? Can you 

---
*I am available for consulting sessions on CI/CD pipelines. We review the existing setup, see if parts are missing or incorrect, and provide a plan to implement them. For business inquiries please use the contact form.*