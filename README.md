# Productivity AI Buddy
**For Safe Hackathon**

## **Project Goal**

Productivity AI Buddy is designed to help you stay accountable to your goals through financial DeFi incentives. 

- Set daily, weekly, or monthly goals.
- If you don’t meet your goals, part of your LP (Liquidity Provider) rewards will be slashed.
- If you achieve your goals, you earn token rewards.

The slashed rewards are aggregated by the DAO and can be used to fund the future development of the project or support community-driven initiatives.

## **The Problem Productivity AI Buddy Solves**

Most to-do lists fail because they’re unrealistic. You start with ambition, but by the end of the week, half the tasks are untouched.

**Productivity AI Buddy** changes that by not only tracking your tasks but also holding you accountable.

- **Realistic Goal-Setting:** Based on your past performance, the AI agent helps set achievable to-dos, avoiding the trap of overcommitment.
- **Personalized Feedback:** It learns from your habits and provides tailored insights to help improve execution.
- **Slashing Incentives:** Miss a deadline? A percentage of your rewards is slashed, reinforcing discipline.

We’re currently building **smart task breakdowns**, where the AI agent assesses task difficulty and splits larger tasks into manageable milestones. The reward system (V1.0.1) operates in **7-day seasons**—at the end of each season, users can claim their rewards, while slashed amounts reset.

**Execution over excuses. The system enforces it.**

## **How To Use It**

1. **Get Started:**
   - Visit the [frontend](https://productivity-god.pyba.st/) and deposit some funds into your account.
   
2. **Set Your Goals:**
   - Chat with the [AI Agent](https://t.me/ProductivityGodBot) to define your daily objectives and set deadlines for each task.
   
3. **Estimate Time:**
   - Ask the AI for advice on the estimated time for your tasks and compare it with your own estimate.

4. **Track Progress:**
   - Update the AI bot with your task progress.

5. **Rewards, Slashing & End of Season:**
   - At the end of the season (default: 7 days), you'll either:
     - **Claim Full Rewards** if all goals are met.
     - **Receive Partial Rewards** based on the slashing amount if goals were not fully achieved.
   - After each season, the slashing mappings are reset, and a new cycle begins.

---

### **Challenges We Ran Into**

During the development process, we encountered a few challenges:

- **Setting up the Eliza Environment:** We faced difficulties configuring the environment to ensure everything ran smoothly.
- **Connecting Eliza with the Database:** There were challenges linking the agent to the database for saving past user chats, which are crucial for providing meaningful feedback.
- **Supporting Multiple Chains:** We are working on making the agent compatible with different blockchain networks, expanding its functionality beyond a single chain.

---

### **Additional Notes:**
- The slashed rewards are used by the DAO to fund further development or community initiatives.
- The AI assistant will help keep you on track and provide insights for better goal management.
