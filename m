From: akpm@linux-foundation.org
Subject: +
 kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch added to -mm tree
Date: Fri, 20 Feb 2015 16:13:50 -0800
Message-ID: <54e7cdbe.n1iiPZwhcZ3k5mCV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbbBUANv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 19:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iulia.manda21@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes

ERROR: code indent should use tabs where possible
#120: FILE: include/linux/capability.h:220:
+        return true;$

WARNING: please, no spaces at the start of a line
#120: FILE: include/linux/capability.h:220:
+        return true;$

ERROR: code indent should use tabs where possible
#125: FILE: include/linux/capability.h:225:
+        return true;$

WARNING: please, no spaces at the start of a line
#125: FILE: include/linux/capability.h:225:
+        return true;$

ERROR: code indent should use tabs where possible
#129: FILE: include/linux/capability.h:229:
+        return true;$

WARNING: please, no spaces at the start of a line
#129: FILE: include/linux/capability.h:229:
+        return true;$

ERROR: code indent should use tabs where possible
#134: FILE: include/linux/capability.h:234:
+        return true;$

WARNING: please, no spaces at the start of a line
#134: FILE: include/linux/capability.h:234:
+        return true;$

ERROR: code indent should use tabs where possible
#170: FILE: include/linux/cred.h:79:
+        return 1;$

WARNING: please, no spaces at the start of a line
#170: FILE: include/linux/cred.h:79:
+        return 1;$

ERROR: code indent should use tabs where possible
#174: FILE: include/linux/cred.h:83:
+        return 1;$

WARNING: please, no spaces at the start of a line
#174: FILE: include/linux/cred.h:83:
+        return 1;$

total: 6 errors, 6 warnings, 310 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/kernel-conditionally-support-non-root-users-groups-and-capabilities.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Iulia Manda <iulia.manda21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/capability.h~kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes include/linux/capability.h
--- a/include/linux/capability.h~kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes
+++ a/include/linux/capability.h
@@ -217,21 +217,21 @@ extern bool ns_capable(struct user_names
 #else
 static inline bool has_capability(struct task_struct *t, int cap)
 {
-        return true;
+	return true;
 }
 static inline bool has_ns_capability(struct task_struct *t,
 			      struct user_namespace *ns, int cap)
 {
-        return true;
+	return true;
 }
 static inline bool has_capability_noaudit(struct task_struct *t, int cap)
 {
-        return true;
+	return true;
 }
 static inline bool has_ns_capability_noaudit(struct task_struct *t,
 				      struct user_namespace *ns, int cap)
 {
-        return true;
+	return true;
 }
 static inline bool capable(int cap)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
fs-fat-remove-unnecessary-includes-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

