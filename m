From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch added to -mm tree
Date: Tue, 24 Aug 2010 16:35:52 -0700
Message-ID: <201008242335.o7ONZqWZ022649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932830Ab0HXXix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 19:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie, andremuellerster@gmail.com, chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, eric@anholt.net, ziegler@uni-freiburg.de


The patch titled
     drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch

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
Subject: drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h
From: Andrew Morton <akpm@linux-foundation.org>

drivers/gpu/drm/i915/intel_overlay.c: In function 'intel_overlay_print_error_state':

drivers/gpu/drm/i915/intel_overlay.c:1467: error: implicit declaration of function 'seq_printf'

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16811

Reported-by: Martin Ziegler <ziegler@uni-freiburg.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Andre Muller <andremuellerster@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_overlay.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_overlay.c~drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh drivers/gpu/drm/i915/intel_overlay.c
--- a/drivers/gpu/drm/i915/intel_overlay.c~drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh
+++ a/drivers/gpu/drm/i915/intel_overlay.c
@@ -25,6 +25,8 @@
  *
  * Derived from Xorg ddx, xf86-video-intel, src/i830_video.c
  */
+
+#include <linux/seq_file.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

