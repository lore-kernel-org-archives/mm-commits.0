From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-fix-usage-comment.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:25:57 -0800
Message-ID: <200911131925.nADJPvSW026953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180AbZKMTZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer: fix usage comment
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-usage-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer: fix usage comment
From: Roel Kluin <roel.kluin@gmail.com>

With the `s' it just won't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/get_maintainer.pl~get_maintainer-fix-usage-comment scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-fix-usage-comment
+++ a/scripts/get_maintainer.pl
@@ -5,8 +5,8 @@
 # Print selected MAINTAINERS information for
 # the files modified in a patch or for a file
 #
-# usage: perl scripts/get_maintainers.pl [OPTIONS] <patch>
-#        perl scripts/get_maintainers.pl [OPTIONS] -f <file>
+# usage: perl scripts/get_maintainer.pl [OPTIONS] <patch>
+#        perl scripts/get_maintainer.pl [OPTIONS] -f <file>
 #
 # Licensed under the terms of the GNU GPL License version 2
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

spi-error-status-should-be-negative.patch
drivers-video-da8xx-fbc-fix-error-return.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors.patch
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

