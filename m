From: akpm@linux-foundation.org
Subject: + add-missing-section-ids-to-genericirqtmpl-updated.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:39 -0700
Message-ID: <200710242250.l9OModFb016573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900AbXJXWuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add missing section IDs to genericirq.tmpl (updated)
has been added to the -mm tree.  Its filename is
     add-missing-section-ids-to-genericirqtmpl-updated.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add missing section IDs to genericirq.tmpl (updated)
From: Rob Landley <rob@landley.net>

Add missing section IDs to genericirq.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/genericirq.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/genericirq.tmpl~add-missing-section-ids-to-genericirqtmpl-updated Documentation/DocBook/genericirq.tmpl
--- a/Documentation/DocBook/genericirq.tmpl~add-missing-section-ids-to-genericirqtmpl-updated
+++ a/Documentation/DocBook/genericirq.tmpl
@@ -269,7 +269,7 @@ noop(irq)
 	</sect2>
 	<sect2 id="Default_flow_handler_implementations">
 	<title>Default flow handler implementations</title>
-	    <sect3>
+	    <sect3 id="Default_Level_IRQ_flow_handler">
 	 	<title>Default Level IRQ flow handler</title>
 		<para>
 		handle_level_irq provides a generic implementation
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
