# Introduction to Concurrency

Concurrency is having several tasks being done at the same time. The world is naturally concurrent.

Perhaps the most common example of concurrency is going to a supermarket. When you are ready to pay, you pick a lane where there is a cashier. And when the supermarket has two or three open lanes, you wait a small amount of time to exit the supermarket. Having two, three, four or more cash registers opens is concurrency. The store can get sell groceries to several clients at the same time. More clients are happy. And more money is produced at the same time.

We also have had the experience of going to a supermarket where there is only one open cash register. If there aren't too many customers, that is not a problem. You still get to leave the store rather quickly. 

But what happens if there a client that takes longer to leave the store? Maybe they need a price check on the shelve. Maybe they want to pay with a check, and that process takes longer than paying with a card or cash. The whole line slows down. The line gets bigger.

And sometimes there are too many customers, a long line gets created. People get grumpy. Some people decide that the wait is not worth it, and leave their groceries abandoned and leave the store.

This single cash register open is similar to what early computers were like. You could process one task at a time. Each computing tasks was processed in a line, just like a checkout line. And if one process was too busy, everyone else had to wait their turn.

In the 60s they created operating systems that could run several tasks at the same time. Yet they found that it was hard to program is you had to deal with this concurrency. It was easier to program thinking as if you have a single computer that you alone control. So computer languages maintained this illusion. And this illusion lives to this day. It is an effective one.

Yet concurrency is a reality in our world and with computers. It is even more as we have multicore computers that, just like lanes, can be used at once. Software developers quietly learn to stop thinking in a concurrent way.

Fortunately we have a number of ways to program concurrently. We are going to learn the basic concepts of concurrency programming using Elixir, which uses the actor model of concurrency. Elixir was built for concurrency, so we don't need any special libraries or syntax to access it. You can express it simply. 

What are we going to do? We are consultants who are trying to help Santa Claus to improve his toy making operations in the North Pole. Santa Claus has been doing all of the work himself, is tired, cranky, and has a huge backlog. We tried to say that if we employs elves, he can it done quicker. Santa Claus is very conservative and set in his ways. But he said that if we build a computer simulation that can prove to him that it will be done quicker, he will accept our recommendation.  

## Santa's Workshop

When we arrived at Santa's shop, we found that Santa was doing all of the work himself. We learned that creating a toy took about 3 minutes, using his peppermint magic tools. So our first task is to create a simulation where we represent each minute as a second.

## Adding four elfs


## Elixir syntax
