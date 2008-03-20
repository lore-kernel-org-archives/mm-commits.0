From: akpm@linux-foundation.org
Subject: + kernel-parameterstxt-document-memmap-option-better.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:56:32 -0700
Message-ID: <200803202156.m2KLuWPJ026095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490AbYCTV4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 17:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, dl9pf@gmx.de, pavel@suse.cz


The patch titled
     kernel-parameters.txt: document memmap option better
has been added to the -mm tree.  Its filename is
     kernel-parameterstxt-document-memmap-option-better.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1141,6 +1141,10 @@ and is between 256 and 4096 characters. 
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

git-x86.patch
git-acpi.patch
git-hrt.patch
x86-fix-aperture-vs-suspend-problem.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
kernel-parameterstxt-document-memmap-option-better.patch

