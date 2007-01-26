From: akpm@osdl.org
Subject: + boot-loader-id-for-gujin.patch added to -mm tree
Date: Fri, 26 Jan 2007 13:12:40 -0800
Message-ID: <200701262112.l0QLCeFX026655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXAZVNk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 16:13:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@anvin.org, hpa@zytor.com


The patch titled
     Boot loader ID for Gujin
has been added to the -mm tree.  Its filename is
     boot-loader-id-for-gujin.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Boot loader ID for Gujin
From: "H. Peter Anvin" <hpa@anvin.org>

Add an official boot loader ID for Gujin.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/i386/boot.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/i386/boot.txt~boot-loader-id-for-gujin Documentation/i386/boot.txt
--- a/Documentation/i386/boot.txt~boot-loader-id-for-gujin
+++ a/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2006-11-17
+			Last update 2007-01-26
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -186,6 +186,7 @@ filled out, however:
 	7  GRuB
 	8  U-BOOT
 	9  Xen
+	A  Gujin
 
 	Please contact <hpa@zytor.com> if you need a bootloader ID
 	value assigned.
_

Patches currently in -mm which might be from hpa@anvin.org are

boot-loader-id-for-gujin.patch
