From: akpm@linux-foundation.org
Subject: - 3c509-remove-unnecessary-include-of-linux-pm_legacyh.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:53:08 -0700
Message-ID: <200704281053.l3SAr8MA020069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965672AbXD1KxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     3C509: Remove unnecessary include of <linux/pm_legacy.h>
has been removed from the -mm tree.  Its filename was
     3c509-remove-unnecessary-include-of-linux-pm_legacyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 3C509: Remove unnecessary include of <linux/pm_legacy.h>
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the apparently redundant include of <linux/pm_legacy.h>.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c509.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/3c509.c~3c509-remove-unnecessary-include-of-linux-pm_legacyh drivers/net/3c509.c
--- a/drivers/net/3c509.c~3c509-remove-unnecessary-include-of-linux-pm_legacyh
+++ a/drivers/net/3c509.c
@@ -83,7 +83,6 @@ static int max_interrupt_work = 10;
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>	/* for udelay() */
 #include <linux/spinlock.h>
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-powerpc.patch
git-drm.patch
git-input.patch
git-netdev-all.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
arm26-remove-useless-config-option-generic_bust_spinlock.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
clarify-the-creation-of-the-localversion_auto-string.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
