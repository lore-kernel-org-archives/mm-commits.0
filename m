From: akpm@linux-foundation.org
Subject: - mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:46 -0700
Message-ID: <200807141935.m6EJZkj1023951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163AbYGNTgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: fix const assignment in the command line partitioning driver
has been removed from the -mm tree.  Its filename was
     mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix const assignment in the command line partitioning driver
From: David Howells <dhowells@redhat.com>

Fix const to non-const pointer assignment in the MTD command line partitioning
driver.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/cmdlinepart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/cmdlinepart.c~mtd-fix-const-assignment-in-the-command-line-partitioning-driver drivers/mtd/cmdlinepart.c
--- a/drivers/mtd/cmdlinepart.c~mtd-fix-const-assignment-in-the-command-line-partitioning-driver
+++ a/drivers/mtd/cmdlinepart.c
@@ -306,7 +306,7 @@ static int parse_cmdline_partitions(stru
 	unsigned long offset;
 	int i;
 	struct cmdline_mtd_partition *part;
-	char *mtd_id = master->name;
+	const char *mtd_id = master->name;
 
 	/* parse command line */
 	if (!cmdline_parsed)
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

