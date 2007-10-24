From: akpm@linux-foundation.org
Subject: + add-missing-section-id-to-lsmtmpl.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:42 -0700
Message-ID: <200710242250.l9OMogIV016576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757269AbXJXWuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add missing section ID to lsm.tmpl
has been added to the -mm tree.  Its filename is
     add-missing-section-id-to-lsmtmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
