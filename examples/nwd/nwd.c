/** argumenty z linii komend - przy okazji tworzymy wzorzec z wykorzystaniem argp
 *
 * \param liczba1 liczba 2
 *
 */

/* 
 * File:   nwd.c
 * Author: jurekw "Galicea"
 *
 * Created on 17 września 2016, 08:24
 */


#include <stdio.h>
#include <stdlib.h>
#include <argp.h>

static char doc[] = "Największy wspólny podzielnik da dwóch";
static char args_doc[] = "LICZBA1 LICZBA2";
//static char err[] = "Podaj dokładne dwie liczby całkowite";

static struct argp_option options[] = {
  {"verbose",  'v', 0,      0,  "Pisz wyniki pośrednie" }
};

struct arguments {
  int args[2];                /* arg1 & arg2 */
  int verbose;
};

/* Parse a single option. */
static error_t parse_opt(int key, char *arg, struct argp_state *state)
{
  /* Get the input argument from argp_parse, which we
     know is a pointer to our arguments structure. */
  struct arguments *arguments = state->input;

  switch (key) {
    case 'v':
      arguments->verbose = 1;
      break;

    case ARGP_KEY_ARG:
      if (state->arg_num >= 2)
        /* Too many arguments. */
        argp_usage (state);

      arguments->args[state->arg_num] =  atoi(arg);

      break;

    case ARGP_KEY_END:
      if (state->arg_num < 2)
        /* Not enough arguments. */
        argp_usage (state);
      break;

    default:
      return ARGP_ERR_UNKNOWN;
    }
  return 0;
}

/* Our argp parser. */
static struct argp argp = { options, parse_opt, args_doc, doc };

int main (int argc, char **argv)  {
  struct arguments arguments;

  /* Default values. */
  arguments.verbose = 0;

  /* Parse our arguments; every option seen by parse_opt will be reflected in arguments. */
  argp_parse (&argp, argc, argv, 0, 0, &arguments);

  printf("LICZBA1 = %5d\nLICZBA2 = %5d\n VERBOSE = %s\n",
          arguments.args[0], arguments.args[1],
          arguments.verbose ? "yes" : "no");

  int a=arguments.args[0];
  int b=arguments.args[1];
  if ((a>0) && (b>0)) {
    while (a != b) {
      if (arguments.verbose>0) printf("a=%5d ; b=%5d\n", a, b);
      if (a<b) b -= a;
      else a -=b;
    }
  }
  printf("\nNWD = %25d\n", a);
  return 0;
}

