From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch removed from -mm tree
Date: Mon, 08 Jul 2013 15:34:28 -0700
Message-ID: <51db3e74.xsD3k45EpMH+R0rW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3GHWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, tglx@linutronix.de, rmk@arm.linux.org.uk, mingo@elte.hu, hpa@zytor.com, florian@openwrt.org, bp@alien8.de, kyungsik.lee@lge.com

Subject: [folded-merged] x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch removed from -mm tree
To: kyungsik.lee@lge.com,bp@alien8.de,florian@openwrt.org,hpa@zytor.com,mingo@elte.hu,rmk@arm.linux.org.uk,tglx@linutronix.de,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:34:28 -0700


The patch titled
     Subject: x86, doc: Add LZ4 magic number for the new compression
has been removed from the -mm tree.  Its filename was
     x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch

This patch was dropped because it was folded into arm-add-support-for-lz4-compressed-kernel.patch

------------------------------------------------------
From: Kyungsik Lee <kyungsik.lee@lge.com>
Subject: x86, doc: Add LZ4 magic number for the new compression

Documentation/x86/boot.txt is updated to list the LZ4 magic number.
This LZ4 magic number is used for the new compression format.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/boot.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/x86/boot.txt~x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression Documentation/x86/boot.txt
--- a/Documentation/x86/boot.txt~x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression
+++ a/Documentation/x86/boot.txt
@@ -657,9 +657,10 @@ Protocol:	2.08+
   uncompressed data should be determined using the standard magic
   numbers.  The currently supported compression formats are gzip
   (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
-  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
-  payload is currently always ELF (magic number 7F 45 4C 46).
-  
+  (magic number 5D 00), XZ (magic number FD 37), and LZ4 (magic number
+  02 21).  The uncompressed payload is currently always ELF (magic
+  number 7F 45 4C 46).
+
 Field name:	payload_length
 Type:		read
 Offset/size:	0x24c/4
_

Patches currently in -mm which might be from kyungsik.lee@lge.com are

lib-add-weak-clz-ctz-functions.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch
arm-add-support-for-lz4-compressed-kernel.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

