From: akpm@osdl.org
Subject: + remove-unused-kernel-config-option-paride_parport.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:35:50 -0800
Message-ID: <200701250535.l0P5ZosS006970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933246AbXAYFfw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:35:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove unused kernel config option PARIDE_PARPORT
has been added to the -mm tree.  Its filename is
     remove-unused-kernel-config-option-paride_parport.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused kernel config option PARIDE_PARPORT
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option PARIDE_PARPORT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/block/paride/Kconfig~remove-unused-kernel-config-option-paride_parport drivers/block/paride/Kconfig
--- a/drivers/block/paride/Kconfig~remove-unused-kernel-config-option-paride_parport
+++ a/drivers/block/paride/Kconfig
@@ -2,14 +2,8 @@
 # PARIDE configuration
 #
 # PARIDE doesn't need PARPORT, but if PARPORT is configured as a module,
-# PARIDE must also be a module.  The bogus CONFIG_PARIDE_PARPORT option
-# controls the choices given to the user ...
+# PARIDE must also be a module.
 # PARIDE only supports PC style parports. Tough for USB or other parports...
-config PARIDE_PARPORT
-	tristate
-	depends on PARIDE!=n
-	default m if PARPORT_PC=m
-	default y if PARPORT_PC!=m
 
 comment "Parallel IDE high-level drivers"
 	depends on PARIDE
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-unused-kernel-config-option-x86_xadd.patch
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
