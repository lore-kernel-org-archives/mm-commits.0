From: akpm@osdl.org
Subject: + remove-useless-reference-to-obsolete-kerneld.patch added to -mm tree
Date: Fri, 26 Jan 2007 13:02:51 -0800
Message-ID: <200701262102.l0QL2piH026460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbXAZVDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 16:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, perex@suse.cz, tiwai@suse.de


The patch titled
     Remove useless reference to obsolete KERNELD
has been added to the -mm tree.  Its filename is
     remove-useless-reference-to-obsolete-kerneld.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove useless reference to obsolete KERNELD
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the final useless reference to the obsolete KERNELD feature.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/core/timer.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN sound/core/timer.c~remove-useless-reference-to-obsolete-kerneld sound/core/timer.c
--- a/sound/core/timer.c~remove-useless-reference-to-obsolete-kerneld
+++ a/sound/core/timer.c
@@ -35,9 +35,6 @@
 #include <sound/minors.h>
 #include <sound/initval.h>
 #include <linux/kmod.h>
-#ifdef CONFIG_KERNELD
-#include <linux/kerneld.h>
-#endif
 
 #if defined(CONFIG_SND_HPET) || defined(CONFIG_SND_HPET_MODULE)
 #define DEFAULT_TIMER_LIMIT 3
_

Patches currently in -mm which might be from rpjday@mindspring.com are

fix-various-kernel-doc-in-header-files.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
git-alsa.patch
remove-useless-reference-to-obsolete-kerneld.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
