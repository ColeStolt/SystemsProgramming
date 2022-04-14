/*
* minor3.c - using producer-consumer paradigm.
*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NITEMS 10       // number of items in shared buffer

// shared variables
char shared_buffer[NITEMS];   // echo buffer
int shared_count;       // item count

pthread_mutex_t mutex;       // pthread mutex
unsigned int prod_index = 0;    // producer index into shared buffer
unsigned int cons_index = 0;    // consumer index into shard buffer

// Condition variables for full and empty buffer
pthread_cond_t full;   
pthread_cond_t empty;

// function prototypes
void * producer(void *arg);
void * consumer(void *arg);

int main()
{
   pthread_t prod_tid, cons_tid1, cons_tid2;

   // initialize pthread variables
   pthread_mutex_init(&mutex, NULL);
   pthread_cond_init(&full, NULL);  // For full checks
   pthread_cond_init(&empty, NULL); // For empty checks
  
   // start producer thread
   pthread_create(&prod_tid, NULL, producer, NULL);

   // start consumer threads
   pthread_create(&cons_tid1, NULL, consumer, NULL);
   pthread_create(&cons_tid2, NULL, consumer, NULL);
  
   // wait for threads to finish
   pthread_join(prod_tid, NULL);
   pthread_join(cons_tid1, NULL);
   pthread_join(cons_tid2, NULL);
          
   // clean up  // Added two pthread destroys to remove conditions
   pthread_mutex_destroy(&mutex);
   pthread_cond_destroy(&full);
   pthread_cond_destroy(&empty);
  
   return 0;
}

// producer thread executes this function
void * producer(void *arg)
{
   char key;

   printf("Enter text for producer to read and consumer to print, use Ctrl-C to exit.\n\n");

   // this loop has the producer read in from stdin and place on the shared buffer
   while (1)
   {
       // read input key
       scanf("%c", &key);

       // acquire mutex lock
       pthread_mutex_lock(&mutex);

       // this loop is used to poll the shared buffer to see if it is full:
       // -- if full, unlock and sleep until signalled, and loop again to handle spurious wakes
       // -- if not full, keep locked and proceed to place character on shared buffer

       // loop to account for spurious wakes
       while (!(shared_count < NITEMS))
       {
           // if buffer is full, release mutex lock
           // and sleep until signalled
           pthread_cond_wait(&full, &mutex);
       }

       // store key in shared buffer
       shared_buffer[prod_index] = key;

       // update shared count variable
       shared_count++;

       // update producer index
       if (prod_index == NITEMS - 1)
           prod_index = 0;
       else
           prod_index++;
      
       // signalling the condition variable
       // since the shared buffer is not empty
       pthread_cond_signal(&empty);

       // release mutex lock
       pthread_mutex_unlock(&mutex);
   }

   return NULL;
}

// consumer thread executes this function
void * consumer(void *arg)
{
   char key;

   long unsigned int id = (long unsigned int)pthread_self();

   // this loop has the consumer gets from the shared buffer and prints to stdout
   while (1)
   {
       // acquire mutex lock
       pthread_mutex_lock(&mutex);

       // check if shared buffer is empty
       // if empty, unlock and prevent spurious wakes
       // if not empty, keep locked get character from shared buffer

       while (!(shared_count > 0))
       {
           // simply wait if empty
           pthread_cond_wait(&empty, &mutex);
       }

       // read key from shared buffer
       key = shared_buffer[cons_index];
      
       // echo key
       printf("consumer %lu: %c\n", (long unsigned int) id, key);

       // update shared count variable
       shared_count--;

       // update consumer index
       if (cons_index == NITEMS - 1)
           cons_index = 0;
       else
           cons_index++;

       // signal cond variable
       pthread_cond_signal(&full);
  
       // release mutex lock
       pthread_mutex_unlock(&mutex);
   }

   return NULL;
}
