From: akpm@linux-foundation.org
Subject: + include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 14:36:34 -0800
Message-ID: <52faa5f2.L/bs+N9xS8H3oyLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBKWgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:36:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, benh@kernel.crashing.org, rashika.kheria@gmail.com

Subject: + include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch added to -mm tree
To: rashika.kheria@gmail.com,benh@kernel.crashing.org,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:36:34 -0800


The patch titled
     Subject: include/linux/crash_dump.h: add vmcore_cleanup() prototype
has been added to the -mm tree.  Its filename is
     include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: include/linux/crash_dump.h: add vmcore_cleanup() prototype

Eliminate the following warning in proc/vmcore.c:
fs/proc/vmcore.c:1088:6: warning: no previous prototype for `vmcore_cleanup' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/crash_dump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype
+++ a/include/linux/crash_dump.h
@@ -25,6 +25,7 @@ extern int __weak remap_oldmem_pfn_range
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+void vmcore_cleanup(void);
 
 /* Architecture code defines this if there are other possible ELF
  * machine types, e.g. on bi-arch capable hardware. */
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

