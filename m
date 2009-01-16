From: akpm@linux-foundation.org
Subject: + x86-define-arch_want_frame_pointers-fix.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:46:16 -0800
Message-ID: <200901162246.n0GMkGOi001512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760792AbZAPWq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeffm@suse.com, mingo@elte.hu


The patch titled
     x86-define-arch_want_frame_pointers-fix
has been added to the -mm tree.  Its filename is
     x86-define-arch_want_frame_pointers-fix.patch

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
Subject: x86-define-arch_want_frame_pointers-fix
From: Andrew Morton <akpm@linux-foundation.org>

unbust the whitespace.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/Kconfig.debug~x86-define-arch_want_frame_pointers-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~x86-define-arch_want_frame_pointers-fix
+++ a/lib/Kconfig.debug
@@ -605,9 +605,9 @@ config DEBUG_NOTIFIERS
 
 config ARCH_WANT_FRAME_POINTERS
 	bool
-       help
-        Select this config option from the architecture Kconfig, if it
-        it is preferred to always enable frame pointers on the architecture.
+	help
+	  Select this config option from the architecture Kconfig, if it
+	  it is preferred to always enable frame pointers on the architecture.
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

