From: akpm@linux-foundation.org
Subject: [merged] acpi-remove-nid_inval.patch removed from -mm tree
Date: Wed, 03 Aug 2011 11:59:54 -0700
Message-ID: <201108031857.p73IvNBG006732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282Ab1HCS55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove NID_INVAL
has been removed from the -mm tree.  Its filename was
     acpi-remove-nid_inval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove NID_INVAL
From: David Rientjes <rientjes@google.com>

b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over uses of
NID_INVAL, but didn't actually remove the definition.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/acpi.h~acpi-remove-nid_inval include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-remove-nid_inval
+++ a/include/linux/acpi.h
@@ -238,7 +238,6 @@ extern int acpi_paddr_to_node(u64 start_
 extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
-#define NID_INVAL	(-1)
 
 int acpi_check_resource_conflict(const struct resource *res);
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch

