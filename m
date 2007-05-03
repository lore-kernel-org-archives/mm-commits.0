From: akpm@linux-foundation.org
Subject: - add-taskstatsh-to-headers-package.patch removed from -mm tree
Date: Thu, 03 May 2007 00:19:43 -0700
Message-ID: <200705030719.l437JhOB007079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbXECHUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 03:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, balbir@linux.vnet.ibm.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     add taskstats.h to headers package
has been removed from the -mm tree.  Its filename was
     add-taskstatsh-to-headers-package.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: add taskstats.h to headers package
From: Don Zickus <dzickus@redhat.com>

taskstats.h is missing from the kernel headers package.  It was designed
to be used from userland, so it should be safe.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~add-taskstatsh-to-headers-package include/linux/Kbuild
--- a/include/linux/Kbuild~add-taskstatsh-to-headers-package
+++ a/include/linux/Kbuild
@@ -318,6 +318,7 @@ unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += sysctl.h
+unifdef-y += taskstats.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
_

Patches currently in -mm which might be from dzickus@redhat.com are

add-taskstatsh-to-headers-package.patch
