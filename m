From: akpm@linux-foundation.org
Subject: - uml-fix-apparent-config_64_bit-typo.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:29 -0800
Message-ID: <200702112249.l1BMnT72015757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbXBKWtc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix apparent "CONFIG_64_BIT" typo.
has been removed from the -mm tree.  Its filename was
     uml-fix-apparent-config_64_bit-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix apparent "CONFIG_64_BIT" typo.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix apparent typo, where CONFIG_64_BIT should read CONFIG_64BIT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/elf-ppc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-um/elf-ppc.h~uml-fix-apparent-config_64_bit-typo include/asm-um/elf-ppc.h
--- a/include/asm-um/elf-ppc.h~uml-fix-apparent-config_64_bit-typo
+++ a/include/asm-um/elf-ppc.h
@@ -11,7 +11,7 @@ extern long elf_aux_hwcap;
 
 #define elf_check_arch(x) (1)
 
-#ifdef CONFIG_64_BIT
+#ifdef CONFIG_64BIT
 #define ELF_CLASS ELFCLASS64
 #else
 #define ELF_CLASS ELFCLASS32
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
