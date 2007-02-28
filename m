From: akpm@linux-foundation.org
Subject: - kvm-bump-api-version.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:55:09 -0800
Message-ID: <200702282355.l1SNt97B031253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48564 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756AbXB1XzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: bump API version
has been removed from the -mm tree.  Its filename was
     kvm-bump-api-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: bump API version
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kvm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kvm.h~kvm-bump-api-version include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-bump-api-version
+++ a/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 3
+#define KVM_API_VERSION 4
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
