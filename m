From: akpm@linux-foundation.org
Subject: + drivers-staging-iio-industrialio-corec-make-it-compile.patch added to -mm tree
Date: Wed, 23 Nov 2011 15:14:31 -0800
Message-ID: <201111232355.pANNtbS7001354@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:33314 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1KXACe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 19:02:34 -0500
Received: by faap21 with SMTP id p21so17293faa.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 16:02:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, jic23@cam.ac.uk, michael.hennerich@analog.com


The patch titled
     Subject: drivers/staging/iio/industrialio-core.c: make it compile
has been added to the -mm tree.  Its filename is
     drivers-staging-iio-industrialio-corec-make-it-compile.patch

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
Subject: drivers/staging/iio/industrialio-core.c: make it compile


Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/industrialio-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/iio/industrialio-core.c~drivers-staging-iio-industrialio-corec-make-it-compile drivers/staging/iio/industrialio-core.c
--- a/drivers/staging/iio/industrialio-core.c~drivers-staging-iio-industrialio-corec-make-it-compile
+++ a/drivers/staging/iio/industrialio-core.c
@@ -259,7 +259,7 @@ static int iio_event_getfd(struct iio_de
 				indio_dev->event_interface, O_RDONLY);
 	if (fd < 0) {
 		mutex_lock(&indio_dev->event_interface->event_list_lock);
-		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
+//		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
 		mutex_unlock(&indio_dev->event_interface->event_list_lock);
 	}
 	return fd;
_
Subject: Subject: drivers/staging/iio/industrialio-core.c: make it compile

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-staging-iio-industrialio-corec-make-it-compile.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
include-net-netprio_cgrouph-various-fixes.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
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
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

