From: akpm@linux-foundation.org
Subject: [merged] net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:31:03 -0800
Message-ID: <200911201931.nAKJV3ju012153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbZKTTc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:32:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     net/netfilter/xt_osf.c: xt_osf_remove_callback() should return negative on errors
has been removed from the -mm tree.  Its filename was
     net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/netfilter/xt_osf.c: xt_osf_remove_callback() should return negative on errors
From: Roel Kluin <roel.kluin@gmail.com>

Return a negative error value

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/xt_osf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netfilter/xt_osf.c~net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors net/netfilter/xt_osf.c
--- a/net/netfilter/xt_osf.c~net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors
+++ a/net/netfilter/xt_osf.c
@@ -118,7 +118,7 @@ static int xt_osf_remove_callback(struct
 {
 	struct xt_osf_user_finger *f;
 	struct xt_osf_finger *sf;
-	int err = ENOENT;
+	int err = -ENOENT;
 
 	if (!osf_attrs[OSF_ATTR_FINGER])
 		return -EINVAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
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
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

