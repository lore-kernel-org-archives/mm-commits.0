From: akpm@osdl.org
Subject: + docbook-html-generate-chapter-section-level-tocs-for-functions.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:53:32 -0800
Message-ID: <200701022153.l02LrWMB031030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbXABVxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pisa@cmp.felk.cvut.cz, rdunlap@xenotime.net


The patch titled
     DocBook/HTML: Generate chapter/section level TOCs for functions
has been added to the -mm tree.  Its filename is
     docbook-html-generate-chapter-section-level-tocs-for-functions.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DocBook/HTML: Generate chapter/section level TOCs for functions
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Simple increase of section TOC level generation significantly enhances
navigation experience through generated kernel API documentation.

This change restores back state from SGML tools time.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DocBook/stylesheet.xsl |    1 +
 1 files changed, 1 insertion(+)

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

docbook-html-generate-chapter-section-level-tocs-for-functions.patch
