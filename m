From: akpm@linux-foundation.org
Subject: [merged] debugobjectsh-fix-trivial-kernel-doc-warning.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:58:50 -0700
Message-ID: <5799046a.W8dYvApCkyaBSjav%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcG0S6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects.h: fix trivial kernel doc warning
has been removed from the -mm tree.  Its filename was
     debugobjectsh-fix-trivial-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: debugobjects.h: fix trivial kernel doc warning

Add ':' to fix trivial kernel-doc warning in <linux/debugobjects.h>:

..//include/linux/debugobjects.h:63: warning: No description found for parameter 'is_static_object'

Link: http://lkml.kernel.org/r/575B01B8.5060600@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debugobjects.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/debugobjects.h~debugobjectsh-fix-trivial-kernel-doc-warning include/linux/debugobjects.h
--- a/include/linux/debugobjects.h~debugobjectsh-fix-trivial-kernel-doc-warning
+++ a/include/linux/debugobjects.h
@@ -38,7 +38,7 @@ struct debug_obj {
  * @name:		name of the object typee
  * @debug_hint:		function returning address, which have associated
  *			kernel symbol, to allow identify the object
- * @is_static_object	return true if the obj is static, otherwise return false
+ * @is_static_object:	return true if the obj is static, otherwise return false
  * @fixup_init:		fixup function, which is called when the init check
  *			fails. All fixup functions must return true if fixup
  *			was successful, otherwise return false
_

Patches currently in -mm which might be from rdunlap@infradead.org are


