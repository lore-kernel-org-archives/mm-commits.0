From: akpm@linux-foundation.org
Subject: - add-missing-section-id-to-lsmtmpl.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:01 -0800
Message-ID: <200802080801.m1881glw013983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbYBHIBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add missing section ID to lsm.tmpl
has been removed from the -mm tree.  Its filename was
     add-missing-section-id-to-lsmtmpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add missing section ID to lsm.tmpl
From: Rob Landley <rob@landley.net>

Add missing section ID to lsm.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/lsm.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/lsm.tmpl~add-missing-section-id-to-lsmtmpl Documentation/DocBook/lsm.tmpl
--- a/Documentation/DocBook/lsm.tmpl~add-missing-section-id-to-lsmtmpl
+++ a/Documentation/DocBook/lsm.tmpl
@@ -33,7 +33,7 @@
  </authorgroup>
  </articleinfo>
 
-<sect1><title>Introduction</title>
+<sect1 id="Introduction"><title>Introduction</title>
 
 <para>
 In March 2001, the National Security Agency (NSA) gave a presentation
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
