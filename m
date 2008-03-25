From: akpm@linux-foundation.org
Subject: - kernel-parameterstxt-document-memmap-option-better.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:26 -0700
Message-ID: <200803252229.m2PMTQ68016808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbYCYWaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, dl9pf@gmx.de, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     kernel-parameters.txt: document memmap option better
has been removed from the -mm tree.  Its filename was
     kernel-parameterstxt-document-memmap-option-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-parameters.txt: document memmap option better
From: Pavel Machek <pavel@ucw.cz>

Provide example for memmap exclude option (it is slightly strange and
non-trivial) and provide nice small HOWTO for people with bad memory.

Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>
Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/kernel-parameters.txt~kernel-parameterstxt-document-memmap-option-better Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-parameterstxt-document-memmap-option-better
+++ a/Documentation/kernel-parameters.txt
@@ -1130,6 +1130,10 @@ and is between 256 and 4096 characters. 
 	memmap=nn[KMG]$ss[KMG]
 			[KNL,ACPI] Mark specific memory as reserved.
 			Region of memory to be used, from ss to ss+nn.
+			Example: Exclude memory from 0x18690000-0x1869ffff
+			         memmap=64K$0x18690000
+			         or
+			         memmap=0x10000$0x18690000
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-x86.patch
git-acpi.patch
pm-remove-destroy_suspended_device.patch
pm-remove-destroy_suspended_device-checkpatch-fixes.patch
git-hrt.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

