From: akpm@linux-foundation.org
Subject: + add-entries-to-documentation-powerpc.patch added to -mm tree
Date: Thu, 04 Oct 2007 13:30:28 -0700
Message-ID: <200710042030.l94KUS2g027285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbXJDUam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 16:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net


The patch titled
     Add entries to Documentation/powerpc
has been added to the -mm tree.  Its filename is
     add-entries-to-documentation-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add entries to Documentation/powerpc
From: Rob Landley <rob@landley.net>

Add two missing entries to Documentation/powerpc/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/powerpc/00-INDEX~add-entries-to-documentation-powerpc Documentation/powerpc/00-INDEX
--- a/Documentation/powerpc/00-INDEX~add-entries-to-documentation-powerpc
+++ a/Documentation/powerpc/00-INDEX
@@ -5,6 +5,8 @@ please mail me.
 
 00-INDEX
 	- this file
+booting-without-of.txt
+	- Booting the Linux/ppc kernel without Open Firmware
 cpu_features.txt
 	- info on how we support a variety of CPUs with minimal compile-time
 	options.
@@ -14,6 +16,8 @@ hvcs.txt
 	- IBM "Hypervisor Virtual Console Server" Installation Guide
 mpc52xx.txt
 	- Linux 2.6.x on MPC52xx family
+mpc52xx-device-tree-bindings.txt
+	- MPC5200 Device Tree Bindings
 ppc_htab.txt
 	- info about the Linux/PPC /proc/ppc_htab entry
 SBC8260_memory_mapping.txt
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
update-documentation-scsi-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
