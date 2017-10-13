From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 13 Oct 2017 13:25:06 -0700
Message-ID: <20171013202506.CbAmhczFO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdJMUZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 16:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
fix-mpage_writepage-for-pages-with-buffers-fix.patch
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
linux-next-git-rejects.patch

