From: akpm@linux-foundation.org
Subject: [merged] drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch removed from -mm tree
Date: Wed, 02 Sep 2009 12:08:05 -0700
Message-ID: <200909021908.n82J85MX010081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbZIBTJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm/i915: intel_sdvo_multifunc_encoder() SDVO_OUTPUT_SVID0 tested twice
has been removed from the -mm tree.  Its filename was
     drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: intel_sdvo_multifunc_encoder() SDVO_OUTPUT_SVID0 tested twice
From: Roel Kluin <roel.kluin@gmail.com>

Bit SDVO_OUTPUT_SVID0 is tested twice

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_sdvo.c~drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice drivers/gpu/drm/i915/intel_sdvo.c
--- a/drivers/gpu/drm/i915/intel_sdvo.c~drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice
+++ a/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1457,7 +1457,7 @@ intel_sdvo_multifunc_encoder(struct inte
 		(SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1))
 		caps++;
 	if (sdvo_priv->caps.output_flags &
-		(SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_SVID0))
+		(SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_SVID1))
 		caps++;
 	if (sdvo_priv->caps.output_flags &
 		(SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_CVBS1))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
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
st-fix-test-of-value-range-in-st_set_options-fix.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

