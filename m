From: akpm@linux-foundation.org
Subject: + prism54-maintainers-update.patch added to -mm tree
Date: Wed, 30 May 2007 13:38:13 -0700
Message-ID: <200705302038.l4UKcDhN004065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758750AbXE3UjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 16:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcgrof@gmail.com, linville@tuxdriver.com


The patch titled
     prism54: MAINTAINERS update
has been added to the -mm tree.  Its filename is
     prism54-maintainers-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: prism54: MAINTAINERS update
From: "Luis R. Rodriguez" <mcgrof@gmail.com>

Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~prism54-maintainers-update MAINTAINERS
--- a/MAINTAINERS~prism54-maintainers-update
+++ a/MAINTAINERS
@@ -2885,8 +2885,8 @@ W:	ftp://ftp.kernel.org/pub/linux/kernel
 S:	Supported
 
 PRISM54 WIRELESS DRIVER
-P:	Prism54 Development Team
-M:	developers@islsm.org
+P:	Luis R. Rodriguez
+M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from mcgrof@gmail.com are

git-wireless.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
prism54-maintainers-update.patch
