From: akpm@linux-foundation.org
Subject: - add-missing-section-ids-to-genericirqtmpl-updated.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:23:56 -0800
Message-ID: <200802070323.m173Nb17013679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707AbYBGDXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add missing section IDs to genericirq.tmpl (updated)
has been removed from the -mm tree.  Its filename was
     add-missing-section-ids-to-genericirqtmpl-updated.patch

This patch was dropped because it was folded into add-missing-section-ids-to-genericirqtmpl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
