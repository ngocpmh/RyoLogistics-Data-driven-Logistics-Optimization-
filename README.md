# Company background
Ryo is a logistics provider covering 100% of Southeast Asia. It offers end-to-end services from transportation to warehousing, mainly for e-commerce businesses. With increasing demands in data processing and analysis, Ryo has adopted Business Intelligence (BI) solutions to optimize operations and enhance customer experience. By doing this, Ryo can analyze parcel delivery performance from First Mile to Last Mile, evaluate KPIs across teams, and present findings via a BI dashboard and presentation slides.

Ryo's SLA Policy:
- SLA Pickup
  + Orders created before 4:00 PM must be picked up on the same day.
  + Orders created after 4:00 PM must be picked up by the next working day (excluding Sundays and public holidays).
- SLA Delivery
  + Orders that arrive at the destination hub before 11:00 AM must be successfully delivered on the same day.
  + If they arrive after 11:00 AM, they must be delivered by the next working day, with status granular_status = 'Completed'. This also excludes Sundays and public holidays.

**A. Operations Department**

Goals:
- Track order progress and analyze delivery performance
- Evaluate delivery staff efficiency and performance at each hub

Requirements:
- Order progress tracking:
  + Track parcel volumes by delivery status over time (year, quarter, month).
  + Monitor end-to-end delivery timelines and identify the reasons behind delays
  + Evaluate SLA fulfillment for pickups and deliveries to ensure service reliability.
- Delivery staff & Hub performance evaluation:
  + Measure KPIs such as delivery success rate, cancellation rate, on-time rate, and average delivery time.
  + Assess SLA compliance by hub, driver, and shop.
  + Identify underperforming areas (hubs, regions, provinces) based on KPI and SLA results.
  + Analyze factors affecting performance such as parcel size, region, shipper, and driver behavior.
  + Propose improvements in staffing, routing, or operational strategy to increase efficiency.

**B. Sales Department**

Goals:
- Develop reports to shopping trends and analyze customer behaviour
- Identify patterns and reasons behind order cancellations.
- Explore geographic and seasonal shopping behavior to support market expansion and sales strategies.
  
Requirements:
- Buying behaviour analysis:
  + Analyze overall parcel trends to identify high-demand periods, popular product categories, and regional differences.
  + Track changes in shopping behavior during special occasions (e.g., major holidays, double-day sales).
  + Compare purchasing patterns across geographic regions to uncover market-specific insights.
- Order cancellation insights:
  + Monitor cancellation rates and reasons by region, payment method, delay duration and COD value.
  + Identify key risk factors that lead to customer dissatisfaction.
- Customer segmentation & Market strategy:
  + Segment customers based on behavior, region, and preferences.
  + Describe customer profiles to inform targeted marketing and retention plans.
  + Propose actionable strategies to acquire new customers, boost service adoption in underpenetrated regions, and enhance the effectiveness of sales campaigns and promotional planning.

# Company Solution
### Operation Department

**1. Create Sla_delivery and calculate the sucessful on-time delivery rate (before sla_delivery) by hub, driver, and shipper.**

![image](https://github.com/user-attachments/assets/6584e05c-6ff6-4325-a358-540f9c2c4709)
- Ryo has 48,704 shippers.
- Only 15 shippers have more than 1,000 orders, accounting for 10% of all orders.
- The top 12 shippers have a relatively high average on-time delivery rate.
  
![image](https://github.com/user-attachments/assets/9cdd226c-0500-42a2-bd07-4e975459543b)
- Out of 8,024 drivers, only 16 drivers handled more than 200 orders.

![image](https://github.com/user-attachments/assets/f3097651-5fde-4ca0-aaa5-92c04c7c1ebb)
- Out of 778 total stations, only 10 stations handled over 2,000 orders.
- These top stations show high on-time delivery rates (80–90%), mostly located in Hanoi and Ho Chi Minh City, which also have the highest order volumes and best on-time rates.


**2. Root cause of delays & Recommendations**

A. Regional delay analysis:
  + Top 10 provinces handle nearly 50% of total national orders.
  + Need to prioritize reducing late deliveries in these areas to improve efficiency and customer experience.
![image](https://github.com/user-attachments/assets/934d1f6e-eba5-4b39-b4af-2a1e10ca4a04)
![image](https://github.com/user-attachments/assets/317ba8d7-e2c8-4327-95d1-1ed4b708d120)

From these visualizations, you can see that:
  + Ho Chi Minh City (HCMC) and Hanoi have the largest order volumes but low late delivery rates due to high station hub density.
  + Lam Dong, Nghe An, Binh Duong, and Dong Nai have large order volumes but high late delivery rates (up to 30%).
![image](https://github.com/user-attachments/assets/65a60740-7418-4ba3-85a1-8dd55b5f49b4)

  + Station hub: the central stations whose primary role is to transport goods are most densely distributed in the two major metropolitan areas — Hanoi and Ho Chi Minh City.
  + Binh Duong, Long An, and Dong Nai are provinces located near Ho Chi Minh City with relatively large geographic areas. However, these areas lack sufficient station hubs, making it difficult to transport goods efficiently and quickly.

When focusing on the number of delivery drivers in these regions, we can see that:

![image](https://github.com/user-attachments/assets/48de5e07-f140-4ce7-ac41-8d850a4a1ae6)
  + Hanoi and HCMC manage deliveries effectively with low late delivery rates.
  + Dong Nai and Binh Duong have many delivery drivers, second only to Hanoi and HCMC, yet still experience high late delivery rates — likely due to some reasons such as delivert drivers not meeting deadlines or because of complex traffic and wide industrial zones.
  + Nghe An and Lam Dong have over 27% late deliveries, mainly due to lack of drivers even though Nghe An has relatively many station hubs (top 3 region has highest number of station hubs)

Recommendations:
| Group                                                              | Characteristics                                                     | Solutions                                                                                                               |
| ------------------------------------------------------------------ | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **High Volume – Low On-Time** (e.g. Binh Duong, Dong Nai, Long An) | Southern regions <br> Medium - high number of orders <br> Medium-high late delivery rate <br> High number of delivery driver - high late rate | Build more station hubs and distribute workforce better in these regions <br> place hubs at strategic locations - where order volume is high. <br> Use performance tracking tools to evaluate the performance of delivery drivers.|
| **Medium Volume – Low On-Time** (e.g. Nghe An, Hue, Lam Dong)      | Central Vietnam <br> Moderate number of orders <br> Low-medium number of hubs <br>  Low number of delivery drivers - highest late delivery            | Add crossdock hubs (especially in Hue) as the provinces in the central region serve as a transportation bridge connecting the northern and southern parts of the country. <br> Allocate more delivery staff in Nghe An to support the station hubs in this region.                                        |
| **Medium Volume – Medium On-Time** (e.g. Kien Giang, Hai Phong)    | Northern provinces <br> High number of orders <br>  Medium late delivery rate <br>  Medium number of delivery staff - medium late rate                          | Establish key performance indicators (KPIs) such as on-time delivery rate, order processing time, and customer satisfaction, and implement an incentive system to reward employees who meet or exceed these KPIs. <br> Utilize delivery data analytics to identify common issues and propose appropriate improvement measures.                           |

B.Pickup vs Delivery Delays Analysis

![image](https://github.com/user-attachments/assets/981f042e-bb83-4c0f-a16b-2d867ef50626)

=> 80% of late deliveries are not caused by late pickups → need to investigate other contributing factors.

![image](https://github.com/user-attachments/assets/b58c155a-b9ce-41cf-9944-0ed6fa5aef03)

Over 50% of late-delivery orders have a recorded reason (first_failure_reason). The three most frequently recorded reasons can be grouped into the following two categories:

**- Group 1: From Customers (Buyers)**
  + Cause: Customers request to change the delivery date/time, or although the address is correct, no one is available to receive the package, etc.
  + Recommendation:
    + Allow customers to select or modify their preferred delivery date/time via the mobile app or website before the package is dispatched.
    + Contact customers in advance of delivery to confirm the delivery time and location, and remind them to be present during the selected time window.

**- Group 2: From Shippers (Stores)**
  + Cause: Incomplete, incorrect, or non-existent delivery addresses.
  + Recommendations:
    + Integrate Google Maps API or Loqate into the shipper’s ordering system to verify addresses at the time of input, helping to reduce address errors. The system should also provide instant suggestions to help customers correct input mistakes.
    + Include clear contractual requirements with shippers to follow address verification procedures, such as mandatory use of address verification technology and ensuring accurate delivery addresses before processing any orders.

![image](https://github.com/user-attachments/assets/56ae9d9b-0094-4370-b201-d527ffe49f5b)
  + The majority of orders fall within S and XS sizes.
  + As the parcel size increases, the number of orders decreases significantly.
  + The late delivery rate increases with parcel size, peaking at 24.5% for XXL-sized parcels. This may suggest that larger, bulkier packages require more space during transportation, making it harder to optimize space in delivery vehicles. Additionally, loading and unloading large parcels is more time-consuming, which contributes to delivery delays.

**Recommendations:**

**- Group 1: Small Items (Sizes S and XS): **These make up more than half of all orders but still suffer from a notably high delay rate.
  + Schedule more frequent deliveries and increase delivery frequency in areas with high concentrations of small-package orders to ensure faster fulfillment, collaborate with local distribution centers.
  + Use route optimization software to select the fastest delivery routes, avoid traffic congestion, and reduce delivery time.
  + Deploy automated sorting systems that utilize AI and machine learning to optimize the handling of small packages, reduce manual processes, shorten processing time, and thus improve delivery performance and reduce delay rates.

**- Group 2: Larger items (remaining items):** These orders represent a smaller portion of total volume, but their delay rate increases with size.
  + Implement specialized procedures for handling and delivering large items to maintain efficiency and reduce delays.
  + Utilize systems that allow customers to choose ideal delivery methods, including scheduling specific delivery appointments to ensure someone is present at the time of delivery—this reduces failed deliveries of large items.
  + Send pre-delivery notifications, informing customers that the size of the item may extend delivery time, encouraging them to select a suitable delivery window.

![image](https://github.com/user-attachments/assets/8df358ce-7a51-47be-ba1c-31ab824c4545)

- January & February (Lunar New Year Period):
  + Despite having a small number of orders in January, the late delivery rate is high (19.8%), possibly due to lingering COVID-related restrictions from late 2021.
  + The late delivery rate drops sharply in February during the Tet (Lunar New Year) period. Online shopping demand is low during this time as people primarily shop for essential goods.
- March to June:
  + The number of orders increases gradually.
  + Late delivery rates remain low, likely due to stable transportation operations and the absence of major events.
- August to October:
  + These months see the highest number of orders.
  + Late delivery rates gradually increase from July to October, corresponding to the rise in order volume.
- November & December (Year-End Shopping Season):
  + In November, order volume drops sharply (only 72 orders), but increases again in December due to holiday shopping and events like Black Friday and Christmas.
  + The late delivery rate peaks in December due to the order surge as customers prepare for Christmas and New Year.

**Recommendations** for Peak Seasons:
  + Plan ahead for the year-end shopping season: increase temporary workforce and delivery vehicle capacity, especially in months with holidays and peak shopping demand (e.g., Tet, Black Friday, December).
  + Encourage early holiday orders: launch promotions and shipping discounts for early holiday purchases to ease system load.
  + Optimize delivery workflows: encourage early deliveries before long holidays. For orders placed close to major holidays, consider extending the delivery timeframe to account for post-holiday backlog.

Example: After long public holidays (e.g., September 3, 2022), backlog volumes spike — hence, deliveries should be increased before such holidays, and expectations for deliveries made after should be adjusted accordingly.
