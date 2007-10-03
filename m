From: akpm@linux-foundation.org
Subject: + tweak-documentation-sm501txt.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:13:24 -0700
Message-ID: <200710032113.l93LDOwa008915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbXJCVOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, ben@simtec.co.uk


The patch titled
     Tweak Documentation/SM501.txt
has been added to the -mm tree.  Its filename is
     tweak-documentation-sm501txt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Tweak Documentation/SM501.txt
From: Rob Landley <rob@landley.net>

The existing Documentation/SM501.txt gives no clue what the chip is or does,
so copy the description from Kconfig help text.

Acked-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/SM501.txt~tweak-documentation-sm501txt Documentation/SM501.txt
--- a/Documentation/SM501.txt~tweak-documentation-sm501txt
+++ a/Documentation/SM501.txt
@@ -3,6 +3,11 @@
 
 Copyright 2006, 2007 Simtec Electronics
 
+The Silicon Motion SM501 multimedia companion chip is a multifunction device
+which may provide numerous interfaces including USB host controller USB gadget,
+Asyncronous Serial ports, Audio functions and a dual display video interface.
+The device may be connected by PCI or local bus with varying functions enabled.
+
 Core
 ----
 
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
