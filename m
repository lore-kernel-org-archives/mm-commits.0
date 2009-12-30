From: akpm@linux-foundation.org
Subject: + omap3-add-missing-parentheses.patch added to -mm tree
Date: Wed, 30 Dec 2009 14:25:45 -0800
Message-ID: <200912302225.nBUMPj5a005760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbZL3W0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 17:26:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     omap3: add missing parentheses
has been added to the -mm tree.  Its filename is
     omap3-add-missing-parentheses.patch

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
Subject: omap3: add missing parentheses
From: Roel Kluin <roel.kluin@gmail.com>

not(!) has a higher precedence than bit and(&).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/include/plat/control.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-omap/include/plat/control.h~omap3-add-missing-parentheses arch/arm/plat-omap/include/plat/control.h
--- a/arch/arm/plat-omap/include/plat/control.h~omap3-add-missing-parentheses
+++ a/arch/arm/plat-omap/include/plat/control.h
@@ -147,7 +147,7 @@
 #define OMAP343X_CONTROL_IVA2_BOOTADDR	(OMAP2_CONTROL_GENERAL + 0x0190)
 #define OMAP343X_CONTROL_IVA2_BOOTMOD	(OMAP2_CONTROL_GENERAL + 0x0194)
 #define OMAP343X_CONTROL_DEBOBS(i)	(OMAP2_CONTROL_GENERAL + 0x01B0 \
-					+ ((i) >> 1) * 4 + (!(i) & 1) * 2)
+					+ ((i) >> 1) * 4 + (!((i) & 1)) * 2)
 #define OMAP343X_CONTROL_PROG_IO0	(OMAP2_CONTROL_GENERAL + 0x01D4)
 #define OMAP343X_CONTROL_PROG_IO1	(OMAP2_CONTROL_GENERAL + 0x01D8)
 #define OMAP343X_CONTROL_DSS_DPLL_SPREADING	(OMAP2_CONTROL_GENERAL + 0x01E0)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
omap3-add-missing-parentheses.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
ieee80211-add-missing-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

