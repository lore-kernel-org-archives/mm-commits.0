From: akpm@linux-foundation.org
Subject: - add-3c59x-maintainer.patch removed from -mm tree
Date: Thu, 13 Sep 2007 01:53:07 -0700
Message-ID: <200709130853.l8D8r7LD010605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758481AbXIMIxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 04:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klassert@mathematik.tu-chemnitz.de, mm-commits@vger.kernel.org


The patch titled
     3c59x maintainer
has been removed from the -mm tree.  Its filename was
     add-3c59x-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 3c59x maintainer
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>

Add 3c59x maintainer.

Signed-off-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~add-3c59x-maintainer MAINTAINERS
--- a/MAINTAINERS~add-3c59x-maintainer
+++ a/MAINTAINERS
@@ -104,6 +104,12 @@ M:	klassert@mathematik.tu-chemnitz.de
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+3C59X NETWORK DRIVER
+P:	Steffen Klassert
+M:	klassert@mathematik.tu-chemnitz.de
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 3CR990 NETWORK DRIVER
 P:	David Dillow
 M:	dave@thedillows.org
_

Patches currently in -mm which might be from klassert@mathematik.tu-chemnitz.de are

add-3c59x-maintainer.patch
wol-bugfix-for-3c59xc.patch
