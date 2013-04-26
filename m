From: akpm@linux-foundation.org
Subject: + x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch added to -mm tree
Date: Fri, 26 Apr 2013 12:43:44 -0700
Message-ID: <20130426194344.87A5D5A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:54098 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DZTnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 15:43:45 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so236016qea.4
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 12:43:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungsik.lee@lge.com, bp@alien8.de, florian@openwrt.org, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, yann.collet.73@gmail.com


The patch titled
     Subject: x86, doc: Add LZ4 magic number for the new compression
has been added to the -mm tree.  Its filename is
     x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kyungsik Lee <kyungsik.lee@lge.com>
Subject: x86, doc: Add LZ4 magic number for the new compression

Documentation/x86/boot.txt is updated to list the LZ4 magic number.
This LZ4 magic number is used for the new compression format.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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

decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch
lib-add-lz4-compressor-module.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

