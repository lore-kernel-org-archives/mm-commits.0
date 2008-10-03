From: akpm@linux-foundation.org
Subject: - drivers-net-hp-plusc-fix-build-error.patch removed from -mm tree
Date: Fri, 03 Oct 2008 05:43:04 -0700
Message-ID: <200810031243.m93Ch42a027878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYJCMoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 08:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/hp-plus.c: fix build error
has been removed from the -mm tree.  Its filename was
     drivers-net-hp-plusc-fix-build-error.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/hp-plus.c: fix build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hp-plus build error (yet again; will it ever end?):

hp-plus.c:(.init.text+0xa2cd): undefined reference to `NS8390p_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hp-plus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hp-plus.c~drivers-net-hp-plusc-fix-build-error drivers/net/hp-plus.c
--- a/drivers/net/hp-plus.c~drivers-net-hp-plusc-fix-build-error
+++ a/drivers/net/hp-plus.c
@@ -262,7 +262,7 @@ static int __init hpp_probe1(struct net_
 	}
 
 	outw(Perf_Page, ioaddr + HP_PAGING);
-	NS8390p_init(dev, 0);
+	NS8390_init(dev, 0);
 	/* Leave the 8390 and HP chip reset. */
 	outw(inw(ioaddr + HPP_OPTION) & ~EnableIRQ, ioaddr + HPP_OPTION);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

drivers-net-hp-plusc-fix-build-error.patch
git-x86.patch
git-ftrace.patch
git-hid.patch
git-acpi.patch
git-net.patch
git-sound.patch
git-block.patch
git-slab.patch
git-drm.patch
git-security-testing.patch
git-fastboot.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

