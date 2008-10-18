From: akpm@linux-foundation.org
Subject: - pnp-remove-printk-with-outdated-version.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:11 -0700
Message-ID: <200810182318.m9INIBbi029233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbYJRXSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, abelay@MIT.EDU, bjorn.helgaas@hp.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnp: remove printk() with outdated version
has been removed from the -mm tree.  Its filename was
     pnp-remove-printk-with-outdated-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: remove printk() with outdated version
From: Adrian Bunk <bunk@kernel.org>

There's no point in printing some ancient version number forever.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Adam M Belay <abelay@MIT.EDU>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pnp/core.c~pnp-remove-printk-with-outdated-version drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-remove-printk-with-outdated-version
+++ a/drivers/pnp/core.c
@@ -218,7 +218,6 @@ void __pnp_remove_device(struct pnp_dev 
 
 static int __init pnp_init(void)
 {
-	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
 	return bus_register(&pnp_bus_type);
 }
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch

