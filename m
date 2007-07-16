From: akpm@linux-foundation.org
Subject: - kconfig-no-strange-misc-devices.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:48 -0700
Message-ID: <200707162054.l6GKsmeU001851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbXGPVTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kconfig: no STRANGE misc. devices
has been removed from the -mm tree.  Its filename was
     kconfig-no-strange-misc-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -196,4 +196,4 @@ config THINKPAD_ACPI_BAY
 
 	  If you are not sure, say Y here.
 
-endif # MISC_STRANGE_DEV
+endif # MISC_DEVICES
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch
