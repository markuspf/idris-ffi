#ifndef __IDRIS_FFI_H
#define __IDRIS_FFI_H

struct idris_ffi_retvals {
	size_t len;
	Closure *values;	
}

int idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index);
double idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index);
char *idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index);
struct idris_ffi_retvals *idris_ffi_allocate(size_t count);
void idris_ffi_free(struct idris_ffi_retvals *buf);

#endif
