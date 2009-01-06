From: akpm@linux-foundation.org
Subject: - add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:47:49 -0800
Message-ID: <200901062047.n06Klo7m006733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbZAFUsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:48:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch

This patch was dropped because you all suck

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#43: FILE: include/linux/kernel.h:343:
+        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#45: FILE: include/linux/kernel.h:345:
+        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#47: FILE: include/linux/kernel.h:347:
+        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#49: FILE: include/linux/kernel.h:349:
+        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#51: FILE: include/linux/kernel.h:351:
+        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#53: FILE: include/linux/kernel.h:353:
+        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#55: FILE: include/linux/kernel.h:355:
+        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)$

total: 7 errors, 0 warnings, 55 lines checked

./patches/add-pr_prefix-to-pr_xyz-macros.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <greg@kroah.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/kernel.h~add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes include/linux/kernel.h
--- a/include/linux/kernel.h~add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes
+++ a/include/linux/kernel.h
@@ -340,19 +340,19 @@ static inline char *pack_hex_byte(char *
 #endif
 
 #define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-mmapc-fix-coding-style.patch
mm-check-for-no-mmaps-in-exit_mmap.patch
mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch
mm-hugetlb-get-rid-of-redundant-if-operation.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module.patch
binfmtsh-include-listh.patch
spi_gpio-driver.patch
kprobes-support-probing-module-__exit-function.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
minix-fix-add-links-wrong-position-calculation.patch
fs-execc-make-do_coredump-void.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-x38-use-the-architectures-readq-function.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event.patch

