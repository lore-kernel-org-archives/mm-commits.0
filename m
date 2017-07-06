From: akpm@linux-foundation.org
Subject: [patch 008/108] ramfs: clarify help text that compression
 applies to ramfs as well as legacy ramdisk.
Date: Thu, 06 Jul 2017 15:35:46 -0700
Message-ID: <20170706223546.wCEntK4dX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, mm-commits@vger.kernel.org, rob@landley.net, torvalds@linux-foundation.org

From: Rob Landley <rob@landley.net>
Subject: ramfs: clarify help text that compression applies to ramfs as well as legacy ramdisk.

Clarify help text that compression applies to ramfs as well as legacy ramdisk.

Link: http://lkml.kernel.org/r/f206a960-5a61-cf59-f27c-e9f34872063c@landley.net
Signed-off-by: Rob Landley <rob@landley.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN usr/Kconfig~clarify-help-text-that-compression-applies-to-ramfs-as-well-as-legacy-ramdisk usr/Kconfig
--- a/usr/Kconfig~clarify-help-text-that-compression-applies-to-ramfs-as-well-as-legacy-ramdisk
+++ a/usr/Kconfig
@@ -52,7 +52,7 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip"
+	bool "Support initial ramdisk/ramfs compressed using gzip"
 	depends on BLK_DEV_INITRD
 	default y
 	select DECOMPRESS_GZIP
@@ -61,7 +61,7 @@ config RD_GZIP
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2"
+	bool "Support initial ramdisk/ramfs compressed using bzip2"
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
@@ -70,7 +70,7 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA"
+	bool "Support initial ramdisk/ramfs compressed using LZMA"
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
@@ -79,7 +79,7 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ"
+	bool "Support initial ramdisk/ramfs compressed using XZ"
 	depends on BLK_DEV_INITRD
 	default y
 	select DECOMPRESS_XZ
@@ -88,7 +88,7 @@ config RD_XZ
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO"
+	bool "Support initial ramdisk/ramfs compressed using LZO"
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
@@ -97,7 +97,7 @@ config RD_LZO
 	  If unsure, say N.
 
 config RD_LZ4
-	bool "Support initial ramdisks compressed using LZ4"
+	bool "Support initial ramdisk/ramfs compressed using LZ4"
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZ4
_
