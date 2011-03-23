From: akpm@linux-foundation.org
Subject: [folded] memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:20:33 -0700
Message-ID: <201103232320.p2NNKXKw004393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933114Ab1CWXVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-use-native-word-page-statistics-counters.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#60: FILE: mm/memcontrol.c:106:
+        MEM_CGROUP_TARGET_THRESH,$

WARNING: please, no spaces at the start of a line
#60: FILE: mm/memcontrol.c:106:
+        MEM_CGROUP_TARGET_THRESH,$

ERROR: code indent should use tabs where possible
#61: FILE: mm/memcontrol.c:107:
+        MEM_CGROUP_TARGET_SOFTLIMIT,$

WARNING: please, no spaces at the start of a line
#61: FILE: mm/memcontrol.c:107:
+        MEM_CGROUP_TARGET_SOFTLIMIT,$

ERROR: code indent should use tabs where possible
#62: FILE: mm/memcontrol.c:108:
+        MEM_CGROUP_NTARGETS,$

WARNING: please, no spaces at the start of a line
#62: FILE: mm/memcontrol.c:108:
+        MEM_CGROUP_NTARGETS,$

ERROR: code indent should use tabs where possible
#70: FILE: mm/memcontrol.c:116:
+        unsigned long targets[MEM_CGROUP_NTARGETS];$

WARNING: please, no spaces at the start of a line
#70: FILE: mm/memcontrol.c:116:
+        unsigned long targets[MEM_CGROUP_NTARGETS];$

ERROR: code indent should use tabs where possible
#86: FILE: mm/memcontrol.c:648:
+        /* from time_after() in jiffies.h */$

ERROR: code indent should use tabs where possible
#93: FILE: mm/memcontrol.c:654:
+        unsigned long val, next;$

WARNING: please, no spaces at the start of a line
#93: FILE: mm/memcontrol.c:654:
+        unsigned long val, next;$

ERROR: code indent should use tabs where possible
#97: FILE: mm/memcontrol.c:658:
+        switch (target) {$

WARNING: please, no spaces at the start of a line
#97: FILE: mm/memcontrol.c:658:
+        switch (target) {$

ERROR: code indent should use tabs where possible
#98: FILE: mm/memcontrol.c:659:
+        case MEM_CGROUP_TARGET_THRESH:$

WARNING: please, no spaces at the start of a line
#98: FILE: mm/memcontrol.c:659:
+        case MEM_CGROUP_TARGET_THRESH:$

ERROR: code indent should use tabs where possible
#100: FILE: mm/memcontrol.c:661:
+            ^Ibreak;$

WARNING: please, no space before tabs
#100: FILE: mm/memcontrol.c:661:
+            ^Ibreak;$

WARNING: please, no spaces at the start of a line
#100: FILE: mm/memcontrol.c:661:
+            ^Ibreak;$

ERROR: code indent should use tabs where possible
#101: FILE: mm/memcontrol.c:662:
+        case MEM_CGROUP_TARGET_SOFTLIMIT:$

WARNING: please, no spaces at the start of a line
#101: FILE: mm/memcontrol.c:662:
+        case MEM_CGROUP_TARGET_SOFTLIMIT:$

ERROR: code indent should use tabs where possible
#103: FILE: mm/memcontrol.c:664:
+            ^Ibreak;$

WARNING: please, no space before tabs
#103: FILE: mm/memcontrol.c:664:
+            ^Ibreak;$

WARNING: please, no spaces at the start of a line
#103: FILE: mm/memcontrol.c:664:
+            ^Ibreak;$

ERROR: code indent should use tabs where possible
#106: FILE: mm/memcontrol.c:667:
+        }$

WARNING: please, no spaces at the start of a line
#106: FILE: mm/memcontrol.c:667:
+        }$

ERROR: code indent should use tabs where possible
#108: FILE: mm/memcontrol.c:669:
+        this_cpu_write(mem->stat->targets[target], next);$

WARNING: please, no spaces at the start of a line
#108: FILE: mm/memcontrol.c:669:
+        this_cpu_write(mem->stat->targets[target], next);$

ERROR: code indent should use tabs where possible
#120: FILE: mm/memcontrol.c:681:
+                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);$

WARNING: please, no spaces at the start of a line
#120: FILE: mm/memcontrol.c:681:
+                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);$

total: 14 errors, 15 warnings, 93 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -103,9 +103,9 @@ enum mem_cgroup_events_index {
  * than using jiffies etc. to handle periodic memcg event.
  */
 enum mem_cgroup_events_target {
-        MEM_CGROUP_TARGET_THRESH,
-        MEM_CGROUP_TARGET_SOFTLIMIT,
-        MEM_CGROUP_NTARGETS,
+	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_NTARGETS,
 };
 #define THRESHOLDS_EVENTS_TARGET (128)
 #define SOFTLIMIT_EVENTS_TARGET (1024)
@@ -113,7 +113,7 @@ enum mem_cgroup_events_target {
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
-        unsigned long targets[MEM_CGROUP_NTARGETS];
+	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
 /*
@@ -645,28 +645,28 @@ static bool __memcg_event_check(struct m
 
 	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 	next = this_cpu_read(mem->stat->targets[target]);
-        /* from time_after() in jiffies.h */
+	/* from time_after() in jiffies.h */
 	return ((long)next - (long)val < 0);
 }
 
 static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
 {
-        unsigned long val, next;
+	unsigned long val, next;
 
 	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
-        switch (target) {
-        case MEM_CGROUP_TARGET_THRESH:
+	switch (target) {
+	case MEM_CGROUP_TARGET_THRESH:
 		next = val + THRESHOLDS_EVENTS_TARGET;
-            	break;
-        case MEM_CGROUP_TARGET_SOFTLIMIT:
+		break;
+	case MEM_CGROUP_TARGET_SOFTLIMIT:
 		next = val + SOFTLIMIT_EVENTS_TARGET;
-            	break;
+		break;
 	default:
 		return;
-        }
+	}
 
-        this_cpu_write(mem->stat->targets[target], next);
+	this_cpu_write(mem->stat->targets[target], next);
 }
 
 /*
@@ -678,7 +678,7 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(mem);
-                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
+		__mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
 		if (unlikely(__memcg_event_check(mem,
 			MEM_CGROUP_TARGET_SOFTLIMIT))){
 			mem_cgroup_update_tree(mem, page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

