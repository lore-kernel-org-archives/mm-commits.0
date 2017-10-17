From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 17 Oct 2017 14:39:55 -0700
Message-ID: <20171017213955.gpZyExC-q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934647AbdJQVj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 17:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/quirks.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN sound/usb/quirks.c~linux-next-git-rejects sound/usb/quirks.c
--- a/sound/usb/quirks.c~linux-next-git-rejects
+++ a/sound/usb/quirks.c
@@ -1128,21 +1128,6 @@ bool snd_usb_get_sample_rate_quirk(struc
 	/* devices which do not support reading the sample rate. */
 	switch (chip->usb_id) {
 	case USB_ID(0x041E, 0x4080): /* Creative Live Cam VF0610 */
-<<<<<<< HEAD
-	case USB_ID(0x045E, 0x075D): /* MS Lifecam Cinema  */
-	case USB_ID(0x045E, 0x076D): /* MS Lifecam HD-5000 */
-	case USB_ID(0x045E, 0x076E): /* MS Lifecam HD-5001 */
-	case USB_ID(0x045E, 0x076F): /* MS Lifecam HD-6000 */
-	case USB_ID(0x045E, 0x0772): /* MS Lifecam Studio */
-	case USB_ID(0x045E, 0x0779): /* MS Lifecam HD-3000 */
-	case USB_ID(0x047F, 0x02F7): /* Plantronics BT-600 */
-	case USB_ID(0x047F, 0x0415): /* Plantronics BT-300 */
-	case USB_ID(0x047F, 0xAA05): /* Plantronics DA45 */
-	case USB_ID(0x047F, 0xC022): /* Plantronics C310 */
-	case USB_ID(0x047F, 0xC02F): /* Plantronics P610 */
-	case USB_ID(0x047F, 0xC036): /* Plantronics C520-M */
-=======
->>>>>>> linux-next/akpm-base
 	case USB_ID(0x04D8, 0xFEEA): /* Benchmark DAC1 Pre */
 	case USB_ID(0x0556, 0x0014): /* Phoenix Audio TMX320VC */
 	case USB_ID(0x05A3, 0x9420): /* ELP HD USB Camera */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

