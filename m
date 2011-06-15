From: akpm@linux-foundation.org
Subject: + drivers-staging-solo6x10-corec-needs-slabh.patch added to -mm tree
Date: Wed, 15 Jun 2011 16:46:48 -0700
Message-ID: <201106160024.p5G0O2Lb028468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab1FPAYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 20:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     drivers/staging/solo6x10/core.c needs slab.h
has been added to the -mm tree.  Its filename is
     drivers-staging-solo6x10-corec-needs-slabh.patch

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
Subject: drivers/staging/solo6x10/core.c needs slab.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/staging/solo6x10/core.c:140: error: implicit declaration of function 'kzalloc'

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/solo6x10/core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/solo6x10/core.c~drivers-staging-solo6x10-corec-needs-slabh drivers/staging/solo6x10/core.c
--- a/drivers/staging/solo6x10/core.c~drivers-staging-solo6x10-corec-needs-slabh
+++ a/drivers/staging/solo6x10/core.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include "solo6x10.h"
 #include "tw28.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
drivers-staging-solo6x10-corec-needs-slabh.patch

