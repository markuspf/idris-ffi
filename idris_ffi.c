#include <idris_rts.h>
#include <idris_ffi.h>

int idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index)
{
        return((int)buf->values[index].info);
}

double idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index)
{
        return((double)buf->values[index].info);
}

char *idris_ffi_extract_int(struct idris_ffi_retvals *buf, size_t index)
{
        return((char *)buf->values[index].info);
}

struct idris_ffi_retvals *idris_ffi_allocate(size_t count)
{
        struct idris_ffi_retvals *buf; 
 
        buf = calloc(count, sizeof(struct idris_ffi_retvals));
 
        return buf;
}

void idris_ffi_free(struct idris_ffi_retvals *buf)
{
	free(buf);
}

