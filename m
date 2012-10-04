From: akpm@linux-foundation.org
Subject: [folded-dropped] sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:54:02 -0700
Message-ID: <20121004235402.8375B10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:64379 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:54:03 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so90282yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:54:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, jmario@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sectons-fix-const-sections-for-crc32-table-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch

This patch was dropped because it was folded into sectons-fix-const-sections-for-crc32-table.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sectons-fix-const-sections-for-crc32-table-checkpatch-fixes

ERROR: code indent should use tabs where possible
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

ERROR: code indent should use tabs where possible
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

ERROR: code indent should use tabs where possible
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

total: 3 errors, 6 warnings, 48 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/sectons-fix-const-sections-for-crc32-table.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Mario <jmario@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gen_crc32table.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/gen_crc32table.c~sectons-fix-const-sections-for-crc32-table-checkpatch-fixes lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~sectons-fix-const-sections-for-crc32-table-checkpatch-fixes
+++ a/lib/gen_crc32table.c
@@ -109,7 +109,7 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32table_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
@@ -119,7 +119,7 @@ int main(int argc, char** argv)
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32table_be[%d][%d] = {",
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
@@ -128,7 +128,7 @@ int main(int argc, char** argv)
 	}
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32ctable_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

