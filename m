From: akpm@osdl.org
Subject: + remove-the-unused-kernel-config-option-video_videobuf.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:38:20 -0800
Message-ID: <200701250538.l0P5cKcw007011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbXAYFi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, mchehab@infradead.org


The patch titled
     Remove the unused kernel config option VIDEO_VIDEOBUF
has been added to the -mm tree.  Its filename is
     remove-the-unused-kernel-config-option-video_videobuf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove the unused kernel config option VIDEO_VIDEOBUF
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/common/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/media/common/Kconfig~remove-the-unused-kernel-config-option-video_videobuf drivers/media/common/Kconfig
--- a/drivers/media/common/Kconfig~remove-the-unused-kernel-config-option-video_videobuf
+++ a/drivers/media/common/Kconfig
@@ -5,8 +5,4 @@ config VIDEO_SAA7146
 config VIDEO_SAA7146_VV
 	tristate
 	select VIDEO_BUF
-	select VIDEO_VIDEOBUF
 	select VIDEO_SAA7146
-
-config VIDEO_VIDEOBUF
-	tristate
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
remove-unused-kernel-config-option-dlci_count.patch
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
