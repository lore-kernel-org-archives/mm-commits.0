From: akpm@osdl.org
Subject: + remove-dead-kernel-config-option-aedsp16_mpu401.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:45:50 -0800
Message-ID: <200701250445.l0P4jowv006091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbXAYEtE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, bunk@stusta.de


The patch titled
     Remove dead kernel config option AEDSP16_MPU401.
has been added to the -mm tree.  Its filename is
     remove-dead-kernel-config-option-aedsp16_mpu401.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove dead kernel config option AEDSP16_MPU401.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the dead kernel config option AEDSP16_MPU401.

Signed-off-by: Robert P. J. Day <mindspring.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/oss/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN sound/oss/Kconfig~remove-dead-kernel-config-option-aedsp16_mpu401 sound/oss/Kconfig
--- a/sound/oss/Kconfig~remove-dead-kernel-config-option-aedsp16_mpu401
+++ a/sound/oss/Kconfig
@@ -705,18 +705,6 @@ config AEDSP16_SBPRO
 
 endchoice
 
-config AEDSP16_MPU401
-	bool "Audio Excel DSP 16 (MPU401 emulation)"
-	depends on SOUND_AEDSP16 && SOUND_MPU401
-	help
-	  Answer Y if you want your audio card to emulate the MPU-401 midi
-	  interface. You should then also say Y to "MPU-401 support".
-
-	  Note that the I/O base for MPU-401 support of aedsp16 is the same
-	  you have selected for "MPU-401 support". If you are using this
-	  driver as a module you have to specify the MPU I/O base address with
-	  the parameter 'mpu_base=0xNNN'.
-
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
 	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500) && SOUND_OSS
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
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
oss-replace-kmallocmemset-combos-with-kzalloc.patch
