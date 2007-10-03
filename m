From: akpm@linux-foundation.org
Subject: + add-documentation-w1w1-masters-00-index.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:17:33 -0700
Message-ID: <200710032117.l93LHXI0009109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbXJCVTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:19:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, johnpol@2ka.mipt.ru


The patch titled
     Add Documentation/{w1,w1/masters}/00-INDEX
has been added to the -mm tree.  Its filename is
     add-documentation-w1w1-masters-00-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add Documentation/{w1,w1/masters}/00-INDEX
From: Rob Landley <rob@landley.net>

Two 00-INDEX files under Documentation/w1

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN /dev/null Documentation/w1/00-INDEX
--- /dev/null
+++ a/Documentation/w1/00-INDEX
@@ -0,0 +1,8 @@
+00-INDEX
+	- This file
+masters/
+	- Individual chips providing 1-wire busses.
+w1.generic
+	- The 1-wire (w1) bus
+w1.netlink
+	- Userspace communication protocol over connector [1].
diff -puN /dev/null Documentation/w1/masters/00-INDEX
--- /dev/null
+++ a/Documentation/w1/masters/00-INDEX
@@ -0,0 +1,6 @@
+00-INDEX
+	- This file
+ds2482
+	- The Maixm/Dallas Semiconductor DS2482 provides 1-wire busses.
+ds2490
+	- The Maixm/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
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
