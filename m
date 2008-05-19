From: akpm@linux-foundation.org
Subject: + remove-the-oss-trident-driver-fix.patch added to -mm tree
Date: Mon, 19 May 2008 14:21:19 -0700
Message-ID: <200805192121.m4JLLJ9W021091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760604AbYESVXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, bunk@stusta.de


The patch titled
     remove the OSS trident driver fix
has been added to the -mm tree.  Its filename is
     remove-the-oss-trident-driver-fix.patch

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
Subject: remove the OSS trident driver fix
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN CREDITS~remove-the-oss-trident-driver-fix CREDITS
--- a/CREDITS~remove-the-oss-trident-driver-fix
+++ a/CREDITS
@@ -317,6 +317,14 @@ S: 2322 37th Ave SW
 S: Seattle, Washington 98126-2010
 S: USA
 
+N: Muli Ben-Yehuda
+E: mulix@mulix.org
+E: muli@il.ibm.com
+W: http://www.mulix.org
+D: trident OSS sound driver, x86-64 dma-ops and Calgary IOMMU,
+D: KVM and Xen bits and other misc. hackery.
+S: Haifa, Israel
+
 N: Johannes Berg
 E: johannes@sipsolutions.net
 W: http://johannes.sipsolutions.net/
_

Patches currently in -mm which might be from muli@il.ibm.com are

remove-the-oss-trident-driver.patch
remove-the-oss-trident-driver-fix.patch
oss-trident-switch-from-write_proc.patch

