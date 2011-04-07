From: akpm@linux-foundation.org
Subject: [alternative-merged] sound-soc-codecs-sn95031c-needs-delayh.patch removed from -mm tree
Date: Thu, 07 Apr 2011 13:11:45 -0700
Message-ID: <201104072009.p37K9b8i030067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565Ab1DGUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 16:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/soc/codecs/sn95031.c needs delay.h
has been removed from the -mm tree.  Its filename was
     sound-soc-codecs-sn95031c-needs-delayh.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/soc/codecs/sn95031.c needs delay.h
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

sound/soc/codecs/sn95031.c: In function 'sn95031_get_mic_bias':
sound/soc/codecs/sn95031.c:153: error: implicit declaration of function 'msleep'

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/sn95031.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/soc/codecs/sn95031.c~sound-soc-codecs-sn95031c-needs-delayh sound/soc/codecs/sn95031.c
--- a/sound/soc/codecs/sn95031.c~sound-soc-codecs-sn95031c-needs-delayh
+++ a/sound/soc/codecs/sn95031.c
@@ -27,6 +27,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <asm/intel_scu_ipc.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

