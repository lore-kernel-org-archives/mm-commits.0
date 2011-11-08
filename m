From: akpm@linux-foundation.org
Subject: + cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch added to -mm tree
Date: Tue, 08 Nov 2011 13:45:20 -0800
Message-ID: <201111082145.pA8LjLbb017506@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:52813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1KHVp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 16:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu, fweisbec@gmail.com


The patch titled
     Subject: cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch

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
Subject: cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes

Cc: Ben Blum <bblum@andrew.cmu.edu>

WARNING: line over 80 characters
#260: FILE: kernel/cgroup.c:2204:
+					ss->cancel_attach_task(cgrp, tc->oldcgrp, tc->tsk);

total: 0 errors, 1 warnings, 198 lines checked

./patches/cgroup-fix-task-counter-common-ancestor-logic.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes
+++ a/kernel/cgroup.c
@@ -2201,7 +2201,8 @@ out_cancel_attach:
 					tc = flex_array_get(group, i);
 					if (tc->tsk == failed_task)
 						break;
-					ss->cancel_attach_task(cgrp, tc->oldcgrp, tc->tsk);
+					ss->cancel_attach_task(cgrp,
+							tc->oldcgrp, tc->tsk);
 				}
 			}
 
_
Subject: Subject: cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

