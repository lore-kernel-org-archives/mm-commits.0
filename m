From: akpm@linux-foundation.org
Subject: [folded-merged]
 initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 20 Jun 2014 13:28:00 -0700
Message-ID: <53a49950.94aToaUe29YPqrKH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaFTU2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 16:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, akpm@linux-foundation.org


The patch titled
     Subject: initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch

This patch was dropped because it was folded into initramfs-support-initramfs-that-is-more-than-2g.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes

WARNING: quoted string split across lines
#60: FILE: fs/isofs/compress.c:163:
 					       " page idx = %d, bh idx = %d,"
+					       " avail_in = %ld,"

WARNING: quoted string split across lines
#61: FILE: fs/isofs/compress.c:164:
+					       " avail_in = %ld,"
+					       " avail_out = %ld\n",

WARNING: missing space after return type
#76: FILE: include/linux/decompress/bunzip2.h:5:
+	    long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#77: FILE: include/linux/decompress/bunzip2.h:6:
+	    long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#94: FILE: include/linux/decompress/generic.h:5:
+			      long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#95: FILE: include/linux/decompress/generic.h:6:
+			      long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#122: FILE: include/linux/decompress/inflate.h:5:
+	   long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#123: FILE: include/linux/decompress/inflate.h:6:
+	   long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#140: FILE: include/linux/decompress/unlz4.h:5:
+	long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#141: FILE: include/linux/decompress/unlz4.h:6:
+	long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#158: FILE: include/linux/decompress/unlzma.h:5:
+	   long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#159: FILE: include/linux/decompress/unlzma.h:6:
+	   long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#177: FILE: include/linux/decompress/unlzo.h:5:
+	long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#178: FILE: include/linux/decompress/unlzo.h:6:
+	long(*flush)(void*, unsigned long),

WARNING: please, no spaces at the start of a line
#210: FILE: include/linux/zlib.h:86:
+    uLong     avail_in;  /* number of bytes available at next_in */$

WARNING: please, no spaces at the start of a line
#215: FILE: include/linux/zlib.h:90:
+    uLong     avail_out; /* remaining free space at next_out */$

WARNING: __initdata should be placed after count
#259: FILE: init/initramfs.c:177:
+static __initdata unsigned long count;

WARNING: __initdata should be placed after remains
#268: FILE: init/initramfs.c:189:
+static __initdata long remains;

WARNING: missing space after return type
#385: FILE: lib/decompress_bunzip2.c:679:
+			long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#386: FILE: lib/decompress_bunzip2.c:680:
+			long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#401: FILE: lib/decompress_bunzip2.c:747:
+			long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#402: FILE: lib/decompress_bunzip2.c:748:
+			long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#427: FILE: lib/decompress_inflate.c:37:
+		       long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#428: FILE: lib/decompress_inflate.c:38:
+		       long(*flush)(void*, unsigned long),

WARNING: Unnecessary space before function pointer arguments
#456: FILE: lib/decompress_unlz4.c:35:
+				long (*fill) (void *, unsigned long),

WARNING: Unnecessary space before function pointer arguments
#457: FILE: lib/decompress_unlz4.c:36:
+				long (*flush) (void *, unsigned long),

WARNING: missing space after return type
#479: FILE: lib/decompress_unlz4.c:179:
+			      long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#480: FILE: lib/decompress_unlz4.c:180:
+			      long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#529: FILE: lib/decompress_unlzma.c:283:
+	long(*flush)(void*, unsigned long);

WARNING: missing space after return type
#541: FILE: lib/decompress_unlzma.c:538:
+			      long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#542: FILE: lib/decompress_unlzma.c:539:
+			      long(*flush)(void*, unsigned long),

WARNING: missing space after return type
#557: FILE: lib/decompress_unlzma.c:671:
+			      long(*fill)(void*, unsigned long),

WARNING: missing space after return type
#558: FILE: lib/decompress_unlzma.c:672:
+			      long(*flush)(void*, unsigned long),

WARNING: Unnecessary space before function pointer arguments
#586: FILE: lib/decompress_unlzo.c:112:
+				long (*fill) (void *, unsigned long),

WARNING: Unnecessary space before function pointer arguments
#587: FILE: lib/decompress_unlzo.c:113:
+				long (*flush) (void *, unsigned long),

total: 0 errors, 35 warnings, 479 lines checked

./patches/initramfs-support-initramfs-that-is-more-than-2g.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/bunzip2.h |    6 +++---
 include/linux/decompress/generic.h |    6 +++---
 include/linux/decompress/inflate.h |    6 +++---
 include/linux/decompress/unlz4.h   |    6 +++---
 include/linux/decompress/unlzma.h  |    6 +++---
 include/linux/decompress/unlzo.h   |    6 +++---
 init/initramfs.c                   |    6 +++---
 lib/decompress_bunzip2.c           |   12 ++++++------
 lib/decompress_inflate.c           |    6 +++---
 lib/decompress_unlz4.c             |    6 +++---
 lib/decompress_unlzma.c            |   14 +++++++-------
 11 files changed, 40 insertions(+), 40 deletions(-)

diff -puN include/linux/decompress/bunzip2.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/bunzip2.h
--- a/include/linux/decompress/bunzip2.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/bunzip2.h
@@ -2,9 +2,9 @@
 #define DECOMPRESS_BUNZIP2_H
 
 int bunzip2(unsigned char *inbuf, long len,
-	    long(*fill)(void*, unsigned long),
-	    long(*flush)(void*, unsigned long),
+	    long (*fill)(void*, unsigned long),
+	    long (*flush)(void*, unsigned long),
 	    unsigned char *output,
 	    long *pos,
-	    void(*error)(char *x));
+	    void (*error)(char *x));
 #endif
diff -puN include/linux/decompress/generic.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/generic.h
--- a/include/linux/decompress/generic.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/generic.h
@@ -2,11 +2,11 @@
 #define DECOMPRESS_GENERIC_H
 
 typedef int (*decompress_fn) (unsigned char *inbuf, long len,
-			      long(*fill)(void*, unsigned long),
-			      long(*flush)(void*, unsigned long),
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
 			      unsigned char *outbuf,
 			      long *posp,
-			      void(*error)(char *x));
+			      void (*error)(char *x));
 
 /* inbuf   - input buffer
  *len     - len of pre-read data in inbuf
diff -puN include/linux/decompress/inflate.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/inflate.h
--- a/include/linux/decompress/inflate.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/inflate.h
@@ -2,9 +2,9 @@
 #define LINUX_DECOMPRESS_INFLATE_H
 
 int gunzip(unsigned char *inbuf, long len,
-	   long(*fill)(void*, unsigned long),
-	   long(*flush)(void*, unsigned long),
+	   long (*fill)(void*, unsigned long),
+	   long (*flush)(void*, unsigned long),
 	   unsigned char *output,
 	   long *pos,
-	   void(*error_fn)(char *x));
+	   void (*error_fn)(char *x));
 #endif
diff -puN include/linux/decompress/unlz4.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/unlz4.h
--- a/include/linux/decompress/unlz4.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/unlz4.h
@@ -2,9 +2,9 @@
 #define DECOMPRESS_UNLZ4_H
 
 int unlz4(unsigned char *inbuf, long len,
-	long(*fill)(void*, unsigned long),
-	long(*flush)(void*, unsigned long),
+	long (*fill)(void*, unsigned long),
+	long (*flush)(void*, unsigned long),
 	unsigned char *output,
 	long *pos,
-	void(*error)(char *x));
+	void (*error)(char *x));
 #endif
diff -puN include/linux/decompress/unlzma.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/unlzma.h
--- a/include/linux/decompress/unlzma.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/unlzma.h
@@ -2,11 +2,11 @@
 #define DECOMPRESS_UNLZMA_H
 
 int unlzma(unsigned char *, long,
-	   long(*fill)(void*, unsigned long),
-	   long(*flush)(void*, unsigned long),
+	   long (*fill)(void*, unsigned long),
+	   long (*flush)(void*, unsigned long),
 	   unsigned char *output,
 	   long *posp,
-	   void(*error)(char *x)
+	   void (*error)(char *x)
 	);
 
 #endif
diff -puN include/linux/decompress/unlzo.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes include/linux/decompress/unlzo.h
--- a/include/linux/decompress/unlzo.h~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/include/linux/decompress/unlzo.h
@@ -2,9 +2,9 @@
 #define DECOMPRESS_UNLZO_H
 
 int unlzo(unsigned char *inbuf, long len,
-	long(*fill)(void*, unsigned long),
-	long(*flush)(void*, unsigned long),
+	long (*fill)(void*, unsigned long),
+	long (*flush)(void*, unsigned long),
 	unsigned char *output,
 	long *pos,
-	void(*error)(char *x));
+	void (*error)(char *x));
 #endif
diff -puN init/initramfs.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes init/initramfs.c
--- a/init/initramfs.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/init/initramfs.c
@@ -173,9 +173,9 @@ static __initdata enum state {
 	Reset
 } state, next_state;
 
-static __initdata char *victim;
-static __initdata unsigned long count;
-static __initdata loff_t this_header, next_header;
+static char *victim __initdata;
+static unsigned long count __initdata;
+static loff_t this_header, next_header __initdata;
 
 static inline void __init eat(unsigned n)
 {
diff -puN lib/decompress_bunzip2.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/lib/decompress_bunzip2.c
@@ -676,11 +676,11 @@ static int INIT start_bunzip(struct bunz
 /* Example usage: decompress src_fd to dst_fd.  (Stops at end of bzip2 data,
    not end of file.) */
 STATIC int INIT bunzip2(unsigned char *buf, long len,
-			long(*fill)(void*, unsigned long),
-			long(*flush)(void*, unsigned long),
+			long (*fill)(void*, unsigned long),
+			long (*flush)(void*, unsigned long),
 			unsigned char *outbuf,
 			long *pos,
-			void(*error)(char *x))
+			void (*error)(char *x))
 {
 	struct bunzip_data *bd;
 	int i = -1;
@@ -744,11 +744,11 @@ exit_0:
 
 #ifdef PREBOOT
 STATIC int INIT decompress(unsigned char *buf, long len,
-			long(*fill)(void*, unsigned long),
-			long(*flush)(void*, unsigned long),
+			long (*fill)(void*, unsigned long),
+			long (*flush)(void*, unsigned long),
 			unsigned char *outbuf,
 			long *pos,
-			void(*error)(char *x))
+			void (*error)(char *x))
 {
 	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
 }
diff -puN lib/decompress_inflate.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/lib/decompress_inflate.c
@@ -34,11 +34,11 @@ static long INIT nofill(void *buffer, un
 
 /* Included from initramfs et al code */
 STATIC int INIT gunzip(unsigned char *buf, long len,
-		       long(*fill)(void*, unsigned long),
-		       long(*flush)(void*, unsigned long),
+		       long (*fill)(void*, unsigned long),
+		       long (*flush)(void*, unsigned long),
 		       unsigned char *out_buf,
 		       long *pos,
-		       void(*error)(char *x)) {
+		       void (*error)(char *x)) {
 	u8 *zbuf;
 	struct z_stream_s *strm;
 	int rc;
diff -puN lib/decompress_unlz4.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/lib/decompress_unlz4.c
@@ -176,11 +176,11 @@ exit_0:
 
 #ifdef PREBOOT
 STATIC int INIT decompress(unsigned char *buf, long in_len,
-			      long(*fill)(void*, unsigned long),
-			      long(*flush)(void*, unsigned long),
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
 			      unsigned char *output,
 			      long *posp,
-			      void(*error)(char *x)
+			      void (*error)(char *x)
 	)
 {
 	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
diff -puN lib/decompress_unlzma.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes
+++ a/lib/decompress_unlzma.c
@@ -280,7 +280,7 @@ struct writer {
 	size_t buffer_pos;
 	int bufsize;
 	size_t global_pos;
-	long(*flush)(void*, unsigned long);
+	long (*flush)(void*, unsigned long);
 	struct lzma_header *header;
 };
 
@@ -535,11 +535,11 @@ static inline int INIT process_bit1(stru
 
 
 STATIC inline int INIT unlzma(unsigned char *buf, long in_len,
-			      long(*fill)(void*, unsigned long),
-			      long(*flush)(void*, unsigned long),
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
 			      unsigned char *output,
 			      long *posp,
-			      void(*error)(char *x)
+			      void (*error)(char *x)
 	)
 {
 	struct lzma_header header;
@@ -668,11 +668,11 @@ exit_0:
 
 #ifdef PREBOOT
 STATIC int INIT decompress(unsigned char *buf, long in_len,
-			      long(*fill)(void*, unsigned long),
-			      long(*flush)(void*, unsigned long),
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
 			      unsigned char *output,
 			      long *posp,
-			      void(*error)(char *x)
+			      void (*error)(char *x)
 	)
 {
 	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g.patch
initramfs-support-initramfs-that-is-more-than-2g-fix-2.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

