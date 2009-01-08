From: akpm@linux-foundation.org
Subject: + kernel-trace-ring_bufferc-use-div_round_up-fix.patch added to -mm tree
Date: Wed, 07 Jan 2009 21:34:17 -0800
Message-ID: <200901080534.n085YHfd019809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbZAHFe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 00:34:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     kernel-trace-ring_bufferc-use-div_round_up-fix
has been added to the -mm tree.  Its filename is
     kernel-trace-ring_bufferc-use-div_round_up-fix.patch

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
Subject: kernel-trace-ring_bufferc-use-div_round_up-fix
From: Andrew Morton <akpm@linux-foundation.org>

oops

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up-fix kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-use-div_round_up-fix
+++ a/kernel/trace/ring_buffer.c
@@ -150,7 +150,7 @@ rb_event_length(struct ring_buffer_event
 
 	case RINGBUF_TYPE_DATA:
 		if (event->len)
-			length = event->len / RB_ALIGNMENT;
+			length = event->len * RB_ALIGNMENT;
 		else
 			length = event->array[0];
 		return length + RB_EVNT_HDR_SIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
w1-allow-master-io-commands.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
kernel-trace-ring_bufferc-use-div_round_up-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

