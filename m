From: akpm@osdl.org
Subject: + remove-unused-kernel-config-option-dlci_count.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:37:00 -0800
Message-ID: <200701250537.l0P5b0VJ006991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbXAYFhW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, davem@davemloft.net, jeff@garzik.org


The patch titled
     Remove unused kernel config option DLCI_COUNT
has been added to the -mm tree.  Its filename is
     remove-unused-kernel-config-option-dlci_count.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused kernel config option DLCI_COUNT
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option DLCI_COUNT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa {khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wan/Kconfig |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/net/wan/Kconfig~remove-unused-kernel-config-option-dlci_count drivers/net/wan/Kconfig
--- a/drivers/net/wan/Kconfig~remove-unused-kernel-config-option-dlci_count
+++ a/drivers/net/wan/Kconfig
@@ -344,17 +344,6 @@ config DLCI
 	  To compile this driver as a module, choose M here: the
 	  module will be called dlci.
 
-config DLCI_COUNT
-	int "Max open DLCI"
-	depends on DLCI
-	default "24"
-	help
-	  Maximal number of logical point-to-point frame relay connections
-	  (the identifiers of which are called DCLIs) that the driver can
-	  handle.
-
-	  The default is probably fine.
-
 config DLCI_MAX
 	int "Max DLCI per device"
 	depends on DLCI
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
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
