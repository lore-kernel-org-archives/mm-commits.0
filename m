From: akpm@linux-foundation.org
Subject: + maintainers-re-alphabetize-xen-entries.patch added to -mm tree
Date: Tue, 19 Apr 2011 15:27:58 -0700
Message-ID: <201104192227.p3JMRwXA029209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740Ab1DSW2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 18:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, konrad.wilk@oracle.com


The patch titled
     MAINTAINERS: re-alphabetize Xen entries
has been added to the -mm tree.  Its filename is
     maintainers-re-alphabetize-xen-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -6941,6 +6941,18 @@ T:	git git://git.kernel.org/pub/scm/linu
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
@@ -6962,18 +6974,6 @@ S:	Supported
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
