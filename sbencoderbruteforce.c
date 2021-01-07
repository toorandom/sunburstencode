/*
Sunburst hash bruteforcer given macfile in format 00AABBCCDDEE each row and guids with - in lowercase
see help for more info
* This is the fast version for bruteforce of https://github.com/toorandom/sunburstencode/blob/main/sunburstencode.sh

* COMPILE:
* gcc thisfile.c -o sbencode -lcrypto


* RUN
* ./sbencode macs.txt guids.txt domain.com

* I tested a known hash
* MAC:112233AABBCC
* guid=ffff1f6c-b2f5-461f-82a9-59370875aaaa
* obtaining with the domain the hash: 56B8C845F49393DB

* Eduardo Ruiz Duarte
* toorandom@gmail.com
*/
#include <openssl/md5.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define MACLEN 12
#define MAXDOM 128
#define GUIDLEN 36
#define MD5LEN 32
#define SUNBURSTHASHLEN 8
void
sunbursthash (uint8_t * mac, uint8_t * dom, uint8_t * guid, uint8_t * hashy)
{
  MD5_CTX md5;
  MD5_Init (&md5);
  MD5_Update (&md5, mac, strnlen (mac, MACLEN + 1));
  MD5_Update (&md5, dom, strnlen (dom, MAXDOM + 1));
  MD5_Update (&md5, guid, strnlen (guid, GUIDLEN + 1));
  MD5_Final (hashy, &md5);
}


void
combinehash (uint8_t * sbhash, uint8_t * final)
{
  uint8_t i;
  for (i = 0; i < 8; i++)
    final[i] = sbhash[i] ^ sbhash[i + 8];
}



int
main (int argc, char **argv)
{

  uint8_t mac[MACLEN + 1], dom[MAXDOM + 1], guid[GUIDLEN + 1],
    hashy[MD5LEN + 1], final[SUNBURSTHASHLEN + 1], i;
  FILE *macfile, *guidfile;
  void *mtmp,*gtmp;

  if (argc < 4)
    {
      fprintf (stderr,
          "arg1 must be the MAC file list in uppercase without \":\"\narg2 must be the GUID file list in lowercase\narg3 the domain to be used\nEduardo@shell.com\n");
      exit (EXIT_FAILURE);
    }

  macfile = fopen (argv[1], "r");
  guidfile = fopen (argv[2], "r");
  strncpy (dom, argv[3], MAXDOM);

  if (macfile == NULL || guidfile == NULL)
    {
      perror ("fopen");
      exit (EXIT_FAILURE);
    }
  memset (&mac, 0, sizeof (mac));
  memset (&guid, 0, sizeof (guid));
  memset (&hashy, 0, sizeof (hashy));
  memset (&final, 0, sizeof (final));

  while (fgets ((char *) mac, MACLEN + 1, macfile) != NULL)
    {
      mtmp = (void *) &mac;
      if (mtmp != NULL)
   if(strnlen((char *)mtmp,MACLEN+1) == MACLEN)
   while (fgets ((char *) guid, GUIDLEN + 1, guidfile) != NULL)
     {

       gtmp = (void *) &guid;
       if (gtmp != NULL)
      if(strnlen((char *)gtmp,GUIDLEN+1) == GUIDLEN)
         {
      sunbursthash ((uint8_t *) & mac, (uint8_t *) & dom,
               (uint8_t *) & guid, (uint8_t *) & hashy);
      combinehash ((uint8_t *) & hashy, (uint8_t *) & final);
      printf ("(%s,%s,%s) -> ", mac, dom, guid);
      for (i = 0; i < SUNBURSTHASHLEN; i++)
        printf ("%02X", final[i]);
      printf ("\n");

      memset (&guid, 0, sizeof (guid));
      memset (&hashy, 0, sizeof (hashy));
      memset (&final, 0, sizeof (final));
         }


     }
      rewind (guidfile);
      memset (&mac, 0, sizeof (mac));

    }

  fclose (macfile);
  fclose (guidfile);
  return 0;

}
