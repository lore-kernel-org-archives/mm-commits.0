From: akpm@linux-foundation.org
Subject: - drivers-edac-add-to-maintainers-new-info.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:33 -0700
Message-ID: <200707192007.l6JK7XHY020272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760650AbXGSUQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add to maintainers new info
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-to-maintainers-new-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add to maintainers new info
From: Douglas Thompson <dougthompson@xmission.com>

Update maintainer information on edac components

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~drivers-edac-add-to-maintainers-new-info MAINTAINERS
--- a/MAINTAINERS~drivers-edac-add-to-maintainers-new-info
+++ a/MAINTAINERS
@@ -1352,21 +1352,23 @@ S:	Supported
 
 EDAC-CORE
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
 
 EDAC-E752X
 P:	Mark Gross
+P:	Doug Thompson
 M:	mark.gross@intel.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
 EDAC-E7XXX
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -1387,7 +1389,23 @@ S:	Maintained
 
 EDAC-I5000
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I82975X
+P:	Ranganathan Desikan
+P:	Arvind R.
+M:	rdesikan@jetzbroadband.com
+M:	arvind@acarlab.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-PASEMI
+P:	Egor Martovetsky
+M:	egor@pasemi.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
