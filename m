From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:45:12 -0700
Message-ID: <552ee9f8./L2fmHcz6/ejbgBM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbbDOWpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iulia.manda21@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-conditionally-support-non-root-users-groups-and-capabilities.patch

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
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

