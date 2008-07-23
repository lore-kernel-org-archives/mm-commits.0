From: akpm@linux-foundation.org
Subject: - remove-the-oss-trident-driver-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:25:05 -0700
Message-ID: <200807232337.m6NNbgWs018093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbYGWXjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     remove the OSS trident driver fix
has been removed from the -mm tree.  Its filename was
     remove-the-oss-trident-driver-fix.patch

This patch was dropped because it was folded into remove-the-oss-trident-driver.patch

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

origin.patch
remove-the-oss-trident-driver.patch
remove-the-oss-trident-driver-fix.patch

