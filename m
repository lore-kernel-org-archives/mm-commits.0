From: akpm@linux-foundation.org
Subject: + add-missing-entries-to-documentation-arm-00-index.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:24:44 -0700
Message-ID: <200710032124.l93LOiVg009449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXJCVY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net


The patch titled
     Add missing entries to Documentation/arm/00-INDEX
has been added to the -mm tree.  Its filename is
     add-missing-entries-to-documentation-arm-00-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add missing entries to Documentation/arm/00-INDEX
From: Rob Landley <rob@landley.net>

Add several missing entries to Documentation/arm/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/arm/00-INDEX~add-missing-entries-to-documentation-arm-00-index Documentation/arm/00-INDEX
--- a/Documentation/arm/00-INDEX~add-missing-entries-to-documentation-arm-00-index
+++ a/Documentation/arm/00-INDEX
@@ -4,19 +4,29 @@ Booting
 	- requirements for booting
 Interrupts
 	- ARM Interrupt subsystem documentation
+IXP2000
+	- Release Notes for Linux on Intel's IXP2000 Network Processor
 Netwinder
 	- Netwinder specific documentation
+Porting
+       - Symbol definitions for porting Linux to a new ARM machine.
+Setup
+       - Kernel initialization parameters on ARM Linux
 README
 	- General ARM documentation
-SA1100
+SA1100/
 	- SA1100 documentation
-XScale
-	- XScale documentation
-empeg
-	- Empeg documentation
+Samsung-S3C24XX
+	- S3C24XX ARM Linux Overview
+Sharp-LH
+	- Linux on Sharp LH79524 and LH7A40X System On a Chip (SOC)
+VFP/
+	- Release notes for Linux Kernel Vector Floating Point support code
+empeg/
+	- Ltd's Empeg MP3 Car Audio Player
 mem_alignment
 	- alignment abort handler documentation
 memory.txt
 	- description of the virtual memory layout
-nwfpe
+nwfpe/
 	- NWFPE floating point emulator documentation
_

Patches currently in -mm which might be from rob@landley.net are

docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-missing-entries-to-documentation-arm-00-index.patch
