From: akpm@linux-foundation.org
Subject: - blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch removed from -mm tree
Date: Wed, 30 Apr 2008 00:49:04 -0700
Message-ID: <200804300749.m3U7n4U6002294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756750AbYD3Ht0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 03:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@redhat.com, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch

This patch was dropped because it was folded into blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/serial_core.h~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix include/linux/serial_core.h
--- a/include/linux/serial_core.h~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix
+++ a/include/linux/serial_core.h
@@ -149,8 +149,6 @@
 /* Freescale ColdFire */
 #define PORT_MCF	78
 
-#define PORT_SC26XX	79
-
 /* Blackfin SPORT */
 #define PORT_BFIN_SPORT		79
 
@@ -158,6 +156,8 @@
 #define PORT_MN10300		80
 #define PORT_MN10300_CTS	81
 
+#define PORT_SC26XX	82
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
fuse-fix-race-in-llseek.patch
basic-braille-screen-reader-support.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch

