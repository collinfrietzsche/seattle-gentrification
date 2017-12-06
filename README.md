# seattle-gentrification
# Info201 Group Project


## Project Description


##### Background of Data Set
This data comes from Seattle’s Open Data website. We are focusing on data from transportation, urban design, and pricing in order to identify and quantity factors that impact gentrification and the causes it has on factors like housing prices.

#### Audiences for this project
Our main audience for this project is people looking to move in the Seattle area. This data allows our audience to move into growing communities, areas with high transportation access, and within their budgets.

##### Questions that will be investigated
1. How does access to public space impact housing prices and land use?
2. What dictates better “urban design”?
3. Does “better” design make spaces safer?
4. How have housing prices changes over time?



## Technical Description
__Format of Project:__ Shiny.io 
__Format of Data Read in:__ .csv files
__Major Libraries Used:__ Plotly, dplyr, ggplot2, knitr, shiny, shinythemes    

#### Data Wrangling Needed
Most of the data wrangling for this project will be to clean up bad data entries, join tables on geolocation, and group by regions (municipalities).

#### Questions to be Answered with Statistical Analysis:
1. What regions have the highest housing cost?
2. What regions have the greatest access to transportation?
3. What regions are ADA accessible?
4. What areas score highest in “urban planning”
5. Can we predict housing prices based on the factors we chose to analyze?
6. Does one factor dictate price more than any other?

#### Anticipated Major Challenges
1. There is a lot of data that needs to be aggregated. Some of it may be useful, but a lot (we will most likely find) will not.
2. Identifying key factors that influence urban design, house prices, gentrification
3. Working with Shiny.io

#### Future Questions to Investigate
1. Can we build a better model?


It looks like you have a good outline of what you want to do with the data. As you work on this project, make sure to define terms that are ambiguous or subjective, such as “access,” “better design,” and “safer” (Ex. what metric are you using for safety?)
Adele Miller , Nov 19 at 4:10pm


It's awesome that you're looking into gentrification, and I think your initial goal is super interesting:

 "to identify and quantity factors that impact gentrification and the causes it has on factors like housing prices."

In order to do this, you'll need to connect concepts (i.e., gentrification) to attributes in your data. The same holds true for your more specific inquiries. For example, this is a complex (and fascinating) question:

"How does access to public space impact housing prices and land use?"

In order to answer it, you'll need to *measure* access to public space (and differences in access over time or across the city). As you move forward, think about which data/analyses enable you to answer these questions (and then you can express that data in written and visual forms). 

As an aside, I (personally) would think of your user a bit more as an urban designer / community planner trying to understand the state (and change) of the city. Tailoring it to home buyers makes it seem like a tool *for gentrifiers*, which I imagine is not your intent.
Michael Freeman , Nov 27 at 10:43am


ToDo:
~ High Level Insights:
1. # of parks, public spaces, tennis courts, bike racks per neighborhood
	~ list off the percentage difference from average in seattle
2. Talk about scope of project (time constraint, limited data sets, limited statistical analysis req’d for course)
3. What factor has the biggest impact on housing prices

Acquiring pricing data samples
~ about 15 per neighborhood from different areas



