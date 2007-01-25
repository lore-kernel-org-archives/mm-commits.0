From: akpm@osdl.org
Subject: + remove-unused-kernel-config-option-x86_xadd.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:53:13 -0800
Message-ID: <200701250453.l0P4rD1N006209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221AbXAYExV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, ak@muc.de


The patch titled
     Remove unused kernel config option X86_XADD
has been added to the -mm tree.  Its filename is
     remove-unused-kernel-config-option-x86_xadd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused kernel config option X86_XADD
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option X86_XADD, which is unused in any
source or header file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig.cpu |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/i386/Kconfig.cpu~remove-unused-kernel-config-option-x86_xadd arch/i386/Kconfig.cpu
--- a/arch/i386/Kconfig.cpu~remove-unused-kernel-config-option-x86_xadd
+++ a/arch/i386/Kconfig.cpu
@@ -226,11 +226,6 @@ config X86_CMPXCHG
 	depends on !M386
 	default y
 
-config X86_XADD
-	bool
-	depends on !M386
-	default y
-
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || X86_GENERIC
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
remove-unused-kernel-config-option-x86_xadd.patch
