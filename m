From: akpm@linux-foundation.org
Subject: [folded] c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:59:49 -0800
Message-ID: <20120113005949.B62FD1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:59181 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMA7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:59:51 -0500
Received: by ghrr18 with SMTP id r18so124779ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:59:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix
has been removed from the -mm tree.  Its filename was
     c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch

This patch was dropped because it was folded into c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix
+++ a/Documentation/filesystems/proc.txt
@@ -309,7 +309,7 @@ Table 1-4: Contents of the stat files (a
   cgtime        guest time of the task children in jiffies
   start_data    address above which program data+bss is placed
   end_data      address below which program data+bss is placed
-  start_brk     address above which program heap can be expaned with brk() call
+  start_brk     address above which program heap can be expanded with brk()
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

