From: akpm@linux-foundation.org
Subject: - docbook-html-generate-chapter-section-level-tocs-for-functions.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:49 -0800
Message-ID: <200702112252.l1BMqnFG016056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60304 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbXBKWwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pisa@cmp.felk.cvut.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     DocBook/HTML: Generate chapter/section level TOCs for functions
has been removed from the -mm tree.  Its filename was
     docbook-html-generate-chapter-section-level-tocs-for-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DocBook/HTML: Generate chapter/section level TOCs for functions
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Simple increase of section TOC level generation significantly enhances
navigation experience through generated kernel API documentation.

This change restores back state from SGML tools time.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/stylesheet.xsl |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/DocBook/stylesheet.xsl~docbook-html-generate-chapter-section-level-tocs-for-functions Documentation/DocBook/stylesheet.xsl
--- a/Documentation/DocBook/stylesheet.xsl~docbook-html-generate-chapter-section-level-tocs-for-functions
+++ a/Documentation/DocBook/stylesheet.xsl
@@ -4,4 +4,5 @@
 <param name="funcsynopsis.style">ansi</param>
 <param name="funcsynopsis.tabular.threshold">80</param>
 <!-- <param name="paper.type">A4</param> -->
+<param name="generate.section.toc.level">2</param>
 </stylesheet>
_

Patches currently in -mm which might be from pisa@cmp.felk.cvut.cz are

origin.patch
arm-imx-serial-fix-tx-buffer-overflows.patch
