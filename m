From: akpm@linux-foundation.org
Subject: - include-kernelh-from-configfsh.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:29 -0500
Message-ID: <200802150719.m1F7JpWF025741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763606AbYBOH3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bn@niasdigital.com, Joel.Becker@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Include kernel.h from configfs.h
has been removed from the -mm tree.  Its filename was
     include-kernelh-from-configfsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Include kernel.h from configfs.h
From: Ben Nizette <bn@niasdigital.com>

configfs.h uses the container_of macro and as such should include kernel.h.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/configfs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/configfs.h~include-kernelh-from-configfsh include/linux/configfs.h
--- a/include/linux/configfs.h~include-kernelh-from-configfsh
+++ a/include/linux/configfs.h
@@ -37,6 +37,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
_

Patches currently in -mm which might be from bn@niasdigital.com are

origin.patch
git-avr32.patch
