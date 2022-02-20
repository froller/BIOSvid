#ifndef _VIDEO_H_
#define _VIDEO_H_

#include <stdlib.h>

void far * _cdecl char_address(
  const unsigned char x,
  const unsigned char y
);

void _cdecl save_region(
  void *buffer,
  const unsigned char x,
  const unsigned char y,
  const unsigned char w,
  const unsigned char h
);

void _cdecl restore_region
(
  const unsigned char x,
  const unsigned char y,
  const unsigned char w,
  const unsigned char h,
  const void *buffer
);

#endif // _VIDEO_H_