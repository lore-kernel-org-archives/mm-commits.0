From: akpm@linux-foundation.org
Subject: + memcg-document-cgroup-dirty-memory-interfaces-fix.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:41 -0700
Message-ID: <201010292019.o9TKJf5n014950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761588Ab0J2UUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-document-cgroup-dirty-memory-interfaces-fix
has been added to the -mm tree.  Its filename is
     memcg-document-cgroup-dirty-memory-interfaces-fix.patch

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
Subject: memcg-document-cgroup-dirty-memory-interfaces-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix use_hierarchy description

Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces-fix
+++ a/Documentation/cgroups/memory.txt
@@ -520,11 +520,12 @@ When use_hierarchy=0, each cgroup has di
 System-wide dirty limits are also consulted.  Dirty memory consumption is
 checked against both system-wide and per-cgroup dirty limits.
 
-The current implementation does enforce per-cgroup dirty limits when
+The current implementation does not enforce per-cgroup dirty limits when
 use_hierarchy=1.  System-wide dirty limits are used for processes in such
-cgroups.  Attempts to read memory.dirty_* files return the system-wide values.
-Writes to the memory.dirty_* files return error.  An enhanced implementation is
-needed to check the chain of parents to ensure that no dirty limit is exceeded.
+cgroups.  Attempts to read memory.dirty_* files return the system-wide
+values.  Writes to the memory.dirty_* files return error.  An enhanced
+implementation is needed to check the chain of parents to ensure that no
+dirty limit is exceeded.
 
 6. Hierarchy support
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

