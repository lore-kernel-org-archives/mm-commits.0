From: akpm@linux-foundation.org
Subject: [merged] documentation-fb-vesafbtxt-fix-typo.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:08 -0700
Message-ID: <200906171839.n5HId8Uu005138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbZFQSs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulepanter@users.sourceforge.net, kraxel@goldbach.in-berlin.de, schmoigl@rumms.uni-mannheim.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/fb/vesafb.txt: fix typo
has been removed from the -mm tree.  Its filename was
     documentation-fb-vesafbtxt-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/fb/vesafb.txt: fix typo
From: Paul Menzel <paulepanter@users.sourceforge.net>

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Gerd Knorr <kraxel@goldbach.in-berlin.de>
Cc: Nico Schmoigl <schmoigl@rumms.uni-mannheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/vesafb.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/fb/vesafb.txt~documentation-fb-vesafbtxt-fix-typo Documentation/fb/vesafb.txt
--- a/Documentation/fb/vesafb.txt~documentation-fb-vesafbtxt-fix-typo
+++ a/Documentation/fb/vesafb.txt
@@ -95,7 +95,7 @@ There is no way to change the vesafb vid
 booting linux.  If you are not happy with the 60 Hz refresh rate, you
 have these options:
 
- * configure and load the DOS-Tools for your the graphics board (if
+ * configure and load the DOS-Tools for the graphics board (if
    available) and boot linux with loadlin.
  * use a native driver (matroxfb/atyfb) instead if vesafb.  If none
    is available, write a new one!
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

origin.patch

