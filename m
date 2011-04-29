From: akpm@linux-foundation.org
Subject: [merged] maintainers-re-alphabetize-xen-entries.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:46:43 -0700
Message-ID: <201104291941.p3TJfE9a011433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab1D2TmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: re-alphabetize Xen entries
has been removed from the -mm tree.  Its filename was
     maintainers-re-alphabetize-xen-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: re-alphabetize Xen entries
From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN MAINTAINERS~maintainers-re-alphabetize-xen-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-re-alphabetize-xen-entries
+++ a/MAINTAINERS
@@ -6921,6 +6921,18 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/platform/x86
 
+XEN HYPERVISOR INTERFACE
+M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	virtualization@lists.linux-foundation.org
+S:	Supported
+F:	arch/x86/xen/
+F:	drivers/*/xen-*front.c
+F:	drivers/xen/
+F:	arch/x86/include/asm/xen/
+F:	include/xen/
+
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
@@ -6942,18 +6954,6 @@ S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
 
-XEN HYPERVISOR INTERFACE
-M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
-M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-L:	virtualization@lists.linux-foundation.org
-S:	Supported
-F:	arch/x86/xen/
-F:	drivers/*/xen-*front.c
-F:	drivers/xen/
-F:	arch/x86/include/asm/xen/
-F:	include/xen/
