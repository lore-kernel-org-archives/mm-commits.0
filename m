From: akpm@linux-foundation.org
Subject: [merged] drm-kms-fix-confusion-in-drm_fb_helper_connector_parse_command_line.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:10:38 -0800
Message-ID: <201001072110.o07LAcsZ017685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab0AGVLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:11:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, airlied@linux.ie, clemens@ladisch.de, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drm/kms: fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
has been removed from the -mm tree.  Its filename was
     drm-kms-fix-confusion-in-drm_fb_helper_connector_parse_command_line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/kms: fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
From: Roel Kluin <roel.kluin@gmail.com>

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-kms-fix-confusion-in-drm_fb_helper_connector_parse_command_line drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-kms-fix-confusion-in-drm_fb_helper_connector_parse_command_line
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -157,7 +157,7 @@ static bool drm_fb_helper_connector_pars
 			force = DRM_FORCE_ON;
 			break;
 		case 'D':
-			if ((connector->connector_type != DRM_MODE_CONNECTOR_DVII) ||
+			if ((connector->connector_type != DRM_MODE_CONNECTOR_DVII) &&
 			    (connector->connector_type != DRM_MODE_CONNECTOR_HDMIB))
 				force = DRM_FORCE_ON;
 			else
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
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
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

