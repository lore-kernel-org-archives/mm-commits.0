From: akpm@linux-foundation.org
Subject: + drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch added to -mm tree
Date: Mon, 10 Aug 2009 23:52:20 -0700
Message-ID: <200908110652.n7B6qKsx000834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZHKLyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, airlied@linux.ie


The patch titled
     drm/i915: intel_sdvo_multifunc_encoder() SDVO_OUTPUT_SVID0 tested twice
has been added to the -mm tree.  Its filename is
     drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch

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
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
ext4-remove-redundant-test-on-unsigned.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

