From: akpm@linux-foundation.org
Subject: + c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch added to -mm tree
Date: Mon, 12 Dec 2011 13:54:02 -0800
Message-ID: <201112122154.pBCLs7US029985@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:47242 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1LLVyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 16:54:09 -0500
Received: by mail-qy0-f202.google.com with SMTP id g15so689996qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 13:54:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     Subject: c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix
has been added to the -mm tree.  Its filename is
     c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

