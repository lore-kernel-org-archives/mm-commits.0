From: akpm@linux-foundation.org
Subject: - codingstyle-add-information-about-trailing-whitespace.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:31 -0700
Message-ID: <200707162058.l6GKwV6N002350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756866AbXGPVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josht@linux.vnet.ibm.com, josh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     CodingStyle: add information about trailing whitespace
has been removed from the -mm tree.  Its filename was
     codingstyle-add-information-about-trailing-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CodingStyle: add information about trailing whitespace
From: Josh Triplett <josht@linux.vnet.ibm.com>

Signed-off-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/CodingStyle~codingstyle-add-information-about-trailing-whitespace Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-add-information-about-trailing-whitespace
+++ a/Documentation/CodingStyle
@@ -218,6 +218,18 @@ no space after the prefix increment & de
 
 and no space around the '.' and "->" structure member operators.
 
+Do not leave trailing whitespace at the ends of lines.  Some editors with
+"smart" indentation will insert whitespace at the beginning of new lines as
+appropriate, so you can start typing the next line of code right away.
+However, some such editors do not remove the whitespace if you end up not
+putting a line of code there, such as if you leave a blank line.  As a result,
+you end up with lines containing trailing whitespace.
+
+Git will warn you about patches that introduce trailing whitespace, and can
+optionally strip the trailing whitespace for you; however, if applying a series
+of patches, this may make later patches in the series fail by changing their
+context lines.
+
 
 		Chapter 4: Naming
 
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

origin.patch
