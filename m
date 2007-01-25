From: akpm@osdl.org
Subject: + remove-unused-kernel-config-option-zisofs_fs.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:52:14 -0800
Message-ID: <200701250452.l0P4qEcB006197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223AbXAYEwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove unused kernel config option ZISOFS_FS
has been added to the -mm tree.  Its filename is
     remove-unused-kernel-config-option-zisofs_fs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused kernel config option ZISOFS_FS
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the kernel config option ZISOFS_FS, since it appears that the actual
option is simply ZISOFS.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/Kconfig~remove-unused-kernel-config-option-zisofs_fs fs/Kconfig
--- a/fs/Kconfig~remove-unused-kernel-config-option-zisofs_fs
+++ a/fs/Kconfig
@@ -675,12 +675,6 @@ config ZISOFS
 	  necessary to create such a filesystem.  Say Y here if you want to be
 	  able to read such compressed CD-ROMs.
 
-config ZISOFS_FS
-# for fs/nls/Config.in
-	tristate
-	depends on ZISOFS
-	default ISO9660_FS
-
 config UDF_FS
 	tristate "UDF file system support"
 	help
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
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
