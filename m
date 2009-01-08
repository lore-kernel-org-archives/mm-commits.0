From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-corresponding-maintainers-entry.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:20 -0800
Message-ID: <200901082246.n08MkKXc025849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761019AbZAHWu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add the corresponding MAINTAINERS entry
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-corresponding-maintainers-entry.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add the corresponding MAINTAINERS entry
From: Catalin Marinas <catalin.marinas@arm.com>

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~kmemleak-add-the-corresponding-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~kmemleak-add-the-corresponding-maintainers-entry
+++ a/MAINTAINERS
@@ -2516,6 +2516,12 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
+KERNEL MEMORY LEAK DETECTOR
+P:	Catalin Marinas
+M:	catalin.marinas@arm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

