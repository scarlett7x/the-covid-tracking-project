# The Covid Tracking Project

This pandemic makes a difference in our lives in every possible way, and a lot of people have been closely tracking how different regions are doing. I came up with the idea of making an iOS app to track COVID-related data because I somewhat had a hard time navigating through different graphs, links, data through websites. There are so many resources, but I personally care about complete data visualization of new cases and death cases the most. I know a lot of my friends share this concern, so I decided to make this mobile application.

### Disclaimer

In this project, I used data API from covidtracking.com, and shoutout to their amazing group of volunteers that provide the most complete data available about COVID-19 in the U.S. 

### UI/UX Design

My figma prototype: https://www.figma.com/file/qOlrazre5GPxB3AqTEE99g/covid19?node-id=3%3A34692

To create a line chart for data visualization, I set up table view cells for users to pick the region, time range, and data type of their interests. (You might notice that there is a "Current Projection" switch button! That feature is still under construction, see Updates section)

Default settings: region: U.S.; time range: 8/1/20 - 8/20/20; data type: New Cases

Regions: Users can choose from 56 states of the U.S. or the country as a whole.
Time: End date can be no later than current date and no earlier than start date.
      Start date can be no earlier than Feb 1 2020.
Data Type: New cases, death cases, total cases, total death cases are supported.

### Video Demo

https://drive.google.com/file/d/1Iwg3pSW0iFOxI_zf6cZ4AoAae-BiYasj/view?usp=sharing

### System and Device Supported

The deployment targets iOS 13.0 and higher, and supports iPhone only.

### Updates

As of Aug 28, I am working with my friends studying Data Science to work on the projection feature. Stay tuned :)
