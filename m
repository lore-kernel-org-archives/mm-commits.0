From: akpm@osdl.org
Subject: - kvm-add-missing-include.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:00:03 -0800
Message-ID: <200612140600.kBE603Jr001655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbWLNGAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anthony@codemonkey.ws, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Add missing include
has been removed from the -mm tree.  Its filename was
     kvm-add-missing-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Add missing include
From: Anthony Liguori <anthony@codemonkey.ws>

load_TR_desc() lives in asm/desc.h, so #include that file.

Signed-off-by: Anthony Liguori <anthony@codemonkey.ws>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/vmx.c~kvm-add-missing-include drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-missing-include
+++ a/drivers/kvm/vmx.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
+#include <asm/desc.h>
 
 #include "segment_descriptor.h"
 
_

Patches currently in -mm which might be from anthony@codemonkey.ws are


