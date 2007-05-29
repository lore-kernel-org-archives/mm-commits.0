From: akpm@linux-foundation.org
Subject: + kconfig-no-strange-misc-devices.patch added to -mm tree
Date: Tue, 29 May 2007 15:23:23 -0700
Message-ID: <200705292223.l4TMNN35013113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXE2WYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kconfig: no STRANGE misc. devices
has been added to the -mm tree.  Its filename is
     kconfig-no-strange-misc-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kconfig: no STRANGE misc. devices
From: Randy Dunlap <randy.dunlap@oracle.com>

This config symbol name is confusing and unneeded/unwanted, so just
change it to MISC_DEVICES.

*
* Misc devices
*
Misc devices (MISC_STRANGE_DEV) [Y/n] (NEW)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/Kconfig~kconfig-no-strange-misc-devices drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~kconfig-no-strange-misc-devices
+++ a/drivers/misc/Kconfig
@@ -2,11 +2,11 @@
 # Misc strange devices
 #
 
-menuconfig MISC_STRANGE_DEV
+menuconfig MISC_DEVICES
 	bool "Misc devices"
 	default y
 
-if MISC_STRANGE_DEV
+if MISC_DEVICES
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
@@ -205,4 +205,4 @@ config EEPROM_93CX6
 	  This is a driver for the EEPROM chipsets 93c46 and 93c66.
 	  The driver supports both read as well as write commands.
 
-endif # MISC_STRANGE_DEV
+endif # MISC_DEVICES
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
