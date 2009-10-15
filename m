From: akpm@linux-foundation.org
Subject: [merged] sb1250-mac-duplicate-setting-of-bit-v_mac_rx_pl_thrsh4-in-sbmac_channel_start.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:30 -0700
Message-ID: <200910151843.n9FIhUus023334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935273AbZJOSoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sb1250-mac: duplicate setting of bit V_MAC_RX_PL_THRSH(4) in sbmac_channel_start()
has been removed from the -mm tree.  Its filename was
     sb1250-mac-duplicate-setting-of-bit-v_mac_rx_pl_thrsh4-in-sbmac_channel_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sb1250-mac: duplicate setting of bit V_MAC_RX_PL_THRSH(4) in sbmac_channel_start()
From: Roel Kluin <roel.kluin@gmail.com>

The bit V_MAC_RX_PL_THRSH(4) was already set a few lines higher.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/sb1250-mac.c~sb1250-mac-duplicate-setting-of-bit-v_mac_rx_pl_thrsh4-in-sbmac_channel_start drivers/net/sb1250-mac.c
--- a/drivers/net/sb1250-mac.c~sb1250-mac-duplicate-setting-of-bit-v_mac_rx_pl_thrsh4-in-sbmac_channel_start
+++ a/drivers/net/sb1250-mac.c
@@ -1476,7 +1476,6 @@ static void sbmac_channel_start(struct s
 		V_MAC_TX_RL_THRSH(4) |
 		V_MAC_RX_PL_THRSH(4) |
 		V_MAC_RX_RD_THRSH(4) |	/* Must be '4' */
-		V_MAC_RX_PL_THRSH(4) |
 		V_MAC_RX_RL_THRSH(8) |
 		0;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

